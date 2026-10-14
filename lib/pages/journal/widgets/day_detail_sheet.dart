import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/journal/day_nutrients.dart';
import 'package:fujin/domain/journal/journal_day.dart';
import 'package:fujin/domain/sending/nutrient.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/send_label.dart';
import 'package:fujin/pages/common/source_dot.dart';
import 'package:fujin/pages/common/title_text.dart';
import 'package:fujin/pages/journal/journal_text.dart';
import 'package:fujin/pages/sending/sheets/sheet_frame.dart';

Future<void> showDayDetailSheet(
  BuildContext context, {
  required JournalDay day,
  required VoidCallback onSend,
}) => SheetFrame.show(
  context,
  builder: (context) => _DayDetail(day: day, onSend: onSend),
);

class _DayDetail extends StatelessWidget {
  const _DayDetail({required this.day, required this.onSend});

  final JournalDay day;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    final counts = day.counts;
    final mfp = day.nutrients;
    final ekklo = day.ekkloNutrients;
    final notes = [
      if (counts.pending > 0)
        context.intl.dayDetailPending(counts.pending, counts.total),
      if (mfp.isPartial(Nutrient.fiber)) context.intl.fiberNote,
    ];
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        FujinSize.textInset,
        0,
        FujinSize.textInset,
        FujinSpace.s3,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: FujinSpace.s4,
          children: [
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                onPressed: navigator.pop,
                style: TextButton.styleFrom(
                  textStyle: FujinText.inter13Medium,
                ),
                child: Text(context.intl.close),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: FujinSpace.s1,
              children: [
                Text(
                  TitleText.capitalized(context.intl.journalDay(day.date)),
                  style: FujinText.inter13Regular.copyWith(
                    color: FujinColorRole.textSecondary,
                  ),
                ),
                Text(
                  context.intl.dayDetailTitle,
                  style: FujinText.hina30.copyWith(
                    color: FujinColorRole.textPrimary,
                  ),
                ),
                _Row(
                  label: const SizedBox.shrink(),
                  mfp: _Header(
                    dot: FujinColorRole.sourceMfp,
                    label: context.intl.sourceMyFitnessPal,
                  ),
                  ekklo: _Header(
                    dot: FujinColorRole.sourceEkklo,
                    label: context.intl.sourceEkklo,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final nutrient in Nutrient.values) ...[
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: FujinSpace.s3,
                    ),
                    child: _NutrientRow(
                      nutrient: nutrient,
                      mfp: mfp,
                      ekklo: ekklo,
                    ),
                  ),
                ],
                const Divider(),
              ],
            ),
            if (notes.isNotEmpty)
              Text(
                notes.join('\n'),
                style: FujinText.inter12Regular.copyWith(
                  color: FujinColorRole.textSecondary,
                ),
              ),
            if (SendLabel.of(context.intl, counts.toSend, counts.toUpdate)
                case final label?)
              FilledButton(
                onPressed: () {
                  navigator.pop();
                  onSend();
                },
                child: Text(label),
              ),
          ],
        ),
      ),
    );
  }
}

class _NutrientRow extends StatelessWidget {
  const _NutrientRow({
    required this.nutrient,
    required this.mfp,
    required this.ekklo,
  });

  final Nutrient nutrient;
  final DayNutrients mfp;
  final DayNutrients ekklo;

  @override
  Widget build(BuildContext context) {
    final style = switch (nutrient) {
      Nutrient.kilocalories => FujinText.inter13Semibold,
      Nutrient.protein ||
      Nutrient.carbohydrates ||
      Nutrient.fat ||
      Nutrient.fiber => FujinText.inter13Medium,
    }.copyWith(color: FujinColorRole.textPrimary);
    return _Row(
      label: Text(
        JournalText.name(context.intl, nutrient),
        style: FujinText.inter13Regular.copyWith(
          color: FujinColorRole.textSecondary,
        ),
      ),
      mfp: Text(
        JournalText.amount(context.intl, mfp, nutrient),
        style: style,
        textAlign: TextAlign.end,
      ),
      ekklo: Text(
        JournalText.amount(context.intl, ekklo, nutrient),
        style: style,
        textAlign: TextAlign.end,
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.dot, required this.label});

  final Color dot;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    spacing: FujinSpace.s2,
    children: [
      SourceDot(color: dot),
      Flexible(
        child: Text(
          label,
          overflow: TextOverflow.ellipsis,
          style: FujinText.inter12Medium.copyWith(
            color: FujinColorRole.textSecondary,
          ),
        ),
      ),
    ],
  );
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.mfp, required this.ekklo});

  final Widget label;
  final Widget mfp;
  final Widget ekklo;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.end,
    spacing: FujinSpace.s3,
    children: [
      Expanded(child: label),
      Expanded(child: mfp),
      Expanded(child: ekklo),
    ],
  );
}
