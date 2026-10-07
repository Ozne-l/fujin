import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/journal/journal_day.dart';
import 'package:fujin/domain/journal/status_counts.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/common/progress_bar.dart';

class DaySummaryCard extends StatelessWidget {
  const DaySummaryCard({required this.day, super.key});

  final JournalDay day;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final counts = day.counts;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: FujinSize.screenMargin),
      padding: const EdgeInsets.fromLTRB(
        FujinSpace.s5,
        FujinSpace.s4,
        FujinSpace.s5,
        FujinSpace.s4,
      ),
      decoration: BoxDecoration(
        color: FujinColorRole.backgroundCard,
        borderRadius: BorderRadius.circular(FujinRadius.card),
        border: Border.all(
          color: FujinColorRole.borderCard,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: FujinSpace.s4,
        children: [
          _SourceLine(
            dot: FujinColorRole.sourceMfp,
            label: l10n.sourceMyFitnessPal,
            trailing: [
              TextSpan(
                text: l10n.kilocaloriesValue(day.kilocalories),
                style: FujinText.inter15Semibold,
              ),
            ],
          ),
          const Divider(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: FujinSpace.s3,
            children: [
              _SourceLine(
                dot: FujinColorRole.sourceEkklo,
                label: l10n.sourceEkklo,
                trailing: [
                  TextSpan(
                    text: l10n.kilocalories(day.ekkloKilocalories),
                    style: FujinText.inter13Semibold,
                  ),
                  TextSpan(
                    text:
                        ' ${l10n.ekkloProgress(counts.inEkklo, counts.total)}',
                    style: FujinText.inter13Regular.copyWith(
                      color: FujinColorRole.textSecondary,
                    ),
                  ),
                ],
              ),
              ProgressBar(
                fraction: switch (counts.total) {
                  0 => 0,
                  final total => counts.inEkklo / total,
                },
                color: FujinColor.fujin,
              ),
            ],
          ),
          if (_sendLabel(l10n, counts) case final label?)
            FilledButton(
              onPressed: null,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(FujinSize.buttonMedium),
                disabledBackgroundColor:
                    FujinColorRole.buttonDisabledBackground,
                disabledForegroundColor: FujinColorRole.buttonDisabledText,
                textStyle: FujinText.inter15Medium,
                shape: const StadiumBorder(),
              ),
              child: Text(label),
            ),
        ],
      ),
    );
  }

  static String? _sendLabel(AppLocalizations l10n, StatusCounts counts) =>
      switch ((counts.toSend, counts.toUpdate)) {
        (0, 0) => null,
        (final send, 0) => l10n.sendFoods(send),
        (0, final update) => l10n.updateFoods(update),
        (final send, final update) => l10n.sendAndUpdateFoods(send, update),
      };
}

class _SourceLine extends StatelessWidget {
  const _SourceLine({
    required this.dot,
    required this.label,
    required this.trailing,
  });

  final Color dot;
  final String label;
  final List<TextSpan> trailing;

  @override
  Widget build(BuildContext context) => Row(
    spacing: FujinSpace.s2,
    children: [
      Container(
        width: FujinSpace.s2,
        height: FujinSpace.s2,
        decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
      ),
      Expanded(
        child: Text(
          label,
          style: FujinText.inter13Medium.copyWith(
            color: FujinColorRole.textPrimary,
          ),
        ),
      ),
      Text.rich(
        TextSpan(
          style: const TextStyle(color: FujinColorRole.textPrimary),
          children: trailing,
        ),
      ),
    ],
  );
}
