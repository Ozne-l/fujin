import 'package:fujin/domain/sending/nutrient.dart';

enum GoalStatus {
  below,
  reached,
  exceeded;

  static const tolerance = 0.02;

  static GoalStatus of(
    Nutrient nutrient, {
    required double amount,
    required double goal,
  }) => switch ((amount / goal, nutrient)) {
    (final share, _) when share < 1 - tolerance => below,
    (final share, _) when share <= 1 + tolerance => reached,
    (_, Nutrient.fiber) => reached,
    (
      _,
      Nutrient.kilocalories ||
          Nutrient.protein ||
          Nutrient.carbohydrates ||
          Nutrient.fat,
    ) =>
      exceeded,
  };
}
