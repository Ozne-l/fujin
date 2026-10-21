import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/adding/widgets/food_list_row.dart';

class FoodList extends StatelessWidget {
  const FoodList({required this.rows, super.key});

  final List<FoodListRow> rows;

  static BoxDecoration _card(FujinColors colors) => BoxDecoration(
    color: colors.backgroundCard,
    borderRadius: BorderRadius.circular(FujinRadius.card),
    border: Border.all(color: colors.borderCard),
  );

  @override
  Widget build(BuildContext context) {
    final card = _card(context.colors);
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: FujinSize.screenMargin),
      sliver: DecoratedSliver(
        decoration: card,
        sliver: SliverPadding(
          padding: card.padding,
          sliver: SliverList.separated(
            itemCount: rows.length,
            itemBuilder: (context, index) => _Row(row: rows[index]),
            separatorBuilder: (context, index) => const Divider(
              height: FujinStroke.card,
              thickness: FujinStroke.card,
            ),
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.row});

  final FoodListRow row;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: row.onTap,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(
        FujinSpace.s4,
        FujinSpace.s3,
        FujinSpace.s3,
        FujinSpace.s3,
      ),
      child: Row(
        spacing: FujinSpace.s3,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: FujinSpace.s1,
              children: [
                Text(
                  row.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: FujinText.inter15Medium.copyWith(
                    color: context.colors.textPrimary,
                  ),
                ),
                Row(
                  spacing: FujinSpace.s1,
                  children: [
                    if (row.verified)
                      Icon(
                        Icons.check_circle,
                        size: FujinSize.stepIcon,
                        color: context.colors.textLink,
                      ),
                    Expanded(
                      child: Text(
                        row.detail,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: FujinText.inter13Regular.copyWith(
                          color: context.colors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (row.energy case final energy?)
            Text(
              energy,
              style: FujinText.inter15Semibold.copyWith(
                color: context.colors.textPrimary,
              ),
            ),
          Icon(
            Icons.chevron_right,
            size: FujinSize.rowChevron,
            color: context.colors.textSecondary,
          ),
        ],
      ),
    ),
  );
}
