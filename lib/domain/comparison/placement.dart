import 'package:ekklo_client/ekklo_client.dart';

typedef Placement = ({EkkloDailyMeal meal, EkkloDailyMealItem item});

Map<String, Placement> placementsOf(List<EkkloDailyMeal> meals) => {
  for (final meal in meals)
    for (final item in meal.items) item.id: (meal: meal, item: item),
};
