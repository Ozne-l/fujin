import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

abstract final class LocaleNumbers {
  static NumberFormat decimal(BuildContext context) =>
      NumberFormat.decimalPattern(Localizations.localeOf(context).toString());

  static String separator(BuildContext context) =>
      decimal(context).symbols.DECIMAL_SEP;
}
