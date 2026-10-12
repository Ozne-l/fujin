import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/adding/widgets/food_list_row.dart';

class FoodList extends StatelessWidget {
  const FoodList({required this.rows, super.key});

  final List<FoodListRow> rows;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.symmetric(horizontal: FujinSize.screenMargin),
    decoration: BoxDecoration(
      color: FujinColorRole.backgroundCard,
      borderRadius: BorderRadius.circular(FujinRadius.card),
      border: Border.all(color: FujinColorRole.borderCard),
    ),
    clipBehavior: Clip.antiAlias,
    child: Column(
      children: [
        for (final (index, row) in rows.indexed) ...[
          if (index > 0)
            const Divider(
              height: FujinStroke.card,
              thickness: FujinStroke.card,
            ),
          _Row(row: row),
        ],
      ],
    ),
  );
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
                    color: FujinColorRole.textPrimary,
                  ),
                ),
                Row(
                  spacing: FujinSpace.s1,
                  children: [
                    if (row.verified)
                      const Icon(
                        Icons.check_circle,
                        size: FujinSize.stepIcon,
                        color: FujinColorRole.textLink,
                      ),
                    Expanded(
                      child: Text(
                        row.detail,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: FujinText.inter13Regular.copyWith(
                          color: FujinColorRole.textSecondary,
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
                color: FujinColorRole.textPrimary,
              ),
            ),
          const Icon(
            Icons.chevron_right,
            size: FujinSize.rowChevron,
            color: FujinColorRole.textSecondary,
          ),
        ],
      ),
    ),
  );
}
