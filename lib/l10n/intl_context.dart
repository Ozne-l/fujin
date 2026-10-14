import 'package:flutter/widgets.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';

extension IntlContext on BuildContext {
  AppLocalizations get intl => AppLocalizations.of(this);
}
