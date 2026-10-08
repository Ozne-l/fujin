import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/fujin_weather.dart';
import 'package:fujin/pages/common/fujin_weather_glyph.dart';

class AlertBanner extends StatelessWidget {
  const AlertBanner({required this.title, this.detail, super.key});

  final String title;
  final String? detail;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(FujinSpace.s4),
    decoration: BoxDecoration(
      color: FujinColorRole.backgroundAlert,
      borderRadius: BorderRadius.circular(FujinRadius.card),
    ),
    child: Row(
      spacing: FujinSpace.s3,
      children: [
        const FujinWeatherGlyph(weather: FujinWeather.storm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: FujinSpace.s1,
            children: [
              Text(
                title,
                style: FujinText.inter15Medium.copyWith(
                  color: FujinColorRole.textPrimary,
                ),
              ),
              if (detail case final detail?)
                Text(
                  detail,
                  style: FujinText.inter13Regular.copyWith(
                    color: FujinColorRole.textSecondary,
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}
