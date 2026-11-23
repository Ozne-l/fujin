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

  const FujinMenuButton.pill({
    required this.label,
    required this.expanded,
    required this.onTap,
    required Widget this.leading,
    super.key,
  }) : height = FujinSize.buttonMedium,
       radius = FujinRadius.pill,
       padding = pillPadding,
       style = FujinText.inter14Medium,
       chevronSize = FujinSize.mealArrow,
       spacing = FujinSpace.s2,
       width = null,
       semanticsLabel = null;

  static const pillPadding = EdgeInsetsDirectional.symmetric(
    horizontal: FujinSpace.s4,
  );

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
          color: context.colors.backgroundCard,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
            side: BorderSide(color: context.colors.borderCard),
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
                      style: style.copyWith(color: context.colors.textPrimary),
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
                      color: context.colors.textPrimary,
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
