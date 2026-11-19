import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/alert_pictogram.dart';
import 'package:fujin/pages/common/glass_finish.dart';
import 'package:fujin/pages/common/sheet_frame.dart';
import 'package:fujin/pages/common/trash_icon.dart';

Future<void> showDeleteMessageSheet(
  BuildContext context, {
  required String excerpt,
  required String coach,
  required VoidCallback onDelete,
}) => SheetFrame.show(
  context,
  builder: (context) => DeleteMessageSheet(
    excerpt: excerpt,
    coach: coach,
    onDelete: onDelete,
  ),
);

class DeleteMessageSheet extends StatelessWidget {
  const DeleteMessageSheet({
    required this.excerpt,
    required this.coach,
    required this.onDelete,
    super.key,
  });

  final String excerpt;
  final String coach;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    final intl = context.intl;
    return SheetFrame(
      glyph: const AlertPictogram(icon: TrashIcon.asset),
      title: intl.chatDeleteTitle,
      titleStyle: FujinText.hina24,
      subtitle: intl.chatDeleteDetail(excerpt, coach),
      subtitleStyle: FujinText.inter15RegularL22,
      primaryLabel: intl.chatDelete,
      primaryFinish: GlassFinish.alert,
      onPrimary: () {
        navigator.pop();
        onDelete();
      },
      onSkip: navigator.pop,
      skipLabel: intl.deleteKeep,
    );
  }
}
