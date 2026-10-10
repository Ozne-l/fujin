import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/sending/sheets/sheet_frame.dart';
import 'package:fujin/pages/settings/widgets/alert_pictogram.dart';

Future<void> showConfirmSheet(
  BuildContext context, {
  required String icon,
  required String title,
  required String message,
  required String confirmLabel,
  required VoidCallback onConfirm,
}) => SheetFrame.show(
  context,
  builder: (context) {
    final navigator = Navigator.of(context);
    return SheetFrame(
      glyph: AlertPictogram(icon: icon),
      title: title,
      titleStyle: FujinText.hina24,
      subtitle: message,
      subtitleStyle: FujinText.inter15RegularL22,
      primaryLabel: confirmLabel,
      onPrimary: () {
        navigator.pop();
        onConfirm();
      },
      onSkip: navigator.pop,
      skipLabel: AppLocalizations.of(context).cancel,
    );
  },
);
