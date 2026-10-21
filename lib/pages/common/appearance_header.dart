import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/appearance_corner.dart';

class AppearanceHeader extends StatelessWidget {
  const AppearanceHeader({
    required this.firstLine,
    required this.child,
    super.key,
  });

  final TextStyle firstLine;
  final Widget child;

  static double lineHeight(BuildContext context, TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(style: style),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
    );
    final height = painter.preferredLineHeight;
    painter.dispose();
    return height;
  }

  static double centredTop(BuildContext context, TextStyle style) =>
      math.max(0, AppearanceCorner.centre - lineHeight(context, style) / 2);

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(
      minHeight: AppearanceCorner.centre + FujinSize.touchTarget / 2,
    ),
    child: Padding(
      padding: EdgeInsets.only(top: centredTop(context, firstLine)),
      child: child,
    ),
  );
}
