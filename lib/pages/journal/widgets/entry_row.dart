import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/data/entries/logged_entry.dart';
import 'package:fujin/domain/comparison/mfp_status.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/entry_text.dart';
import 'package:fujin/pages/journal/widgets/mfp_pill.dart';
import 'package:fujin/pages/journal/widgets/split_line.dart';

class EntryRow extends StatelessWidget {
  const EntryRow({
    required this.entry,
    required this.detail,
    this.pill,
    this.mfp,
    super.key,
  });

  final LoggedEntry entry;
  final String detail;
  final Widget? pill;
  final MfpStatus? mfp;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: FujinSpace.s1,
      children: [
        SplitLine(
          leading: Text(
            entry.foodName ?? '',
            style: FujinText.inter15Medium.copyWith(
              color: context.colors.textPrimary,
            ),
          ),
          trailing: Text(
            EntryText.energy(context.intl, entry),
            style: FujinText.inter15Semibold.copyWith(
              color: context.colors.textPrimary,
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
                  color: context.colors.textSecondary,
                ),
              ),
              Text(
                detail,
                style: FujinText.inter12Medium.copyWith(
                  color: context.colors.textTertiary,
                ),
              ),
            ],
          ),
          trailing: switch (mfp) {
            null => pill,
            final mfp => Row(
              mainAxisSize: MainAxisSize.min,
              spacing: FujinSpace.s2,
              children: [
                MfpPill(failed: mfp is MfpFailed),
                ?pill,
              ],
            ),
          },
        ),
      ],
    );
  }
}
