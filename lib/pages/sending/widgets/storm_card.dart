import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/fujin_weather.dart';
import 'package:fujin/pages/common/fujin_weather_glyph.dart';

class StormCard extends StatelessWidget {
  const StormCard({
    required this.title,
    required this.reason,
    required this.action,
    required this.onPressed,
    this.waiting,
    super.key,
  });

  static const double _glyphSide = 56;

  final String title;
  final String reason;
  final String? waiting;
  final String action;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.symmetric(horizontal: FujinSize.screenMargin),
    padding: const EdgeInsets.all(FujinSpace.s5),
    decoration: BoxDecoration(
      color: FujinColorRole.backgroundAlert,
      borderRadius: BorderRadius.circular(FujinRadius.sheet),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: FujinSpace.s4,
      children: [
        Row(
          spacing: FujinSpace.s4,
          children: [
            const FujinWeatherGlyph(
              weather: FujinWeather.storm,
              side: _glyphSide,
            ),
            Expanded(
              child: Text(
                title,
                style: FujinText.hina30.copyWith(
                  color: FujinColorRole.textAlert,
                ),
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: FujinSpace.s3,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: FujinSpace.s2,
              children: [
                Text(
                  reason,
                  style: FujinText.inter15Medium.copyWith(
                    color: FujinColorRole.textPrimary,
                  ),
                ),
                if (waiting case final waiting?)
                  Text(
                    waiting,
                    style: FujinText.inter13Regular.copyWith(
                      color: FujinColorRole.textSecondary,
                    ),
                  ),
              ],
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(FujinSize.buttonMedium),
                backgroundColor: FujinColorRole.buttonAlertBackground,
                foregroundColor: FujinColorRole.buttonAlertText,
                textStyle: FujinText.inter15Medium,
              ),
              onPressed: onPressed,
              child: Text(action),
            ),
          ],
        ),
      ],
    ),
  );
}
