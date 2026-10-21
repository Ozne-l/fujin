import 'package:flutter/material.dart';

final class FujinScrollBehavior extends MaterialScrollBehavior {
  const FujinScrollBehavior();

  static const ScrollPhysics _bounce = BouncingScrollPhysics(
    parent: RangeMaintainingScrollPhysics(),
  );

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) => _bounce;

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) => child;
}
