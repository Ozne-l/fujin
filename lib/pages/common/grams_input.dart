import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

abstract final class GramsInput {
  static const _decimals = 1;

  static String format(BuildContext context, double grams) =>
      _numbers(context).format(grams);

  static double? parse(BuildContext context, String text) {
    final grams = _numbers(context).tryParse(text.trim());
    return switch (grams) {
      final grams? when grams.isFinite && grams > 0 => grams.toDouble(),
      _ => null,
    };
  }

  static NumberFormat _numbers(BuildContext context) =>
      NumberFormat.decimalPattern(Localizations.localeOf(context).toString())
        ..maximumFractionDigits = _decimals
        ..turnOffGrouping();
}
