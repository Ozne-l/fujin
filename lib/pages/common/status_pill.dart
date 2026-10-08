import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/pill_size.dart';
import 'package:fujin/pages/common/pill_tone.dart';

class StatusPill extends StatelessWidget {
  const StatusPill({
    required this.label,
    required this.tone,
    this.icon,
    this.size = PillSize.regular,
    super.key,
  });

  final String label;
  final PillTone tone;
  final IconData? icon;
  final PillSize size;

  @override
  Widget build(BuildContext context) {
    final style = size.style.copyWith(color: tone.foreground);
    return Container(
      height: size.height,
      padding: EdgeInsets.symmetric(horizontal: size.inset),
      decoration: BoxDecoration(
        color: tone.background,
        borderRadius: BorderRadius.circular(FujinRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: FujinSpace.s1,
        children: [
          if (icon case final icon?)
            Icon(icon, size: style.fontSize, color: tone.foreground),
          Text(label, style: style),
        ],
      ),
    );
  }
}
