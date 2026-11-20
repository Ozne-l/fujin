import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/chat/chat_files.dart';
import 'package:fujin/pages/chat/chat_text.dart';
import 'package:fujin/pages/chat/voice/widgets/voice_player_control.dart';
import 'package:fujin/pages/chat/voice/widgets/voice_scrubber.dart';
import 'package:fujin/pages/chat/widgets/chat_bubble.dart';
import 'package:fujin/pages/chat/widgets/waveform.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class VoiceBubble extends ConsumerWidget {
  const VoiceBubble({required this.url, required this.mine, super.key});

  final Uri url;
  final bool mine;

  static const List<FontFeature> _figures = [FontFeature.tabularFigures()];
  static const EdgeInsets _padding = EdgeInsets.fromLTRB(
    FujinSpace.s2,
    FujinSpace.s2,
    FujinSize.bubblePaddingHorizontal,
    FujinSpace.s2,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    return ChatBubble(
      mine: mine,
      padding: _padding,
      child: VoicePlayerControl(
        path: ref.watch(chatFileProvider(url)).value?.path,
        disc: FujinSize.voiceBubbleDisc,
        icon: FujinSize.voiceBubbleDiscIcon,
        fill: switch (mine) {
          true => colors.backgroundCard,
          false => colors.backgroundSuccess,
        },
        builder: (context, playback, button) => Semantics(
          label: context.intl.chatVoiceSemantics(
            ChatText.clock(playback.position),
            ChatText.clock(playback.total),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: FujinSize.voiceGap,
            children: [
              button,
              VoiceScrubber(
                playback: playback,
                thumbColour: colors.textLink,
                builder: (context, played) => Waveform(
                  seed: url,
                  played: played,
                  playedColour: colors.textLink,
                  restColour: colors.textTertiary,
                ),
              ),
              ExcludeSemantics(
                child: Text(
                  ChatText.clock(switch (playback.started) {
                    true => playback.position,
                    false => playback.total,
                  }),
                  style: FujinText.inter12Medium.copyWith(
                    fontFeatures: _figures,
                    color: switch (playback.started) {
                      true => colors.textLink,
                      false => colors.textSecondary,
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
