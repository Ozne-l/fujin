import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';

class DaySeparator extends StatelessWidget {
  const DaySeparator({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: FujinSpace.s4, bottom: FujinSpace.s2),
    child: Center(
      child: Text(
        label,
        style: FujinText.inter12Medium.copyWith(
          color: context.colors.textSecondary,
        ),
      ),
    ),
  );
}
