import 'package:fujin/domain/sending/name_match.dart';
import 'package:fujin/domain/sending/nutrient.dart';
import 'package:fujin/domain/sending/nutrient_deltas.dart';
import 'package:fujin/domain/sending/planned_entry.dart';
import 'package:fujin/domain/sending/review_reason.dart';
import 'package:fujin/domain/sending/send_choice.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/common/pill_tone.dart';

abstract final class SendText {
  static const _percent = 100;
  static const _gramDecimals = 1;

  static String grams(AppLocalizations l10n, double grams) =>
      l10n.gramsValue(double.parse(grams.toStringAsFixed(_gramDecimals)));

  static String nutrient(AppLocalizations l10n, Nutrient nutrient) =>
      switch (nutrient) {
        Nutrient.kilocalories => l10n.nutrientKilocalories,
        Nutrient.protein => l10n.nutrientProtein,
        Nutrient.carbohydrates => l10n.nutrientCarbohydrates,
        Nutrient.fat => l10n.nutrientFat,
        Nutrient.fiber => l10n.nutrientFiber,
      };

  static String delta(
    AppLocalizations l10n,
    NutrientDeltas deltas,
    Nutrient nutrient,
  ) {
    final label = SendText.nutrient(l10n, nutrient);
    return switch (deltas.of(nutrient)) {
      null => l10n.deltaUnknown(label),
      final delta => switch ((delta * _percent).round()) {
        0 => l10n.deltaNone(label),
        final percent when percent > 0 => l10n.deltaUp(label, percent),
        final percent => l10n.deltaDown(label, -percent),
      },
    };
  }

  static PillTone deltaTone(NutrientDeltas deltas, Nutrient nutrient) =>
      switch ((deltas.of(nutrient), deltas.fits(nutrient))) {
        (null, _) => PillTone.muted,
        (_, true) => PillTone.validated,
        (_, false) => PillTone.error,
      };

  static String nameMatch(AppLocalizations l10n, NameMatch match) =>
      switch (match) {
        NameMatch.product => l10n.nameMatchProduct,
        NameMatch.brand => l10n.nameMatchBrand,
        NameMatch.none => l10n.nameMatchNone,
      };

  static (String, PillTone) reason(
    AppLocalizations l10n,
    ReviewReason reason,
  ) => switch (reason) {
    ReviewReason.weightToConfirm => (l10n.pillWeightToConfirm, PillTone.error),
    ReviewReason.newAssociation => (
      l10n.pillNewAssociation,
      PillTone.attention,
    ),
    ReviewReason.noCloseFood => (l10n.pillNoCloseFood, PillTone.muted),
    ReviewReason.skipped => (l10n.pillSkipped, PillTone.muted),
    ReviewReason.confirmed => (l10n.pillConfirmed, PillTone.validated),
  };

  static String target(AppLocalizations l10n, PlannedEntry planned) =>
      switch (planned.choice) {
        SendToEkkloFood(:final ekkloFoodName, :final grams) =>
          l10n.towardsAmount(ekkloFoodName, SendText.grams(l10n, grams)),
        SendAsOwnCopy(reuse: null) => l10n.towards(l10n.ownCopyToCreate),
        SendAsOwnCopy() => l10n.towards(l10n.ownCopy),
        SkipEntry() => l10n.skippedDetail,
      };
}
