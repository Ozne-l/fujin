import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';

class FieldHelper extends StatelessWidget {
  const FieldHelper({
    required this.icon,
    required this.text,
    required this.color,
    super.key,
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Row(
    spacing: FujinSpace.s2,
    children: [
      Icon(icon, size: FujinSize.tileIcon, color: color),
      Flexible(
        child: Text(
          text,
          style: FujinText.inter13Medium.copyWith(color: color),
        ),
      ),
    ],
  );
}
