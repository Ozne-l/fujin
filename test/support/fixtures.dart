import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/data/links/sent_link.dart';
import 'package:fujin/data/memory/meal_mapping.dart';
import 'package:fujin/data/memory/memory.dart';
import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/data/memory/remembered_unit.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

final day = DateTime.utc(2026, 10, 7);
final now = DateTime.utc(2026, 10, 7, 20);

const breakfast = 'Breakfast';
const lunch = 'Lunch';
const petitDejeuner = 'Petit-déjeuner';
const dejeuner = 'Déjeuner';

const oats = 'mfp-oats';
const rice = 'mfp-rice';
const oatsInEkklo = 'ekklo-oats';
const riceInEkklo = 'ekklo-rice';

const grams = 'g';
const cup = 'cup';

MfpFoodEntry entry(
  String? id, {
  String food = oats,
  String meal = breakfast,
  double servings = 1,
  double servingValue = 100,
  String unit = grams,
  String? description,
  String? brand,
  String? version,
  MfpNutrients nutrients = const MfpNutrients(),
  DateTime? date,
}) => MfpFoodEntry(
  id: id,
  date: date ?? day,
  mealName: meal,
  mealPosition: 0,
  servings: servings,
  servingSize: MfpServingSize(value: servingValue, unit: unit),
  food: MfpEntryFood(
    id: food,
    description: description ?? food,
    brandName: brand,
    version: version,
  ),
  nutrients: nutrients,
);

MfpNutrients nutrients({
  required double kcal,
  double? protein,
  double? carbs,
  double? fat,
  double? fiber,
}) => MfpNutrients(
  energy: MfpEnergy(unit: MfpEnergyUnit.calories, value: kcal),
  protein: protein,
  carbohydrates: carbs,
  fat: fat,
  fiber: fiber,
);

EkkloFood ekkloFood(
  String id, {
  String? name,
  String? brands,
  double calories = 100,
  double proteins = 0,
  double carbs = 0,
  double fats = 0,
  double fiber = 0,
  double portion = 100,
  EkkloQuantityType quantityType = EkkloQuantityType.grams,
}) => EkkloFood(
  id: id,
  name: name ?? id,
  brands: brands,
  portion: portion,
  quantityType: quantityType,
  calories: calories,
  proteins: proteins,
  carbs: carbs,
  fats: fats,
  fiber: fiber,
  sugar: 0,
  sodiumMilligrams: 0,
  category: EkkloFoodCategory.other,
);

EkkloDailyMealItem item(
  String id, {
  String food = oatsInEkklo,
  double quantity = 100,
  EkkloQuantityType type = EkkloQuantityType.grams,
}) => EkkloDailyMealItem(
  id: id,
  itemType: EkkloMealItemType.food,
  quantity: quantity,
  quantityType: type,
  foodId: food,
);

EkkloDailyMeal meal(
  String id,
  List<EkkloDailyMealItem> items, {
  String name = petitDejeuner,
}) => EkkloDailyMeal(
  id: id,
  date: day,
  name: name,
  revision: 1,
  items: items,
);

SentLink link(
  String entryId,
  String itemId, {
  String food = oats,
  String meal = breakfast,
  String ekkloMeal = 'meal-1',
  double servings = 1,
  double servingValue = 100,
  String unit = grams,
}) => SentLink(
  mfpEntryId: entryId,
  date: day,
  mfpFoodId: food,
  mfpMealName: meal,
  mfpServings: servings,
  mfpServingValue: servingValue,
  mfpServingUnit: unit,
  ekkloMealId: ekkloMeal,
  ekkloItemId: itemId,
  sentAt: DateTime.utc(2026, 10, 7, 9),
);

const memory = Memory(
  matches: [
    MatchedFood(
      mfpFoodId: oats,
      mfpDescription: oats,
      ekkloFoodId: oatsInEkklo,
      ekkloFoodName: oatsInEkklo,
    ),
    MatchedFood(
      mfpFoodId: rice,
      mfpDescription: rice,
      ekkloFoodId: riceInEkklo,
      ekkloFoodName: riceInEkklo,
    ),
  ],
  units: [RememberedUnit(mfpFoodId: rice, mfpUnit: cup, grams: 180)],
  meals: [
    MealMapping(mfpMealName: breakfast, ekkloMealName: petitDejeuner),
    MealMapping(mfpMealName: lunch, ekkloMealName: dejeuner),
  ],
);

const skyr = 'mfp-skyr';
const oil = 'mfp-oil';
const tablespoon = 'c. à soupe';
const teaspoon = 'teaspoon';
const pot = 'pot';
const bowl = 'bowl';
const snacks = 'Collations';

final MfpFoodEntry skyrEntry = entry(
  'E-1',
  food: skyr,
  description: 'Skyr nature',
  brand: 'Isey',
  servingValue: 250,
  nutrients: nutrients(kcal: 160, protein: 25, carbs: 10, fat: 0.5),
);

final EkkloFood isey = ekkloFood(
  'isey',
  name: 'Skyr nature 0 %',
  brands: 'Isey',
  calories: 62,
  proteins: 10.4,
  carbs: 3.8,
  fats: 0.2,
);
final EkkloFood siggis = ekkloFood(
  'siggis',
  name: 'Skyr',
  brands: "Siggi's",
  calories: 80,
  proteins: 10,
  carbs: 4,
  fats: 0.2,
);
final EkkloFood fromageBlanc = ekkloFood(
  'fromage-blanc',
  name: 'Fromage blanc 0 %',
  brands: 'Danone',
  calories: 64,
  proteins: 10,
  carbs: 4,
  fats: 0.2,
);

final MfpFoodEntry oilEntry = entry(
  'E-2',
  food: oil,
  description: "Huile d'olive vierge extra",
  unit: tablespoon,
  servingValue: 1,
  nutrients: nutrients(kcal: 119, fat: 13.5),
);
final EkkloFood oliveOil = ekkloFood(
  'olive-oil',
  name: "Huile d'olive vierge extra",
  calories: 884,
  fats: 100,
);
