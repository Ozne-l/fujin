import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';

class ReactionChips extends StatelessWidget {
  const ReactionChips({required this.reactions, this.onToggle, super.key});

  final List<EkkloReaction> reactions;
  final ValueChanged<EkkloReaction>? onToggle;

  static const double height = 23;
  static const EdgeInsets _chipPadding = EdgeInsets.fromLTRB(7, 3, 8, 3);
  static const double _rowInset = 10;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: _rowInset),
    child: Wrap(
      spacing: FujinSpace.s1,
      runSpacing: FujinSpace.s1,
      children: [
        for (final reaction in reactions)
          _Chip(
            reaction: reaction,
            onTap: switch (onToggle) {
              null => null,
              final onToggle => () => onToggle(reaction),
            },
          ),
      ],
    ),
  );
}

class _Chip extends StatelessWidget {
  const _Chip({required this.reaction, required this.onTap});

  final EkkloReaction reaction;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (background, border, count) = switch (reaction.mine) {
      true => (colors.backgroundSuccess, colors.borderFocus, colors.textLink),
      false => (colors.backgroundCard, colors.borderCard, colors.textSecondary),
    };
    return Semantics(
      button: onTap != null,
      selected: reaction.mine,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: ReactionChips.height,
          padding: ReactionChips._chipPadding,
          decoration: ShapeDecoration(
            color: background,
            shape: StadiumBorder(
              side: BorderSide(color: border),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: FujinSpace.s1,
            children: [
              Text(
                reaction.emoji,
                style: FujinText.inter13Regular.copyWith(
                  fontFamily: FujinFont.hina,
                  color: colors.textPrimary,
                ),
              ),
              Text(
                '${reaction.count}',
                style: FujinText.inter12Semibold.copyWith(color: count),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
