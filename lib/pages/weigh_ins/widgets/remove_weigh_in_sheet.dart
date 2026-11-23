import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_haptics.dart';
import 'package:fujin/data/weigh_ins/weigh_in.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/alert_pictogram.dart';
import 'package:fujin/pages/common/confirm_sheet.dart';
import 'package:fujin/pages/common/glass_finish.dart';
import 'package:fujin/pages/common/trash_icon.dart';

Future<void> showRemoveWeighInSheet(
  BuildContext context, {
  required WeighIn weighIn,
  required VoidCallback onConfirm,
}) {
  FujinHaptics.press();
  final intl = context.intl;
  return showConfirmSheet(
    context,
    glyph: const AlertPictogram(icon: TrashIcon.asset),
    title: intl.weighInDeleteTitle(intl.weighInKilograms(weighIn.kilograms)),
    message: intl.weighInDeleteDetail(weighIn.date),
    confirmLabel: intl.weighInDeleteFromMfp,
    confirmFinish: GlassFinish.alert,
    skipLabel: intl.deleteKeep,
    onConfirm: onConfirm,
  );
}
