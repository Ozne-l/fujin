import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/common/fujin_weather.dart';
import 'package:fujin/pages/common/progress_bar.dart';
import 'package:fujin/pages/sending/widgets/glyph_card.dart';

class ProgressCard extends StatelessWidget {
  const ProgressCard({
    required this.title,
    required this.detail,
    required this.note,
    required this.done,
    required this.total,
    super.key,
  });

  final String title;
  final String detail;
  final String note;
  final int done;
  final int total;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return GlyphCard(
      weather: FujinWeather.breeze,
      title: title,
      titleColor: FujinColor.sora,
      background: FujinColorRole.backgroundCard,
      border: FujinColorRole.borderCard,
      padding: const EdgeInsets.fromLTRB(
        FujinSpace.s5,
        FujinSpace.s5,
        FujinSpace.s5,
        FujinSpace.s6,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: FujinSpace.s2,
        children: [
          Text(
            detail,
            style: FujinText.inter15Medium.copyWith(
              color: FujinColorRole.textPrimary,
            ),
          ),
          Row(
            spacing: FujinSpace.s6,
            children: [
              Expanded(
                child: ProgressBar(
                  fraction: switch (total) {
                    0 => 0,
                    _ => done / total,
                  },
                  color: FujinColor.sora,
                ),
              ),
              Text(
                l10n.progressCount(done, total),
                style: FujinText.inter13Medium.copyWith(
                  color: FujinColorRole.textSecondary,
                ),
              ),
            ],
          ),
          Text(
            note,
            style: FujinText.inter13Regular.copyWith(
              color: FujinColorRole.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
