import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';

AppLocalizations deviceLocalizations() => lookupAppLocalizations(
  basicLocaleListResolution(
    PlatformDispatcher.instance.locales,
    AppLocalizations.supportedLocales,
  ),
);
