import 'package:dart_mappable/dart_mappable.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/data/links/sent_link.dart';
import 'package:fujin/domain/comparison/expected_item.dart';
import 'package:fujin/domain/comparison/gram_unit.dart';
import 'package:fujin/domain/sending/ekklo_candidate.dart';
import 'package:fujin/domain/sending/review_reason.dart';
import 'package:fujin/domain/sending/send_choice.dart';
import 'package:fujin/domain/sending/unit_weight.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

part 'planned_entry.mapper.dart';

@MappableClass()
final class PlannedEntry with PlannedEntryMappable {
  const PlannedEntry({
    required this.entry,
    required this.entryId,
    required this.ekkloMealName,
    required this.choice,
    required this.reviewed,
    this.confirmed = false,
    this.candidates = const [],
    this.rememberedEkkloFoodId,
    this.rememberedGramsPerUnit,
    this.replacing,
  });

  static const _decimals = 1;

  final MfpFoodEntry entry;
  final String entryId;
  final String ekkloMealName;
  final SendChoice choice;
  final bool reviewed;
  final bool confirmed;
  final List<EkkloCandidate> candidates;
  final String? rememberedEkkloFoodId;
  final double? rememberedGramsPerUnit;
  final SentLink? replacing;

  double get units => entry.servingSize.value * entry.servings;

  bool get sends => switch (choice) {
    SkipEntry() => false,
    SendToEkkloFood() || SendAsOwnCopy() => true,
  };

  ReviewReason get reason => switch ((choice, confirmed)) {
    (SkipEntry(), _) => ReviewReason.skipped,
    (SendToEkkloFood(weight: UnitWeight.estimated), _) =>
      ReviewReason.weightToConfirm,
    (_, true) => ReviewReason.confirmed,
    (SendToEkkloFood(remembered: false), false) => ReviewReason.newAssociation,
    (SendAsOwnCopy(reuse: null), false) => ReviewReason.noCloseFood,
    (SendToEkkloFood() || SendAsOwnCopy(), false) => ReviewReason.confirmed,
  };

  PlannedEntry choose(EkkloCandidate candidate) => copyWith(
    confirmed: true,
    choice: SendToEkkloFood(
      ekkloFoodId: candidate.food.id,
      ekkloFoodName: candidate.food.name,
      grams: candidate.grams,
      remembered: candidate.food.id == rememberedEkkloFoodId,
      food: candidate.food,
      weight: switch ((
        isGramUnit(entry.servingSize.unit),
        candidate.gramsInferred,
      )) {
        (true, _) => UnitWeight.notNeeded,
        (false, true) => UnitWeight.estimated,
        (false, false) => UnitWeight.remembered,
      },
      gramsPerUnit: switch (isGramUnit(entry.servingSize.unit)) {
        true => null,
        false => candidate.grams / units,
      },
    ),
  );

  PlannedEntry asOwnCopy() =>
      copyWith(confirmed: true, choice: const SendAsOwnCopy());

  PlannedEntry skip() => copyWith(choice: const SkipEntry());

  PlannedEntry confirm() => copyWith(confirmed: true);

  PlannedEntry weighing(double gramsPerUnit) => switch (choice) {
    final SendToEkkloFood choice => copyWith(
      choice: choice.copyWith(
        gramsPerUnit: gramsPerUnit,
        grams: units * gramsPerUnit,
        weight: UnitWeight.confirmed,
      ),
    ),
    SendAsOwnCopy() || SkipEntry() => this,
  };

  ExpectedItem expectedIn(
    String ekkloFoodId,
    EkkloQuantityType quantityType,
  ) => ExpectedItem(
    ekkloMealName: ekkloMealName,
    ekkloFoodId: ekkloFoodId,
    quantity: double.parse(
      switch (choice) {
        SendToEkkloFood(:final grams) => grams,
        SendAsOwnCopy() || SkipEntry() => units,
      }.toStringAsFixed(_decimals),
    ),
    quantityType: quantityType,
  );
}
