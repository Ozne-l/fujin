import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/chat/chat_files.dart';
import 'package:fujin/pages/chat/chat_text.dart';
import 'package:fujin/pages/chat/voice/widgets/voice_player_control.dart';
import 'package:fujin/pages/chat/widgets/chat_bubble.dart';
import 'package:fujin/pages/chat/widgets/waveform.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class VoiceBubble extends ConsumerWidget {
  const VoiceBubble({required this.url, required this.mine, super.key});

  final Uri url;
  final bool mine;

  static const double _disc = 36;
  static const double _icon = 14;
  static const double _gap = 10;
  static const EdgeInsets _padding = EdgeInsets.fromLTRB(
    FujinSpace.s2,
    FujinSpace.s2,
    14,
    FujinSpace.s2,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    return ChatBubble(
      mine: mine,
      padding: _padding,
      child: VoicePlayerControl(
        file: ref.watch(chatFileProvider(url)).value,
        disc: _disc,
        icon: _icon,
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
            spacing: _gap,
            children: [
              button,
              Waveform(
                seed: url,
                played: switch ((
                  playback.started,
                  playback.total.inMilliseconds,
                )) {
                  (false, _) || (_, 0) => 0,
                  (true, final length) =>
                    playback.position.inMilliseconds / length,
                },
                playedColour: colors.textLink,
                restColour: colors.textTertiary,
              ),
              ExcludeSemantics(
                child: Text(
                  ChatText.clock(switch (playback.started) {
                    true => playback.position,
                    false => playback.total,
                  }),
                  style: FujinText.inter12Medium.copyWith(
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
