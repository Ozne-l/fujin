import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:fujin/app/file_video.dart';
import 'package:fujin/app/providers.dart';
import 'package:fujin/data/voice/voice_recorder.dart';
import 'package:fujin/domain/chat/voice/voice_limits.dart';
import 'package:fujin/pages/chat/reply_notifier.dart';
import 'package:fujin/pages/chat/voice/voice_send_outcome.dart';
import 'package:fujin/pages/chat/voice/voice_start_outcome.dart';
import 'package:fujin/pages/chat/voice/voice_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart';

final NotifierProviderFamily<VoiceNotifier, VoiceState, String> voiceProvider =
    NotifierProvider.autoDispose.family<VoiceNotifier, VoiceState, String>(
      VoiceNotifier.new,
    );

final class VoiceNotifier extends Notifier<VoiceState> {
  VoiceNotifier(this._conversationId);

  final String _conversationId;

  static const sample = Duration(milliseconds: 100);
  static const folderName = 'chat_voice';
  static const _extension = '.m4a';
  static const double _quietest = -50;

  late VoiceRecorder _recorder;
  Timer? _timer;
  String? _path;
  bool _recording = false;

  @override
  VoiceState build() {
    _recorder = ref.read(voiceRecorderProvider);
    ref
      ..onDispose(_release)
      ..listen(appForegroundProvider, (_, next) {
        if (next.value case false) unawaited(keep());
      });
    return const VoiceIdle();
  }

  Future<VoiceStartOutcome> start() async {
    if (state is! VoiceIdle) return VoiceStartOutcome.failed;
    state = const VoiceStarting();
    final path = _newPath();
    try {
      if (!await _recorder.allowed()) {
        if (ref.mounted) state = const VoiceIdle();
        return VoiceStartOutcome.refused;
      }
      await _recorder.start(path);
    } on PlatformException {
      _delete(path);
      if (ref.mounted) state = const VoiceIdle();
      return VoiceStartOutcome.failed;
    }
    if (!ref.mounted) {
      unawaited(_recorder.cancel().whenComplete(() => _delete(path)));
      return VoiceStartOutcome.failed;
    }
    _path = path;
    _recording = true;
    state = const VoiceRecording(elapsed: Duration.zero, levels: []);
    _timer = Timer.periodic(sample, (timer) => unawaited(_sample(timer)));
    return VoiceStartOutcome.recording;
  }

  Future<VoiceSendOutcome> send() async {
    final replyToId = ref.read(replyProvider(_conversationId))?.id;
    switch (state) {
      case VoiceRecording(:final elapsed) when VoiceLimits.tooShort(elapsed):
        await discard();
        return VoiceSendOutcome.tooShort;
      case VoiceRecording(:final elapsed, :final levels):
        final path = _path;
        if (path == null) return VoiceSendOutcome.notSent;
        state = VoiceSending(shown: elapsed, levels: levels);
        await _stopRecorder();
        final duration = await _readBack(path, recorded: elapsed);
        return _hand(path, duration, levels, replyToId: replyToId);
      case VoiceKept(:final path, :final duration, :final levels):
        state = VoiceSending(shown: duration, levels: levels);
        return _hand(path, duration, levels, replyToId: replyToId);
      case VoiceIdle() || VoiceStarting() || VoiceSending():
        return VoiceSendOutcome.notSent;
    }
  }

  Future<void> keep() async {
    if (state case VoiceRecording(:final elapsed, :final levels)) {
      await switch (VoiceLimits.tooShort(elapsed)) {
        true => discard(),
        false => _keep(elapsed, levels, atLimit: false),
      };
    }
  }

  Future<void> discard() async {
    final recording = _recording;
    final path = _path;
    _timer?.cancel();
    _timer = null;
    _recording = false;
    _path = null;
    state = const VoiceIdle();
    if (recording) await _recorder.cancel();
    if (path case final path?) _delete(path);
  }

  Future<void> _sample(Timer timer) async {
    final elapsed = sample * timer.tick;
    if (state case VoiceRecording(
      :final levels,
    ) when VoiceLimits.reached(elapsed)) {
      await _keep(VoiceLimits.longest, levels, atLimit: true);
      return;
    }
    final level = await _level();
    if (!ref.mounted || !timer.isActive) return;
    if (state case VoiceRecording(:final levels)) {
      state = VoiceRecording(elapsed: elapsed, levels: [...levels, level]);
    }
  }

  Future<double> _level() async {
    try {
      return _shown(await _recorder.level());
    } on PlatformException {
      return 0;
    }
  }

  static double _shown(double decibels) =>
      (1 - math.min(decibels, 0) / _quietest).clamp(0, 1);

  Future<void> _keep(
    Duration elapsed,
    List<double> levels, {
    required bool atLimit,
  }) async {
    final path = _path;
    if (path == null) return;
    await _stopRecorder();
    final duration = await _readBack(path, recorded: elapsed);
    if (!ref.mounted || _path != path) return;
    state = VoiceKept(
      path: path,
      duration: duration,
      levels: levels,
      atLimit: atLimit,
    );
  }

  Future<VoiceSendOutcome> _hand(
    String path,
    Duration duration,
    List<double> levels, {
    required String? replyToId,
  }) async {
    _path = null;
    try {
      await ref
          .read(chatUploadServiceProvider)
          .sendVoice(
            conversationId: _conversationId,
            path: path,
            durationSeconds: VoiceLimits.seconds(duration),
            replyToId: replyToId,
          );
    } on Exception {
      if (!ref.mounted) {
        _delete(path);
        return VoiceSendOutcome.notSent;
      }
      _path = path;
      state = VoiceKept(
        path: path,
        duration: duration,
        levels: levels,
        atLimit: false,
      );
      return VoiceSendOutcome.notSent;
    }
    if (ref.mounted) {
      ref.read(replyProvider(_conversationId).notifier).cancel();
      state = const VoiceIdle();
    }
    return VoiceSendOutcome.sent;
  }

  Future<void> _stopRecorder() async {
    _timer?.cancel();
    _timer = null;
    if (!_recording) return;
    _recording = false;
    await _recorder.stop();
  }

  Future<Duration> _readBack(String path, {required Duration recorded}) async {
    final player = ref.read(fileVideoProvider)(File(path));
    try {
      await player.initialize();
      return switch (player.value.duration) {
        Duration.zero => recorded,
        final duration => duration,
      };
    } on PlatformException {
      return recorded;
    } finally {
      await player.dispose();
    }
  }

  String _newPath() {
    final folder = Directory(
      '${ref.read(appCacheDirectoryProvider).path}'
      '${Platform.pathSeparator}$folderName',
    )..createSync(recursive: true);
    final name = ref.read(clockProvider)().microsecondsSinceEpoch;
    return '${folder.path}${Platform.pathSeparator}$name$_extension';
  }

  void _release() {
    _timer?.cancel();
    final path = _path;
    final recording = _recording;
    _recording = false;
    _path = null;
    switch ((recording, path)) {
      case (true, final path?):
        unawaited(_recorder.cancel().whenComplete(() => _delete(path)));
      case (true, null):
        unawaited(_recorder.cancel());
      case (false, final path?):
        _delete(path);
      case (false, null):
        return;
    }
  }

  static void _delete(String path) {
    try {
      File(path).deleteSync();
    } on FileSystemException {
      return;
    }
  }
}
