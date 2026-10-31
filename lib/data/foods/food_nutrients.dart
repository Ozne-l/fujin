import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/foods/energy_unit.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

part 'food_nutrients.mapper.dart';

@MappableClass()
final class FoodNutrients with FoodNutrientsMappable {
  const FoodNutrients({
    this.energyValue,
    this.energyUnit,
    this.protein,
    this.carbohydrates,
    this.netCarbs,
    this.fiber,
    this.sugar,
    this.addedSugars,
    this.sugarAlcohols,
    this.fat,
    this.saturatedFat,
    this.monounsaturatedFat,
    this.polyunsaturatedFat,
    this.transFat,
    this.cholesterolMilligrams,
    this.sodiumMilligrams,
    this.potassiumMilligrams,
    this.vitaminA,
    this.vitaminC,
    this.vitaminD,
    this.calcium,
    this.iron,
  });

  factory FoodNutrients.ofMfp(MfpNutrients? nutrients) => FoodNutrients(
    energyValue: switch (nutrients?.energy) {
      MfpEnergy(unit: MfpEnergyUnit.unknown) || null => null,
      MfpEnergy(:final value) => value,
    },
    energyUnit: switch (nutrients?.energy?.unit) {
      MfpEnergyUnit.calories => EnergyUnit.calories,
      MfpEnergyUnit.kilojoules => EnergyUnit.kilojoules,
      MfpEnergyUnit.unknown || null => null,
    },
    protein: nutrients?.protein,
    carbohydrates: nutrients?.carbohydrates,
    netCarbs: nutrients?.netCarbs,
    fiber: nutrients?.fiber,
    sugar: nutrients?.sugar,
    addedSugars: nutrients?.addedSugars,
    sugarAlcohols: nutrients?.sugarAlcohols,
    fat: nutrients?.fat,
    saturatedFat: nutrients?.saturatedFat,
    monounsaturatedFat: nutrients?.monounsaturatedFat,
    polyunsaturatedFat: nutrients?.polyunsaturatedFat,
    transFat: nutrients?.transFat,
    cholesterolMilligrams: nutrients?.cholesterolMilligrams,
    sodiumMilligrams: nutrients?.sodiumMilligrams,
    potassiumMilligrams: nutrients?.potassiumMilligrams,
    vitaminA: nutrients?.vitaminA,
    vitaminC: nutrients?.vitaminC,
    vitaminD: nutrients?.vitaminD,
    calcium: nutrients?.calcium,
    iron: nutrients?.iron,
  );

  final double? energyValue;
  final EnergyUnit? energyUnit;
  final double? protein;
  final double? carbohydrates;
  final double? netCarbs;
  final double? fiber;
  final double? sugar;
  final double? addedSugars;
  final double? sugarAlcohols;
  final double? fat;
  final double? saturatedFat;
  final double? monounsaturatedFat;
  final double? polyunsaturatedFat;
  final double? transFat;
  final double? cholesterolMilligrams;
  final double? sodiumMilligrams;
  final double? potassiumMilligrams;
  final double? vitaminA;
  final double? vitaminC;
  final double? vitaminD;
  final double? calcium;
  final double? iron;

  MfpNutrients toMfp() => MfpNutrients(
    energy: switch ((energyValue, energyUnit)) {
      (final value?, EnergyUnit.calories) => MfpEnergy(
        unit: MfpEnergyUnit.calories,
        value: value,
      ),
      (final value?, EnergyUnit.kilojoules) => MfpEnergy(
        unit: MfpEnergyUnit.kilojoules,
        value: value,
      ),
      _ => null,
    },
    protein: protein,
    carbohydrates: carbohydrates,
    netCarbs: netCarbs,
    fiber: fiber,
    sugar: sugar,
    addedSugars: addedSugars,
    sugarAlcohols: sugarAlcohols,
    fat: fat,
    saturatedFat: saturatedFat,
    monounsaturatedFat: monounsaturatedFat,
    polyunsaturatedFat: polyunsaturatedFat,
    transFat: transFat,
    cholesterolMilligrams: cholesterolMilligrams,
    sodiumMilligrams: sodiumMilligrams,
    potassiumMilligrams: potassiumMilligrams,
    vitaminA: vitaminA,
    vitaminC: vitaminC,
    vitaminD: vitaminD,
    calcium: calcium,
    iron: iron,
  );

  double? get kilocalories => switch ((energyValue, energyUnit)) {
    (final value?, EnergyUnit.calories) => value,
    (final value?, EnergyUnit.kilojoules) =>
      value / MfpEnergy.kilojoulesPerKilocalorie,
    _ => null,
  };
}
