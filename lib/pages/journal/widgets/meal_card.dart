import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/comparison/compared_entry.dart';
import 'package:fujin/domain/comparison/entry_status.dart';
import 'package:fujin/domain/journal/journal_meal.dart';
import 'package:fujin/domain/journal/status_counts.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/common/pill_tone.dart';
import 'package:fujin/pages/common/status_pill.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

class MealCard extends StatelessWidget {
  const MealCard({required this.meal, super.key});

  final JournalMeal meal;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final counts = meal.counts;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: FujinSize.margeEcran),
      padding: const EdgeInsets.all(FujinSpace.s5),
      decoration: BoxDecoration(
        color: FujinRole.fondCarte,
        borderRadius: BorderRadius.circular(FujinRadius.carte),
        border: Border.all(
          color: FujinRole.bordureCarte,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: FujinSpace.s3,
        children: [
          _Line(
            leading: Text(
              meal.name,
              style: FujinText.inter16Medium.copyWith(
                color: FujinRole.textePrincipal,
              ),
            ),
            trailing: Text(
              l10n.kilocalories(meal.kilocalories),
              style: FujinText.inter15Semibold.copyWith(
                color: FujinRole.textePrincipal,
              ),
            ),
          ),
          if (counts.total > 0)
            _Line(
              leading: Text(
                l10n.mealProgress(counts.inEkklo, counts.total),
                style: FujinText.inter13Regular.copyWith(
                  color: FujinRole.texteSecondaire,
                ),
              ),
              trailing: Wrap(
                spacing: FujinSpace.s1,
                children: [
                  for (final (label, tone) in _mealPills(l10n, counts))
                    StatusPill(label: label, tone: tone),
                ],
              ),
            ),
          for (final compared in meal.entries) ...[
            const Divider(),
            _EntryRow(compared),
          ],
        ],
      ),
    );
  }

  static List<(String, PillTone)> _mealPills(
    AppLocalizations l10n,
    StatusCounts counts,
  ) => switch ((counts.toSend, counts.toUpdate)) {
    (0, 0) => [(l10n.statusInEkklo, PillTone.validated)],
    (final send, 0) => [(l10n.mealToSend(send), PillTone.attention)],
    (0, final update) => [(l10n.mealToUpdate(update), PillTone.info)],
    (final send, final update) => [
      (l10n.mealToSend(send), PillTone.attention),
      (l10n.mealToUpdate(update), PillTone.info),
    ],
  };
}

class _EntryRow extends StatelessWidget {
  const _EntryRow(this.compared);

  final ComparedEntry compared;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final entry = compared.entry;
    final detail = switch (compared.status) {
      ToUpdate(:final link) => l10n.inEkkloAs(
        l10n.servingLine(
          link.mfpServings,
          link.mfpServingValue,
          link.mfpServingUnit,
        ),
      ),
      InEkklo() || ToSend() => _macros(l10n, entry.nutrients),
    };
    final (label, tone, icon) = switch (compared.status) {
      InEkklo() => (l10n.statusInEkklo, PillTone.validated, null),
      ToSend() => (l10n.statusToSend, PillTone.attention, null),
      ToUpdate() => (l10n.statusToUpdate, PillTone.info, Icons.refresh),
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: FujinSpace.s1,
      children: [
        _Line(
          leading: Text(
            entry.food.description,
            style: FujinText.inter15Medium.copyWith(
              color: FujinRole.textePrincipal,
            ),
          ),
          trailing: Text(
            l10n.kilocalories(entry.nutrients.energy?.kilocalories ?? 0),
            style: FujinText.inter15Semibold.copyWith(
              color: FujinRole.textePrincipal,
            ),
          ),
        ),
        _Line(
          leading: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: FujinSpace.s1,
            children: [
              Text(
                _serving(l10n, entry),
                style: FujinText.inter13Regular.copyWith(
                  color: FujinRole.texteSecondaire,
                ),
              ),
              Text(
                detail,
                style: FujinText.inter12Medium.copyWith(
                  color: FujinRole.texteTertiaire,
                ),
              ),
            ],
          ),
          trailing: StatusPill(label: label, tone: tone, icon: icon),
        ),
      ],
    );
  }

  static String _serving(AppLocalizations l10n, MfpFoodEntry entry) {
    final serving = l10n.servingLine(
      entry.servings,
      entry.servingSize.value,
      entry.servingSize.unit,
    );
    return switch (entry.food.brandName) {
      null || '' => serving,
      final brand => l10n.brandedServingLine(brand, serving),
    };
  }

  static String _macros(AppLocalizations l10n, MfpNutrients nutrients) {
    String amount(double? grams) => switch (grams) {
      null => l10n.macroUnknown,
      final grams => l10n.macroValue(grams),
    };
    return l10n.macros(
      amount(nutrients.protein),
      amount(nutrients.carbohydrates),
      amount(nutrients.fat),
      amount(nutrients.fiber),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.leading, required this.trailing});

  final Widget leading;
  final Widget trailing;

  @override
  Widget build(BuildContext context) => Row(
    spacing: FujinSpace.s3,
    children: [
      Expanded(child: leading),
      trailing,
    ],
  );
}
