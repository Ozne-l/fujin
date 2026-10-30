import 'package:fujin/data/backup/backup.dart';
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/entries/entry_repository.dart';
import 'package:fujin/data/foods/food_repository.dart';
import 'package:fujin/data/goals/goals_repository.dart';
import 'package:fujin/data/links/sent_link_repository.dart';
import 'package:fujin/data/meals/meal_repository.dart';
import 'package:fujin/data/memory/memory_repository.dart';
import 'package:fujin/data/recents/recent_food_repository.dart';

final class BackupRepository {
  const BackupRepository({
    required this._database,
    required this._foods,
    required this._meals,
    required this._entries,
    required this._memory,
    required this._recents,
    required this._links,
    required this._goals,
  });

  final FujinDatabase _database;
  final FoodRepository _foods;
  final MealRepository _meals;
  final EntryRepository _entries;
  final MemoryRepository _memory;
  final RecentFoodRepository _recents;
  final SentLinkRepository _links;
  final GoalsRepository _goals;

  BackupV4 snapshot(DateTime exportedAt) => BackupV4(
    exportedAt: exportedAt,
    foods: _foods.foods(),
    foodServings: _foods.servings(),
    foodUnits: _foods.units(),
    foodReferences: _foods.references(),
    barcodeLinks: _foods.barcodes(),
    meals: _meals.meals(),
    mealMappings: _meals.connectorMeals(),
    entries: _entries.entries(),
    mfpLinks: _entries.mfpLinks(),
    ekkloLinks: _entries.ekkloLinks(),
    links: _links.all(),
    goals: _goals.load(),
  );

  void restore(Backup backup) => _database.transaction(() {
    final recents = _recents.latest();
    _foods.deleteAll();
    _meals.deleteAll();
    switch (backup) {
      case BackupV4():
        _foods.restore(
          foods: backup.foods,
          servings: backup.foodServings,
          units: backup.foodUnits,
          references: backup.foodReferences,
          barcodes: backup.barcodeLinks,
        );
        _meals.restore(
          meals: backup.meals,
          connectorMeals: backup.mealMappings,
        );
        _entries.restore(
          entries: backup.entries,
          mfpLinks: backup.mfpLinks,
          ekkloLinks: backup.ekkloLinks,
        );
        recents.forEach(_recents.record);
      case BackupV3():
        _foods.restore(
          foods: backup.foods,
          servings: backup.foodServings,
          units: backup.foodUnits,
          references: backup.foodReferences,
          barcodes: backup.barcodeLinks,
        );
        _meals.restore(
          meals: backup.meals,
          connectorMeals: backup.mealMappings,
        );
        recents.forEach(_recents.record);
      case BackupV2():
        _memory.restore(backup.memory);
        recents.forEach(_recents.record);
    }
    _links.replaceAll(backup.links);
    _goals.replace(backup.goals);
  });
}
