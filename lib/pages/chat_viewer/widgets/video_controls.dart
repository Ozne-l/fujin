import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_theme.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/chat/chat_text.dart';
import 'package:fujin/pages/chat_media/chat_media_icon.dart';
import 'package:fujin/pages/chat_media/widgets/media_glyph.dart';
import 'package:video_player/video_player.dart';

class VideoControls extends StatelessWidget {
  const VideoControls({
    required this.value,
    required this.muted,
    required this.onPlay,
    required this.onPause,
    required this.onSeek,
    required this.onMute,
    super.key,
  });

  static const double _timeGap = 6;

  final VideoPlayerValue value;
  final bool muted;
  final VoidCallback onPlay;
  final VoidCallback onPause;
  final ValueChanged<Duration> onSeek;
  final ValueChanged<bool> onMute;

  @override
  Widget build(BuildContext context) {
    final duration = value.duration;
    final position = switch (value.position) {
      final position when position > duration => duration,
      final position => position,
    };
    final timeStyle = FujinText.inter12Medium.copyWith(
      color: context.colors.cameraText,
    );
    return Row(
      spacing: FujinSpace.s3,
      children: [
        switch (value.isPlaying) {
          true => _RoundControl(
            icon: ChatMediaIcon.pause,
            label: context.intl.chatPause,
            onPressed: onPause,
          ),
          false => _RoundControl(
            icon: ChatMediaIcon.play,
            label: context.intl.chatPlay,
            onPressed: onPlay,
          ),
        },
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: _timeGap,
            children: [
              SliderTheme(
                data: SliderThemeData(
                  trackHeight: FujinSize.macroBar,
                  activeTrackColor: context.colors.cameraText,
                  inactiveTrackColor: context.colors.cameraButton,
                  thumbColor: context.colors.cameraText,
                  overlayShape: SliderComponentShape.noOverlay,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: FujinSize.pillSmallIcon / 2,
                    elevation: 0,
                    pressedElevation: 0,
                  ),
                ),
                child: SizedBox(
                  height: FujinSize.pillSmallIcon,
                  child: Slider(
                    padding: EdgeInsets.zero,
                    max: duration.inMilliseconds.toDouble(),
                    value: position.inMilliseconds.toDouble(),
                    semanticFormatterCallback: (milliseconds) => ChatText.clock(
                      Duration(milliseconds: milliseconds.round()),
                    ),
                    onChanged: switch (duration) {
                      Duration.zero => null,
                      _ => (milliseconds) => onSeek(
                        Duration(milliseconds: milliseconds.round()),
                      ),
                    },
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(ChatText.clock(position), style: timeStyle),
                  Text(ChatText.clock(duration), style: timeStyle),
                ],
              ),
            ],
          ),
        ),
        switch (muted) {
          true => _RoundControl(
            icon: ChatMediaIcon.muted,
            label: context.intl.chatViewerUnmute,
            onPressed: () => onMute(false),
          ),
          false => _RoundControl(
            icon: ChatMediaIcon.sound,
            label: context.intl.chatViewerMute,
            onPressed: () => onMute(true),
          ),
        },
      ],
    );
  }
}

class _RoundControl extends StatelessWidget {
  const _RoundControl({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final String icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => IconButton(
    onPressed: onPressed,
    tooltip: label,
    icon: MediaGlyph(
      icon,
      size: FujinSize.hintIcon,
      color: context.colors.cameraText,
    ),
    style: IconButton.styleFrom(
      fixedSize: const Size.square(FujinSize.searchField),
      minimumSize: const Size.square(FujinSize.searchField),
      backgroundColor: context.colors.cameraButton,
      foregroundColor: context.colors.cameraText,
    ).copyWith(overlayColor: FujinTheme.pressedOverlay(context.colors)),
  );
}
