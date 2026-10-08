import 'dart:math';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/domain/sending/nutrient.dart';

part 'nutrient_deltas.mapper.dart';

@MappableClass()
final class NutrientDeltas with NutrientDeltasMappable {
  const NutrientDeltas({
    required this.entryKilocalories,
    required this.kilocalories,
    this.protein,
    this.carbohydrates,
    this.fat,
    this.fiber,
  });

  static const kilocalorieTolerance = 0.12;
  static const macroTolerance = 0.10;
  static const macroFloorKilocalories = 5.0;

  final double entryKilocalories;
  final double kilocalories;
  final double? protein;
  final double? carbohydrates;
  final double? fat;
  final double? fiber;

  double? of(Nutrient nutrient) => switch (nutrient) {
    Nutrient.kilocalories => kilocalories,
    Nutrient.protein => protein,
    Nutrient.carbohydrates => carbohydrates,
    Nutrient.fat => fat,
    Nutrient.fiber => fiber,
  };

  bool fits(Nutrient nutrient) => switch ((nutrient, of(nutrient))) {
    (_, null) => true,
    (Nutrient.kilocalories, final delta?) =>
      delta.abs() <= kilocalorieTolerance,
    (_, final delta?) =>
      delta.abs() <=
          max(macroTolerance, macroFloorKilocalories / entryKilocalories),
  };

  bool get withinTolerance => Nutrient.values.every(fits);

  double get total => Nutrient.values.fold(
    0,
    (sum, nutrient) => sum + (of(nutrient)?.abs() ?? 0),
  );
}
