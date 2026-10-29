import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/foods/food_repository.dart';
import 'package:fujin/data/goals/goals_repository.dart';
import 'package:fujin/data/meals/meal_repository.dart';
import 'package:fujin/data/memory/memory_repository.dart';
import 'package:fujin/data/recents/recent_food_repository.dart';

import 'fixtures.dart';

FoodRepository foodsOf(FujinDatabase database) =>
    FoodRepository(database, () => now);

MealRepository mealsOf(FujinDatabase database) =>
    MealRepository(database, () => now);

MemoryRepository memoryOf(FujinDatabase database) => MemoryRepository(
  database: database,
  foods: foodsOf(database),
  meals: mealsOf(database),
);

RecentFoodRepository recentsOf(FujinDatabase database) =>
    RecentFoodRepository(database, foodsOf(database));

GoalsRepository goalsOf(FujinDatabase database) =>
    GoalsRepository(database, () => now);
