import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/data/entries/logged_entry.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/entry_text.dart';
import 'package:fujin/pages/journal/widgets/split_line.dart';

class EntryRow extends StatelessWidget {
  const EntryRow({
    required this.entry,
    required this.detail,
    this.pills = const [],
    this.removed = false,
    super.key,
  });

  final LoggedEntry entry;
  final String detail;
  final List<Widget> pills;
  final bool removed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (main, serving, note) = switch (removed) {
      true => (colors.textTertiary, colors.textTertiary, colors.textSecondary),
      false => (colors.textPrimary, colors.textSecondary, colors.textTertiary),
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: FujinSpace.s1,
      children: [
        SplitLine(
          leading: Text(
            entry.foodName ?? '',
            style: FujinText.inter15Medium.copyWith(color: main),
          ),
          trailing: Text(
            EntryText.energy(context.intl, entry),
            style: FujinText.inter15Semibold.copyWith(color: main),
          ),
        ),
        SplitLine(
          leading: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: FujinSpace.s1,
            children: [
              Text(
                EntryText.brandedServing(context.intl, entry),
                style: FujinText.inter13Regular.copyWith(color: serving),
              ),
              Text(
                detail,
                style: FujinText.inter12Medium.copyWith(color: note),
              ),
            ],
          ),
          trailing: switch (pills) {
            [] => null,
            [final pill] => pill,
            _ => Row(
              mainAxisSize: MainAxisSize.min,
              spacing: FujinSpace.s2,
              children: pills,
            ),
          },
        ),
      ],
    );
  }
}
