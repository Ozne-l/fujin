import 'dart:io';

import 'package:fujin/data/voice/voice_recorder.dart';
import 'package:fujin/data/voice/voice_settings.dart';

final class FakeVoiceRecorder implements VoiceRecorder {
  FakeVoiceRecorder({this.allows = true});

  static const recordedBytes = [0, 0, 0, 24, 102, 116, 121, 112];
  static const _decibels = -20.0;

  final bool allows;
  String? recording;
  final List<String> started = [];

  @override
  Future<bool> allowed() async => allows;

  @override
  Future<VoiceSettings> start(String path) async {
    File(path).writeAsBytesSync(recordedBytes);
    started.add(path);
    recording = path;
    return VoiceSettings.requested;
  }

  @override
  Future<double> level() async => _decibels;

  @override
  Future<void> stop() async => recording = null;

  @override
  Future<void> cancel() async {
    if (recording case final path?) {
      File(path).deleteSync();
    }
    recording = null;
  }
}
