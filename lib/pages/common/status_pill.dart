import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/pill_tone.dart';

class StatusPill extends StatelessWidget {
  const StatusPill({
    required this.label,
    required this.tone,
    this.icon,
    super.key,
  });

  final String label;
  final PillTone tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final style = FujinText.inter12Medium.copyWith(color: tone.foreground);
    return Container(
      height: FujinSize.pastille,
      padding: const EdgeInsets.symmetric(horizontal: FujinSpace.s3),
      decoration: BoxDecoration(
        color: tone.background,
        borderRadius: BorderRadius.circular(FujinRadius.pastille),
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
