enum FujinTable {
  food('food'),
  foodServing('food_serving'),
  foodUnit('food_unit'),
  foodReference('food_reference'),
  barcodeLink('barcode_link'),
  meal('meal'),
  mealMapping('meal_mapping'),
  sentLink('sent_link'),
  goals('goals'),
  unattendedItem('unattended_item'),
  recentFood('recent_food');

  const FujinTable(this.sqlName);

  final String sqlName;
}
