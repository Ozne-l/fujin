import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_theme.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/chat/voice/voice_limits.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/chat/chat_text.dart';
import 'package:fujin/pages/chat/voice/voice_state.dart';
import 'package:fujin/pages/chat/voice/widgets/level_waveform.dart';
import 'package:fujin/pages/chat/voice/widgets/voice_hint.dart';
import 'package:fujin/pages/chat/voice/widgets/voice_player_control.dart';
import 'package:fujin/pages/chat/voice/widgets/voice_scrubber.dart';
import 'package:fujin/pages/chat_media/chat_media_icon.dart';
import 'package:fujin/pages/chat_media/widgets/media_glyph.dart';
import 'package:fujin/pages/common/glass_fill.dart';
import 'package:fujin/pages/common/glass_finish.dart';
import 'package:fujin/pages/common/trash_icon.dart';
import 'package:motor/motor.dart';

class VoiceBar extends StatelessWidget {
  const VoiceBar({
    required this.state,
    required this.onDelete,
    required this.onSend,
    super.key,
  });

  final VoiceState state;
  final VoidCallback onDelete;
  final VoidCallback onSend;

  static const double _discInset =
      (FujinSize.field - FujinSize.voiceBarDisc) / 2;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dot = SequenceMotionBuilder<int, double>(
      sequence: FujinMotion.recordingPulse,
      converter: MotionConverter.single,
      builder: (context, opacity, _, child) =>
          Opacity(opacity: opacity, child: child),
      child: Container(
        width: FujinSize.recordingDot,
        height: FujinSize.recordingDot,
        decoration: BoxDecoration(
          color: colors.textAlert,
          shape: BoxShape.circle,
        ),
      ),
    );
    Widget clock(Duration shown, Color colour) => Text(
      ChatText.clock(shown),
      style: FujinText.inter15Medium.copyWith(color: colour),
    );
    Widget waveform(
      List<double> levels, {
      required bool whole,
      required Color restColour,
      double played = 0,
      Color? playedColour,
    }) => Expanded(
      child: LevelWaveform(
        levels: levels,
        whole: whole,
        played: played,
        playedColour: playedColour ?? restColour,
        restColour: restColour,
      ),
    );

    final (inset, field, hint, active) = switch (state) {
      VoiceIdle() || VoiceStarting() => (
        FujinSize.recordingInset,
        [
          dot,
          clock(Duration.zero, colors.textPrimary),
          waveform(const [], whole: false, restColour: colors.textPrimary),
        ],
        null,
        false,
      ),
      VoiceRecording(:final elapsed, :final levels) => (
        FujinSize.recordingInset,
        [
          dot,
          clock(elapsed, switch (VoiceLimits.nearEnd(elapsed)) {
            true => colors.textAlert,
            false => colors.textPrimary,
          }),
          waveform(levels, whole: false, restColour: colors.textPrimary),
        ],
        switch (VoiceLimits.nearEnd(elapsed)) {
          true => context.intl.chatVoiceTenSecondsLeft,
          false => null,
        },
        true,
      ),
      VoiceKept(:final path, :final duration, :final levels, :final atLimit) =>
        (
          _discInset,
          [
            Expanded(
              child: VoicePlayerControl(
                path: path,
                disc: FujinSize.voiceBarDisc,
                icon: FujinSize.voiceBarDiscIcon,
                fill: colors.backgroundCard,
                builder: (context, playback, button) => Row(
                  spacing: FujinSize.voiceGap,
                  children: [
                    button,
                    clock(switch (playback.started) {
                      true => playback.position,
                      false => duration,
                    }, colors.textPrimary),
                    Expanded(
                      child: VoiceScrubber(
                        playback: playback,
                        thumbColour: colors.textLink,
                        builder: (context, played) => LevelWaveform(
                          levels: levels,
                          whole: true,
                          played: played,
                          playedColour: colors.textLink,
                          restColour: colors.textTertiary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          switch (atLimit) {
            true => context.intl.chatVoiceLimitReached,
            false => null,
          },
          true,
        ),
      VoiceSending(:final shown, :final levels) => (
        FujinSize.recordingInset,
        [
          dot,
          clock(shown, colors.textPrimary),
          waveform(levels, whole: true, restColour: colors.textTertiary),
        ],
        null,
        false,
      ),
    };

    final roundSize = IconButton.styleFrom(
      fixedSize: const Size.square(FujinSize.touchTarget),
    );
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Row(
          spacing: FujinSpace.s2,
          children: [
            IconButton(
              onPressed: switch (active) {
                true => onDelete,
                false => null,
              },
              tooltip: context.intl.chatVoiceDelete,
              icon: MediaGlyph(
                TrashIcon.asset,
                size: FujinSize.composerIcon,
                color: colors.textPrimary,
              ),
              style: GlassFill.style(colors, GlassFinish.clear, floating: true)
                  .merge(roundSize)
                  .copyWith(overlayColor: FujinTheme.pressedOverlay(colors)),
            ),
            Expanded(
              child: GlassFill(
                finish: GlassFinish.clear,
                floating: true,
                child: SizedBox(
                  height: FujinSize.field,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: inset,
                      right: FujinSpace.s4,
                    ),
                    child: Row(spacing: FujinSize.voiceGap, children: field),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: switch (active) {
                true => onSend,
                false => null,
              },
              tooltip: context.intl.chatSend,
              icon: MediaGlyph(
                ChatMediaIcon.send,
                size: FujinSize.composerIcon,
                color: switch (active) {
                  true => GlassFinish.ink.foreground(colors),
                  false => colors.buttonDisabledText,
                },
              ),
              style: GlassFill.style(colors, GlassFinish.ink, floating: true)
                  .merge(roundSize)
                  .copyWith(overlayColor: FujinTheme.pressedOverlay(colors)),
            ),
          ],
        ),
        if (hint case final hint?)
          Positioned(
            left: 0,
            right: 0,
            bottom: FujinSize.field + FujinSpace.s3,
            child: Center(child: VoiceHint(hint)),
          ),
      ],
    );
  }
}
