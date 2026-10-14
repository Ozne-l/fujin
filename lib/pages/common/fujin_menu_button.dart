import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:motor/motor.dart';

class FujinMenuButton extends StatelessWidget {
  const FujinMenuButton({
    required this.label,
    required this.expanded,
    required this.onTap,
    required this.height,
    required this.radius,
    required this.padding,
    this.style = FujinText.inter14Medium,
    this.chevronSize = FujinSize.menuChevron,
    this.spacing = FujinSpace.s2,
    this.leading,
    this.width,
    this.semanticsLabel,
    super.key,
  });

  static const double _halfTurn = math.pi;

  final String label;
  final bool expanded;
  final VoidCallback onTap;
  final double height;
  final double radius;
  final EdgeInsetsGeometry padding;
  final TextStyle style;
  final double chevronSize;
  final double spacing;
  final Widget? leading;
  final double? width;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) => MergeSemantics(
    child: Semantics(
      button: true,
      expanded: expanded,
      label: semanticsLabel,
      child: SizedBox(
        width: width,
        height: height,
        child: Material(
          color: FujinColorRole.backgroundCard,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
            side: const BorderSide(color: FujinColorRole.borderCard),
          ),
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: padding,
              child: Row(
                spacing: spacing,
                children: [
                  ?leading,
                  Expanded(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: style.copyWith(color: FujinColorRole.textPrimary),
                    ),
                  ),
                  SingleMotionBuilder(
                    motion: FujinMotion.of(context, FujinMotion.pill),
                    value: switch (expanded) {
                      true => 1,
                      false => 0,
                    },
                    builder: (context, turn, child) => Transform.rotate(
                      angle: turn * _halfTurn,
                      child: child,
                    ),
                    child: Icon(
                      Icons.expand_more,
                      size: chevronSize,
                      color: FujinColorRole.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
