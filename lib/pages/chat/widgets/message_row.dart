import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/chat/widgets/reaction_chips.dart';

class MessageRow extends StatelessWidget {
  const MessageRow({
    required this.mine,
    required this.content,
    required this.footer,
    this.reactions = const [],
    this.onReaction,
    super.key,
  });

  final bool mine;
  final Widget content;
  final Widget footer;
  final List<EkkloReaction> reactions;
  final ValueChanged<EkkloReaction>? onReaction;

  static const double _share = 0.8;

  static Offset reactionLanding(Rect bubble, {required bool mine}) => Offset(
    switch (mine) {
      true => bubble.right - ReactionChips.inset - ReactionChips.height,
      false => bubble.left + ReactionChips.inset + ReactionChips.height / 2,
    },
    bubble.bottom + ReactionChips.height / 2 - FujinSize.reactionOverlap,
  );

  @override
  Widget build(BuildContext context) {
    final alignment = switch (mine) {
      true => CrossAxisAlignment.end,
      false => CrossAxisAlignment.start,
    };
    final bounded = LayoutBuilder(
      builder: (context, constraints) => ConstrainedBox(
        constraints: BoxConstraints(maxWidth: constraints.maxWidth * _share),
        child: content,
      ),
    );
    return Column(
      crossAxisAlignment: alignment,
      spacing: FujinSpace.s1,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedPadding(
              duration: switch (FujinMotion.reduced(context)) {
                true => Duration.zero,
                false => FujinMotion.spatialFast.duration,
              },
              curve: FujinMotion.spatialFast.curve,
              padding: EdgeInsets.only(
                bottom: switch (reactions) {
                  [] => 0,
                  _ => ReactionChips.height - FujinSize.reactionOverlap,
                },
              ),
              child: bounded,
            ),
            PositionedDirectional(
              bottom: 0,
              start: switch (mine) {
                true => null,
                false => 0,
              },
              end: switch (mine) {
                true => 0,
                false => null,
              },
              child: ReactionChips(reactions: reactions, onToggle: onReaction),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: FujinSize.messageFooterInset,
          ),
          child: footer,
        ),
      ],
    );
  }
}
