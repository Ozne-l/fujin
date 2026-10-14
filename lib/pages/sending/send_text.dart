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

  static String grams(AppLocalizations intl, double grams) =>
      intl.gramsValue(double.parse(grams.toStringAsFixed(_gramDecimals)));

  static String nutrient(AppLocalizations intl, Nutrient nutrient) =>
      switch (nutrient) {
        Nutrient.kilocalories => intl.nutrientKilocalories,
        Nutrient.protein => intl.nutrientProtein,
        Nutrient.carbohydrates => intl.nutrientCarbohydrates,
        Nutrient.fat => intl.nutrientFat,
        Nutrient.fiber => intl.nutrientFiber,
      };

  static String delta(
    AppLocalizations intl,
    NutrientDeltas deltas,
    Nutrient nutrient,
  ) {
    final label = SendText.nutrient(intl, nutrient);
    return switch (deltas.of(nutrient)) {
      null => intl.deltaUnknown(label),
      final delta => switch ((delta * _percent).round()) {
        0 => intl.deltaNone(label),
        final percent when percent > 0 => intl.deltaUp(label, percent),
        final percent => intl.deltaDown(label, -percent),
      },
    };
  }

  static PillTone deltaTone(NutrientDeltas deltas, Nutrient nutrient) =>
      switch ((deltas.of(nutrient), deltas.fits(nutrient))) {
        (null, _) => PillTone.muted,
        (_, true) => PillTone.validated,
        (_, false) => PillTone.error,
      };

  static String nameMatch(AppLocalizations intl, NameMatch match) =>
      switch (match) {
        NameMatch.product => intl.nameMatchProduct,
        NameMatch.brand => intl.nameMatchBrand,
        NameMatch.none => intl.nameMatchNone,
      };

  static (String, PillTone) reason(
    AppLocalizations intl,
    ReviewReason reason,
  ) => switch (reason) {
    ReviewReason.weightToConfirm => (intl.pillWeightToConfirm, PillTone.error),
    ReviewReason.newAssociation => (
      intl.pillNewAssociation,
      PillTone.attention,
    ),
    ReviewReason.noCloseFood => (intl.pillNoCloseFood, PillTone.muted),
    ReviewReason.skipped => (intl.pillSkipped, PillTone.muted),
    ReviewReason.confirmed => (intl.pillConfirmed, PillTone.validated),
  };

  static String unattended(AppLocalizations intl, PlannedEntry planned) =>
      switch ((planned.reason, planned.choice)) {
        (ReviewReason.weightToConfirm, SendToEkkloFood(:final grams)) =>
          intl.unattendedWeight(SendText.grams(intl, grams)),
        (_, SendToEkkloFood(:final ekkloFoodName, :final food)) =>
          intl.unattendedClosest(switch (food?.brands) {
            final brands? => intl.weightFoodBrand(ekkloFoodName, brands),
            null => ekkloFoodName,
          }),
        (_, SendAsOwnCopy()) => intl.unattendedOwnCopy,
        (_, SkipEntry()) => intl.skippedDetail,
      };

  static String kept(AppLocalizations intl, PlannedEntry planned) =>
      switch (planned.choice) {
        SendAsOwnCopy() => intl.towards(intl.ownCopy),
        SendToEkkloFood() || SkipEntry() => target(intl, planned),
      };

  static String target(AppLocalizations intl, PlannedEntry planned) =>
      switch (planned.choice) {
        SendToEkkloFood(:final ekkloFoodName, :final grams) =>
          intl.towardsAmount(ekkloFoodName, SendText.grams(intl, grams)),
        SendAsOwnCopy(reuse: null) => intl.towards(intl.ownCopyToCreate),
        SendAsOwnCopy() => intl.towards(intl.ownCopy),
        SkipEntry() => intl.skippedDetail,
      };
}
