import 'package:flutter/widgets.dart';
import 'package:fujin/pages/common/locale_numbers.dart';
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
      LocaleNumbers.decimal(context)
        ..maximumFractionDigits = _decimals
        ..turnOffGrouping();
}
