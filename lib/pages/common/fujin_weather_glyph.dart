import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/fujin_weather.dart';

class FujinWeatherGlyph extends StatelessWidget {
  const FujinWeatherGlyph({required this.weather, super.key});

  static const double _padding = FujinSpace.s2;
  static const double _side = FujinSize.icon + 2 * _padding;
  static const _cornerRatio = 0.28;

  final FujinWeather weather;

  @override
  Widget build(BuildContext context) => Container(
    width: _side,
    height: _side,
    padding: const EdgeInsets.all(_padding),
    decoration: BoxDecoration(
      color: weather.background,
      borderRadius: BorderRadius.circular(_side * _cornerRatio),
    ),
    child: SvgPicture.asset(
      weather.asset,
      theme: SvgTheme(currentColor: weather.foreground),
    ),
  );
}
