import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/fujin_weather.dart';
import 'package:fujin/pages/common/fujin_weather_glyph.dart';

class GlyphCard extends StatelessWidget {
  const GlyphCard({
    required this.weather,
    required this.title,
    required this.titleColor,
    required this.background,
    required this.padding,
    required this.child,
    this.border,
    super.key,
  });

  final FujinWeather weather;
  final String title;
  final Color titleColor;
  final Color background;
  final Color? border;
  final EdgeInsets padding;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.symmetric(horizontal: FujinSize.screenMargin),
    padding: padding,
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(FujinRadius.sheet),
      border: switch (border) {
        null => null,
        final border => Border.all(color: border),
      },
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: FujinSpace.s4,
      children: [
        Row(
          spacing: FujinSpace.s4,
          children: [
            FujinWeatherGlyph(weather: weather, side: FujinSize.glyphCard),
            Expanded(
              child: Text(
                title,
                style: FujinText.hina30.copyWith(color: titleColor),
              ),
            ),
          ],
        ),
        child,
      ],
    ),
  );
}
