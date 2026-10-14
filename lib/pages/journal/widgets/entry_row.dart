import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/entry_text.dart';
import 'package:fujin/pages/journal/widgets/split_line.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

class EntryRow extends StatelessWidget {
  const EntryRow({
    required this.entry,
    required this.detail,
    this.pill,
    super.key,
  });

  final MfpFoodEntry entry;
  final String detail;
  final Widget? pill;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: FujinSpace.s1,
      children: [
        SplitLine(
          leading: Text(
            entry.food.description,
            style: FujinText.inter15Medium.copyWith(
              color: FujinColorRole.textPrimary,
            ),
          ),
          trailing: Text(
            EntryText.energy(context.intl, entry),
            style: FujinText.inter15Semibold.copyWith(
              color: FujinColorRole.textPrimary,
            ),
          ),
        ),
        SplitLine(
          leading: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: FujinSpace.s1,
            children: [
              Text(
                EntryText.brandedServing(context.intl, entry),
                style: FujinText.inter13Regular.copyWith(
                  color: FujinColorRole.textSecondary,
                ),
              ),
              Text(
                detail,
                style: FujinText.inter12Medium.copyWith(
                  color: FujinColorRole.textTertiary,
                ),
              ),
            ],
          ),
          trailing: pill,
        ),
      ],
    );
  }
}
