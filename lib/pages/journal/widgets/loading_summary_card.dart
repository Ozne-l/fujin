import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/common/fujin_weather.dart';
import 'package:fujin/pages/common/fujin_weather_glyph.dart';
import 'package:fujin/pages/journal/journal_text.dart';
import 'package:fujin/pages/journal/widgets/skeleton_bar.dart';

class LoadingSummaryCard extends StatelessWidget {
  const LoadingSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: FujinSize.screenMargin),
      padding: const EdgeInsets.all(FujinSpace.s5),
      decoration: BoxDecoration(
        color: FujinColorRole.backgroundCard,
        borderRadius: BorderRadius.circular(FujinRadius.card),
        border: Border.all(color: FujinColorRole.borderCard),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: FujinSpace.s5,
        children: [
          Row(
            spacing: FujinSpace.s3,
            children: [
              const FujinWeatherGlyph(weather: FujinWeather.breeze),
              Expanded(
                child: Text(
                  l10n.journalLoading,
                  style: FujinText.inter15Medium.copyWith(
                    color: FujinColorRole.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: FujinSpace.s2,
            children: [
              const SkeletonBar(
                width: FujinSize.skeletonWide,
                height: FujinSize.skeletonLine,
              ),
              const SkeletonBar(
                width: FujinSize.skeletonMedium,
                height: FujinSize.skeletonLine,
              ),
              Row(
                spacing: FujinSpace.s3,
                children: [
                  for (final _ in JournalText.macros)
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: FujinSpace.s2,
                        children: [
                          SkeletonBar(
                            width: FujinSize.skeletonMacroWidth,
                            height: FujinSize.skeletonMacro,
                          ),
                          SkeletonBar(height: FujinSize.macroBar),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SkeletonBar(height: FujinSize.kcalBar),
          FilledButton(
            onPressed: null,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(FujinSize.buttonMedium),
              textStyle: FujinText.inter15Medium,
            ),
            child: Text(l10n.sendToEkklo),
          ),
        ],
      ),
    );
  }
}
