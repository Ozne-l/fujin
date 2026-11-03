import 'package:fujin/l10n/generated/app_localizations.dart';

abstract final class FoodText {
  static String name(AppLocalizations intl, String? name) => switch (name) {
    final name? when name.trim().isNotEmpty => name,
    _ => intl.unnamedFood,
  };
}
