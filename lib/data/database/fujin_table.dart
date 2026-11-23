import 'package:fujin/data/database/database_table.dart';

enum FujinTable implements DatabaseTable {
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
  recentFood('recent_food'),
  weighIn('weigh_in'),
  ekkloWeighInLink('ekklo_weigh_in_link'),
  mfpWeighInLink('mfp_weigh_in_link');

  const FujinTable(this.sqlName);

  @override
  final String sqlName;
}
