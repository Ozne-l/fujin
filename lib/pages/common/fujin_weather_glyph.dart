import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/fujin_weather.dart';

class FujinWeatherGlyph extends StatelessWidget {
  const FujinWeatherGlyph({
    required this.weather,
    this.side = defaultSide,
    super.key,
  });

  static const double defaultSide = FujinSize.icon + 2 * FujinSpace.s2;
  static const double _paddingRatio = FujinSpace.s2 / defaultSide;
  static const _cornerRatio = 0.28;

  final FujinWeather weather;
  final double side;

  @override
  Widget build(BuildContext context) => Container(
    width: side,
    height: side,
    padding: EdgeInsets.all(side * _paddingRatio),
    decoration: BoxDecoration(
      color: weather.background,
      borderRadius: BorderRadius.circular(side * _cornerRatio),
    ),
    child: SvgPicture.asset(
      weather.asset,
      theme: SvgTheme(currentColor: weather.foreground),
    ),
  );
}
