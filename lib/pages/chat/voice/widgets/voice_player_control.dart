import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/file_video.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/chat_media/chat_media_icon.dart';
import 'package:fujin/pages/chat_media/widgets/media_glyph.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:video_player/video_player.dart';

typedef VoicePlayback = ({Duration position, Duration total, bool started});

class VoicePlayerControl extends HookConsumerWidget {
  const VoicePlayerControl({
    required this.file,
    required this.disc,
    required this.icon,
    required this.fill,
    required this.builder,
    super.key,
  });

  final File? file;
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
    final makePlayer = ref.read(fileVideoProvider);
    final file = this.file;
    final player = useMemoized(
      () => switch (file) {
        final file? => makePlayer(file),
        null => null,
      },
      [file?.path],
    );
    useEffect(() {
      if (player == null) return null;
      unawaited(player.initialize().then((_) {}, onError: (Object _) {}));
      return () => unawaited(player.dispose());
    }, [player]);
    final value =
        useListenable(player)?.value ?? const VideoPlayerValue.uninitialized();
    final ended = value.position >= value.duration;
    final playing = value.isPlaying && !ended;
    final started =
        (value.isPlaying || value.position > Duration.zero) && !ended;

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

    final button = Semantics(
      button: true,
      enabled: value.isInitialized,
      label: switch (playing) {
        true => context.intl.chatPause,
        false => context.intl.chatPlay,
      },
      excludeSemantics: true,
      onTap: () => unawaited(toggle()),
      child: GestureDetector(
        onTap: () => unawaited(toggle()),
        child: Container(
          width: disc,
          height: disc,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: fill, shape: BoxShape.circle),
          child: MediaGlyph(
            switch (playing) {
              true => ChatMediaIcon.pause,
              false => ChatMediaIcon.play,
            },
            size: icon,
            color: context.colors.textLink,
          ),
        ),
      ),
    );
    return builder(
      context,
      (position: value.position, total: value.duration, started: started),
      button,
    );
  }
}
