enum FujinTable {
  food('food'),
  foodServing('food_serving'),
  foodUnit('food_unit'),
  foodReference('food_reference'),
  barcodeLink('barcode_link'),
  meal('meal'),
  mealMapping('meal_mapping'),
  entry('entry'),
  mfpLink('mfp_link'),
  ekkloLink('ekklo_link'),
  sentLink('sent_link'),
  goals('goals'),
  unattendedItem('unattended_item'),
  recentFood('recent_food');

  const FujinTable(this.sqlName);

  final String sqlName;
}
