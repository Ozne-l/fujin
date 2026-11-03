import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/journal/widgets/split_line.dart';

class MealTitle extends StatelessWidget {
  const MealTitle({
    required this.name,
    required this.kilocalories,
    this.note,
    this.empty = false,
    super.key,
  });

  final String name;
  final double kilocalories;
  final String? note;
  final bool empty;

  static Widget nameText(BuildContext context, String name) => Text(
    name,
    style: FujinText.inter16Medium.copyWith(
      color: context.colors.textPrimary,
    ),
  );

  static Widget kilocaloriesText(BuildContext context, double kilocalories) =>
      Text(
        context.intl.kilocalories(kilocalories),
        style: FujinText.inter15Semibold.copyWith(
          color: context.colors.textPrimary,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final title = SplitLine(
      leading: nameText(context, name),
      trailing: kilocaloriesText(context, kilocalories),
    );
    final secondary = FujinText.inter13Regular.copyWith(
      color: context.colors.textSecondary,
    );
    return switch ((note, empty)) {
      (null, false) => title,
      _ => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: FujinSpace.s3,
        children: [
          title,
          if (note case final note?) Text(note, style: secondary),
          if (empty) Text(context.intl.mealEmpty, style: secondary),
        ],
      ),
    };
  }
}
