import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';
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
    return GlyphCard(
      weather: FujinWeather.breeze,
      title: title,
      titleColor: context.colors.textInfo,
      background: context.colors.backgroundCard,
      border: context.colors.borderCard,
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
              color: context.colors.textPrimary,
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
                  color: context.colors.textInfo,
                ),
              ),
              Text(
                context.intl.progressCount(done, total),
                style: FujinText.inter13Medium.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            ],
          ),
          Text(
            note,
            style: FujinText.inter13Regular.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
