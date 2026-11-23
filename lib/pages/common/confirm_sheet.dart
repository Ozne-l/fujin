import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/glass_finish.dart';
import 'package:fujin/pages/common/sheet_frame.dart';

Future<void> showConfirmSheet(
  BuildContext context, {
  required Widget glyph,
  required String title,
  required String message,
  required String confirmLabel,
  required VoidCallback onConfirm,
  GlassFinish? confirmFinish,
  String? skipLabel,
}) => SheetFrame.show(
  context,
  builder: (context) {
    final navigator = Navigator.of(context);
    return SheetFrame(
      glyph: glyph,
      title: title,
      titleStyle: FujinText.hina24,
      subtitle: message,
      subtitleStyle: FujinText.inter15RegularL22,
      primaryLabel: confirmLabel,
      primaryFinish: confirmFinish,
      onPrimary: () {
        navigator.pop();
        onConfirm();
      },
      onSkip: navigator.pop,
      skipLabel: skipLabel ?? context.intl.cancel,
    );
  },
);
