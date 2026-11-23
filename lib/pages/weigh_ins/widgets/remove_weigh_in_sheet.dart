import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_haptics.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/data/weigh_ins/weigh_in.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/alert_pictogram.dart';
import 'package:fujin/pages/common/glass_finish.dart';
import 'package:fujin/pages/common/sheet_frame.dart';
import 'package:fujin/pages/common/trash_icon.dart';
import 'package:fujin/pages/weigh_ins/weigh_in_text.dart';

Future<void> showRemoveWeighInSheet(
  BuildContext context, {
  required WeighIn weighIn,
  required VoidCallback onConfirm,
}) {
  FujinHaptics.press();
  return SheetFrame.show(
    context,
    builder: (context) {
      final navigator = Navigator.of(context);
      final intl = context.intl;
      return SheetFrame(
        glyph: const AlertPictogram(icon: TrashIcon.asset),
        title: intl.weighInDeleteTitle(
          WeighInText.kilograms(intl, weighIn.kilograms),
        ),
        titleStyle: FujinText.hina24,
        subtitle: intl.weighInDeleteDetail(weighIn.date),
        subtitleStyle: FujinText.inter15RegularL22,
        primaryLabel: intl.weighInDeleteFromMfp,
        primaryFinish: GlassFinish.alert,
        onPrimary: () {
          navigator.pop();
          onConfirm();
        },
        onSkip: navigator.pop,
        skipLabel: intl.deleteKeep,
      );
    },
  );
}
