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
      case BackupV4(
            :final foods,
            :final foodServings,
            :final foodUnits,
            :final foodReferences,
            :final barcodeLinks,
            :final meals,
            :final mealMappings,
          ) ||
          BackupV3(
            :final foods,
            :final foodServings,
            :final foodUnits,
            :final foodReferences,
            :final barcodeLinks,
            :final meals,
            :final mealMappings,
          ):
        _foods.restore(
          foods: foods,
          servings: foodServings,
          units: foodUnits,
          references: foodReferences,
          barcodes: barcodeLinks,
        );
        _meals.restore(meals: meals, connectorMeals: mealMappings);
      case BackupV2():
        _memory.restore(backup.memory);
    }
    if (backup case BackupV4(
      :final entries,
      :final mfpLinks,
      :final ekkloLinks,
    )) {
      _entries.restore(
        entries: entries,
        mfpLinks: mfpLinks,
        ekkloLinks: ekkloLinks,
      );
    }
    recents.forEach(_recents.record);
    _links.replaceAll(backup.links);
    _goals.replace(backup.goals);
  });
}
