import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/journal/widgets/split_line.dart';

class MealTitle extends StatelessWidget {
  const MealTitle({required this.name, required this.kilocalories, super.key});

  final String name;
  final double kilocalories;

  @override
  Widget build(BuildContext context) => SplitLine(
    leading: Text(
      name,
      style: FujinText.inter16Medium.copyWith(
        color: context.colors.textPrimary,
      ),
    ),
    trailing: Text(
      context.intl.kilocalories(kilocalories),
      style: FujinText.inter15Semibold.copyWith(
        color: context.colors.textPrimary,
      ),
    ),
  );
}
