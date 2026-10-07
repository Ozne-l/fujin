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
}) => MfpFoodEntry(
  id: id,
  date: day,
  mealName: meal,
  mealPosition: 0,
  servings: servings,
  servingSize: MfpServingSize(value: servingValue, unit: unit),
  food: MfpEntryFood(id: food, description: food),
  nutrients: const MfpNutrients(),
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
  foods: [
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
