import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/journal/journal_day.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/common/progress_bar.dart';
import 'package:fujin/pages/common/send_label.dart';
import 'package:fujin/pages/common/source_dot.dart';

class DaySummaryCard extends StatelessWidget {
  const DaySummaryCard({required this.day, required this.onSend, super.key});

  final JournalDay day;
  final VoidCallback onSend;

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
          if (SendLabel.of(l10n, counts.toSend, counts.toUpdate)
              case final label?)
            FilledButton(
              onPressed: onSend,
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
      SourceDot(color: dot),
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
