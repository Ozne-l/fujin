import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:motor/motor.dart';

class ReactionChips extends HookWidget {
  const ReactionChips({required this.reactions, this.onToggle, super.key});

  final List<EkkloReaction> reactions;
  final ValueChanged<EkkloReaction>? onToggle;

  static const double height = FujinSize.reactionChipHeight;
  static const double inset = FujinSize.reactionChipsInset;
  static const EdgeInsets _chipPadding = EdgeInsets.fromLTRB(
    FujinSize.reactionChipPaddingStart,
    FujinSize.reactionChipPaddingVertical,
    FujinSpace.s2,
    FujinSize.reactionChipPaddingVertical,
  );

  @override
  Widget build(BuildContext context) {
    final appear = useRef(false);
    useEffect(() {
      appear.value = true;
      return null;
    }, const []);
    final gone = useState(Set<EkkloReaction>.identity());
    final current = {for (final reaction in reactions) reaction.emoji};
    final departed =
        useValueChanged<List<EkkloReaction>, List<(int, EkkloReaction)>>(
          reactions,
          (old, previous) => [
            for (final entry in previous ?? const <(int, EkkloReaction)>[])
              if (!current.contains(entry.$2.emoji) &&
                  !gone.value.contains(entry.$2))
                entry,
            for (final (index, reaction) in old.indexed)
              if (!current.contains(reaction.emoji)) (index, reaction),
          ],
        ) ??
        const [];
    final next = [for (final reaction in reactions) (reaction, false)];
    for (final (index, reaction) in departed) {
      if (gone.value.contains(reaction)) continue;
      next.insert(index.clamp(0, next.length), (reaction, true));
    }
    final onToggle = this.onToggle;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: inset),
      child: Wrap(
        spacing: FujinSpace.s1,
        runSpacing: FujinSpace.s1,
        children: [
          for (final (reaction, leaving) in next)
            _Chip(
              key: ValueKey(reaction.emoji),
              reaction: reaction,
              appear: appear.value,
              leaving: leaving,
              onGone: () => gone.value = Set.identity()
                ..addAll(gone.value)
                ..add(reaction),
              onTap: switch ((onToggle, leaving)) {
                (final onToggle?, false) => () => onToggle(reaction),
                _ => null,
              },
            ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.reaction,
    required this.appear,
    required this.leaving,
    required this.onGone,
    required this.onTap,
    super.key,
  });

  final EkkloReaction reaction;
  final bool appear;
  final bool leaving;
  final VoidCallback onGone;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final reduced = FujinMotion.reduced(context);
    const dissolve = FujinMotion.effectsFast;
    final (background, border, count) = switch (reaction.mine) {
      true => (colors.backgroundSuccess, colors.borderFocus, colors.textLink),
      false => (colors.backgroundCard, colors.borderCard, colors.textSecondary),
    };
    return SingleMotionBuilder(
      motion: FujinMotion.dissolveOf(context, FujinMotion.emphasis),
      from: switch (appear) {
        true => 0,
        false => null,
      },
      value: switch (leaving) {
        true => 0,
        false => 1,
      },
      onAnimationStatusChanged: (status) {
        if (leaving && !status.isAnimating) onGone();
      },
      builder: (context, shown, chip) => Align(
        widthFactor: shown.clamp(0.0, 1.0),
        child: Opacity(
          opacity: shown.clamp(0.0, 1.0),
          child: Transform.scale(
            scale: switch (reduced) {
              true => 1,
              false => shown,
            },
            child: chip,
          ),
        ),
      ),
      child: Semantics(
        button: onTap != null,
        selected: reaction.mine,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            height: ReactionChips.height,
            padding: ReactionChips._chipPadding,
            decoration: ShapeDecoration(
              color: background,
              shape: StadiumBorder(side: BorderSide(color: border)),
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
                AnimatedSwitcher(
                  duration: dissolve.duration,
                  switchInCurve: dissolve.curve,
                  switchOutCurve: dissolve.curve,
                  child: Text(
                    '${reaction.count}',
                    key: ValueKey(reaction.count),
                    style: FujinText.inter12Semibold.copyWith(color: count),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
