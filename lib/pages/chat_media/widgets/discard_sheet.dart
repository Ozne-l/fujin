import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_haptics.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/alert_pictogram.dart';
import 'package:fujin/pages/common/glass_finish.dart';
import 'package:fujin/pages/common/sheet_frame.dart';
import 'package:fujin/pages/common/trash_icon.dart';

Future<void> showDiscardSheet(
  BuildContext context, {
  required VoidCallback onDiscard,
}) {
  FujinHaptics.press();
  return SheetFrame.show(
    context,
    builder: (context) => _DiscardSheet(onDiscard: onDiscard),
  );
}

class _DiscardSheet extends StatelessWidget {
  const _DiscardSheet({required this.onDiscard});

  final VoidCallback onDiscard;

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    final intl = context.intl;
    return SheetFrame(
      glyph: const AlertPictogram(icon: TrashIcon.asset),
      title: intl.chatTrayDiscardTitle,
      titleStyle: FujinText.hina24,
      subtitle: intl.chatTrayDiscardDetail,
      subtitleStyle: FujinText.inter15RegularL22,
      primaryLabel: intl.chatTrayDiscardConfirm,
      primaryFinish: GlassFinish.alert,
      onPrimary: () {
        navigator.pop();
        onDiscard();
      },
      onSkip: navigator.pop,
      skipLabel: intl.deleteKeep,
    );
  }
}
