import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';

class DarkBadge extends StatelessWidget {
  const DarkBadge({required this.diameter, required this.child, super.key});

  static const double opacity = 0.72;

  final double diameter;
  final Widget child;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: ShapeDecoration(
      color: context.colors.backgroundDark.withValues(alpha: opacity),
      shape: const CircleBorder(),
    ),
    child: SizedBox.square(
      dimension: diameter,
      child: Center(child: child),
    ),
  );
}
