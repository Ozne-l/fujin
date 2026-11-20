import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/chat/chat_files.dart';
import 'package:fujin/pages/chat_media/chat_media_icon.dart';
import 'package:fujin/pages/chat_media/widgets/media_glyph.dart';
import 'package:fujin/pages/common/fade_through.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:video_player/video_player.dart';

typedef VoicePlayback = ({
  Duration position,
  Duration total,
  bool started,
  VoidCallback hold,
  Future<void> Function(Duration position) seek,
});

class VoicePlayerControl extends HookConsumerWidget {
  const VoicePlayerControl({
    required this.path,
    required this.disc,
    required this.icon,
    required this.fill,
    required this.builder,
    super.key,
  });

  final String? path;
  final double disc;
  final double icon;
  final Color fill;
  final Widget Function(
    BuildContext context,
    VoicePlayback playback,
    Widget button,
  )
  builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final path = this.path;
    final load = switch (path) {
      final path? => ref.watch(voicePlayerProvider(path)),
      null => const AsyncLoading<VideoPlayerController>(),
    };
    final failed = switch (load) {
      AsyncError(isLoading: false) => true,
      _ => false,
    };
    final player = load.value;
    final value =
        useListenable(player)?.value ?? const VideoPlayerValue.uninitialized();
    final ended = value.position >= value.duration;
    final playing = value.isPlaying && !ended;
    final started =
        (value.isPlaying || value.position > Duration.zero) && !ended;

    final resume = useRef(false);
    void hold() {
      if (player == null || !value.isInitialized) return;
      resume.value = playing;
      if (playing) unawaited(player.pause());
    }

    Future<void> seek(Duration position) async {
      if (player == null || !value.isInitialized) return;
      final target = switch (position) {
        final position when position > value.duration => value.duration,
        final position when position < Duration.zero => Duration.zero,
        final position => position,
      };
      await player.seekTo(target);
      if (resume.value && target < value.duration) await player.play();
      resume.value = false;
    }

    Future<void> toggle() async {
      if (player == null || !value.isInitialized) return;
      switch (playing) {
        case true:
          await player.pause();
        case false:
          if (ended) await player.seekTo(Duration.zero);
          await player.play();
      }
    }

    void touch() {
      switch ((failed, path)) {
        case (true, final path?):
          ref.invalidate(voicePlayerProvider(path));
        case _:
          unawaited(toggle());
      }
    }

    final colors = context.colors;
    final (glyph, label, tint) = switch ((failed, playing)) {
      (true, _) => (
        ChatMediaIcon.alert,
        context.intl.chatVoiceNotLoaded,
        colors.textAlert,
      ),
      (false, true) => (
        ChatMediaIcon.pause,
        context.intl.chatPause,
        colors.textLink,
      ),
      (false, false) => (
        ChatMediaIcon.play,
        context.intl.chatPlay,
        colors.textLink,
      ),
    };
    final button = Semantics(
      button: true,
      enabled: value.isInitialized || failed,
      label: label,
      excludeSemantics: true,
      onTap: touch,
      child: GestureDetector(
        onTap: touch,
        child: Container(
          width: disc,
          height: disc,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: fill, shape: BoxShape.circle),
          child: FadeThrough(
            scale: FujinMotion.swapScale,
            child: MediaGlyph(
              glyph,
              key: ValueKey(glyph),
              size: icon,
              color: tint,
            ),
          ),
        ),
      ),
    );
    return builder(
      context,
      (
        position: value.position,
        total: value.duration,
        started: started,
        hold: hold,
        seek: seek,
      ),
      button,
    );
  }
}
