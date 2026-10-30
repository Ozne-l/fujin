import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/data/database/id_source.dart';
import 'package:fujin/data/entries/ekklo_link.dart';
import 'package:fujin/data/entries/entry.dart';
import 'package:fujin/data/entries/linked_item.dart';
import 'package:fujin/data/entries/logged_entry.dart';
import 'package:fujin/data/entries/mfp_link.dart';
import 'package:fujin/data/entries/unattended_expectation.dart';
import 'package:fujin/data/foods/food.dart';
import 'package:fujin/data/links/sent_link.dart';
import 'package:fujin/data/memory/meal_mapping.dart';
import 'package:fujin/data/memory/memory.dart';
import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/data/memory/remembered_unit.dart';
import 'package:fujin/data/unattended/unattended_item.dart';
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

UnattendedItem unattendedItem(
  String entryId, {
  String food = oatsInEkklo,
  String ekkloMeal = petitDejeuner,
  double quantity = 100,
  EkkloQuantityType type = EkkloQuantityType.grams,
}) => UnattendedItem(
  mfpEntryId: entryId,
  date: day,
  ekkloMealName: ekkloMeal,
  ekkloFoodId: food,
  quantity: quantity,
  quantityType: type,
);

Entry entryRow(
  String id, {
  required String foodId,
  required String mealId,
  double servings = 1,
  double servingValue = 100,
  String unit = grams,
  DateTime? date,
}) => Entry(
  id: id,
  date: date ?? day,
  mealId: mealId,
  foodId: foodId,
  servingValue: servingValue,
  servingUnit: unit,
  servings: servings,
  updatedAt: now,
);

MfpLink mfpLinkRow(
  String id, {
  required String entryId,
  required String mfpEntryId,
  String food = oats,
  String meal = breakfast,
  double servings = 1,
  double servingValue = 100,
  String unit = grams,
}) => MfpLink(
  id: id,
  entryId: entryId,
  mfpEntryId: mfpEntryId,
  date: day,
  mealName: meal,
  foodId: food,
  servings: servings,
  servingValue: servingValue,
  servingUnit: unit,
  updatedAt: now,
);

EkkloLink ekkloLinkRow(
  String id, {
  required String entryId,
  LinkedItem? item,
  UnattendedExpectation? unattended,
}) => EkkloLink(
  id: id,
  entryId: entryId,
  item: item,
  unattended: unattended,
  updatedAt: now,
);

LinkedItem linkedItem(
  String itemId, {
  required String mealId,
  required String foodId,
  String ekkloMeal = 'meal-1',
  double servings = 1,
  double servingValue = 100,
  String unit = grams,
}) => LinkedItem(
  ekkloMealId: ekkloMeal,
  ekkloItemId: itemId,
  mealId: mealId,
  foodId: foodId,
  servings: servings,
  servingValue: servingValue,
  servingUnit: unit,
  sentAt: DateTime.utc(2026, 10, 7, 9),
);

UnattendedExpectation expectation({
  String food = oatsInEkklo,
  String ekkloMeal = petitDejeuner,
  double quantity = 100,
  EkkloQuantityType type = EkkloQuantityType.grams,
}) => UnattendedExpectation(
  ekkloMealName: ekkloMeal,
  ekkloFoodId: food,
  quantity: quantity,
  quantityType: type,
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

MfpFood mfpFood(
  String id, {
  String? description,
  String? brand,
  String version = '1',
  bool verified = true,
  List<MfpServingSize> servingSizes = const [
    MfpServingSize(value: 100, unit: grams, nutritionMultiplier: 1),
  ],
  MfpNutrients nutrients = const MfpNutrients(),
}) => MfpFood(
  id: id,
  version: version,
  description: description ?? id,
  brandName: brand,
  verified: verified,
  servingSizes: servingSizes,
  nutrients: nutrients,
);

LoggedEntry loggedEntry(MfpFoodEntry entry) {
  final id = entry.id ?? 'entry';
  return LoggedEntry(
    entry: Entry.copyOf(
      entry,
      id: id,
      mealId: fujinMealId(entry.mealName),
      foodId: fujinFoodId(entry.food.id),
      updatedAt: now,
    ),
    mealName: entry.mealName,
    foodName: entry.food.description,
    brand: entry.food.brandName,
    mfpFoodId: entry.food.id,
    mfpLink: MfpLink.of(
      entry,
      id: 'mfp-link-$id',
      entryId: id,
      mfpEntryId: id,
      updatedAt: now,
    ),
  );
}

String fujinFoodId(String mfpFoodId) => 'food-$mfpFoodId';

String fujinMealId(String mfpMealName) => 'meal-$mfpMealName';

Food? knownFood(String mfpFoodId) => switch (mfpFoodId) {
  oats || rice => Food(
    id: fujinFoodId(mfpFoodId),
    name: mfpFoodId,
    updatedAt: now,
  ),
  _ => null,
};

String? knownMeal(String mfpMealName) => switch (mfpMealName) {
  breakfast || lunch => fujinMealId(mfpMealName),
  _ => null,
};

IdSource idsFrom(String prefix) {
  var next = 0;
  return () => '$prefix-${++next}';
}

LinkedItem sentItem(
  String itemId, {
  String food = oats,
  String meal = breakfast,
  String ekkloMeal = 'meal-1',
  double servings = 1,
  double servingValue = 100,
  String unit = grams,
}) => linkedItem(
  itemId,
  mealId: fujinMealId(meal),
  foodId: fujinFoodId(food),
  ekkloMeal: ekkloMeal,
  servings: servings,
  servingValue: servingValue,
  unit: unit,
);
