import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/sending/sheets/sheet_frame.dart';

class SheetMessage extends StatelessWidget {
  const SheetMessage({required this.text, required this.color, super.key});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => SheetFrame.inset(
    Text(text, style: FujinText.inter13Regular.copyWith(color: color)),
  );
}
