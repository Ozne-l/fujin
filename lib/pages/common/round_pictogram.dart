import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RoundPictogram extends StatelessWidget {
  const RoundPictogram({
    required this.icon,
    required this.side,
    required this.iconSide,
    required this.background,
    required this.foreground,
    super.key,
  });

  final String icon;
  final double side;
  final double iconSide;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) => Container(
    width: side,
    height: side,
    alignment: Alignment.center,
    decoration: BoxDecoration(color: background, shape: BoxShape.circle),
    child: SvgPicture.asset(
      icon,
      width: iconSide,
      height: iconSide,
      theme: SvgTheme(currentColor: foreground),
      excludeFromSemantics: true,
    ),
  );
}
