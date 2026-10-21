import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/data/memory/remembered_unit.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/pill_tone.dart';
import 'package:fujin/pages/common/status_pill.dart';
import 'package:fujin/pages/memory/memory_text.dart';
import 'package:fujin/pages/sending/send_text.dart';

class RememberedFoodList extends StatelessWidget {
  const RememberedFoodList({
    required this.foods,
    required this.unitsOf,
    required this.onOpen,
    super.key,
  });

  final List<RememberedFood> foods;
  final List<RememberedUnit> Function(RememberedFood food) unitsOf;
  final ValueChanged<RememberedFood> onOpen;

  @override
  Widget build(BuildContext context) => Material(
    color: context.colors.backgroundCard,
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(FujinRadius.card),
      side: BorderSide(color: context.colors.borderCard),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: FujinSpace.s1),
      child: Column(
        children: [
          for (final (index, food) in foods.indexed) ...[
            if (index > 0)
              Divider(
                height: FujinStroke.card,
                thickness: FujinStroke.card,
                indent: FujinSpace.s5,
                endIndent: FujinSpace.s5,
                color: context.colors.borderHairline,
              ),
            _FoodRow(
              key: ValueKey(food),
              food: food,
              units: unitsOf(food),
              onTap: () => onOpen(food),
            ),
          ],
        ],
      ),
    ),
  );
}

class _FoodRow extends StatelessWidget {
  const _FoodRow({
    required this.food,
    required this.units,
    required this.onTap,
    super.key,
  });

  final RememberedFood food;
  final List<RememberedUnit> units;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: FujinSize.touchTarget),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(
            FujinSpace.s5,
            FujinSpace.s2,
            FujinSpace.s3,
            FujinSpace.s2,
          ),
          child: Row(
            spacing: FujinSpace.s2,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: FujinSize.textGap,
                  children: [
                    Text(
                      food.mfpDescription,
                      style: FujinText.inter15Medium.copyWith(
                        color: context.colors.textPrimary,
                      ),
                    ),
                    Text(
                      MemoryText.target(context.intl, food),
                      style: FujinText.inter13Regular.copyWith(
                        color: context.colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (units.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  spacing: FujinSpace.s1,
                  children: [
                    for (final unit in units)
                      StatusPill(
                        key: ValueKey(unit),
                        label: context.intl.unitWeight(
                          unit.mfpUnit,
                          SendText.grams(context.intl, unit.grams),
                        ),
                        tone: PillTone.attention,
                        icon: Icons.check,
                      ),
                  ],
                ),
              Icon(
                Icons.chevron_right,
                size: FujinSize.rowChevron,
                color: context.colors.textTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
