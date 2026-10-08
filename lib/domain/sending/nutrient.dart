enum Nutrient {
  kilocalories(null),
  protein(4),
  carbohydrates(4),
  fat(9),
  fiber(2);

  const Nutrient(this.kilocaloriesPerGram);

  final double? kilocaloriesPerGram;
}
