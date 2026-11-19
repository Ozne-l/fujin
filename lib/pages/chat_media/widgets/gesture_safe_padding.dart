import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';

class GestureSafePadding extends StatelessWidget {
  const GestureSafePadding({
    required this.child,
    this.vertical = 0,
    super.key,
  });

  final double vertical;
  final Widget child;

  static EdgeInsets insetsOf(
    BuildContext context, {
    double vertical = 0,
    double clearance = 0,
  }) {
    final gestures = MediaQuery.systemGestureInsetsOf(context);
    return EdgeInsets.fromLTRB(
      math.max(FujinSize.screenMargin, gestures.left + clearance),
      vertical,
      math.max(FujinSize.screenMargin, gestures.right + clearance),
      vertical,
    );
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: insetsOf(context, vertical: vertical),
    child: child,
  );
}
