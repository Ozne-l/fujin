import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_theme.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/fujin_weather.dart';
import 'package:fujin/pages/sending/widgets/glyph_card.dart';

class StormCard extends StatelessWidget {
  const StormCard({
    required this.title,
    required this.reason,
    required this.action,
    required this.onPressed,
    this.waiting,
    super.key,
  });

  final String title;
  final String reason;
  final String? waiting;
  final String action;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => GlyphCard(
    weather: FujinWeather.storm,
    title: title,
    titleColor: FujinColorRole.textAlert,
    background: FujinColorRole.backgroundAlert,
    padding: const EdgeInsets.all(FujinSpace.s5),
    child: Column(
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
          style: FujinTheme.alertButtonStyle,
          onPressed: onPressed,
          child: Text(action),
        ),
      ],
    ),
  );
}
