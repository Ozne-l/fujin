import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter/material.dart';
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
  static const double _overlap = 6;
  static const double _footerInset = 6;

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
        switch (reactions) {
          [] => bounded,
          _ => Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  bottom: ReactionChips.height - _overlap,
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
                child: ReactionChips(
                  reactions: reactions,
                  onToggle: onReaction,
                ),
              ),
            ],
          ),
        },
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: _footerInset),
          child: footer,
        ),
      ],
    );
  }
}
