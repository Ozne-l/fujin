import 'package:fujin/data/goals/goals.dart';
import 'package:fujin/domain/sending/nutrient.dart';

extension GoalAmounts on Goals {
  double? amount(Nutrient nutrient) => switch (nutrient) {
    Nutrient.kilocalories => kilocalories,
    Nutrient.protein => protein,
    Nutrient.carbohydrates => carbohydrates,
    Nutrient.fat => fat,
    Nutrient.fiber => fiber,
  };

  static Goals? from(double? Function(Nutrient nutrient) amountOf) =>
      switch (amountOf(Nutrient.kilocalories)) {
        final kilocalories? => Goals(
          kilocalories: kilocalories,
          protein: amountOf(Nutrient.protein),
          carbohydrates: amountOf(Nutrient.carbohydrates),
          fat: amountOf(Nutrient.fat),
          fiber: amountOf(Nutrient.fiber),
        ),
        null => null,
      };
}
