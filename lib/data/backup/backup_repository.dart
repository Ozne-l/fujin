import 'package:fujin/data/backup/backup.dart';
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/database/fujin_table.dart';
import 'package:fujin/data/entries/entry_repository.dart';
import 'package:fujin/data/foods/food_repository.dart';
import 'package:fujin/data/goals/goals_repository.dart';
import 'package:fujin/data/links/sent_link_repository.dart';
import 'package:fujin/data/meals/meal_repository.dart';
import 'package:fujin/data/memory/memory_repository.dart';
import 'package:fujin/data/recents/recent_food_repository.dart';
import 'package:fujin/data/weigh_ins/weigh_in_repository.dart';

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
    required this._weighIns,
  });

  final FujinDatabase<FujinTable> _database;
  final FoodRepository _foods;
  final MealRepository _meals;
  final EntryRepository _entries;
  final MemoryRepository _memory;
  final RecentFoodRepository _recents;
  final SentLinkRepository _links;
  final GoalsRepository _goals;
  final WeighInRepository _weighIns;

  BackupV6 snapshot(DateTime exportedAt) => BackupV6(
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
    weighIns: _weighIns.weighIns(),
    ekkloWeighInLinks: _weighIns.ekkloLinks(),
    mfpWeighInLinks: _weighIns.mfpLinks(),
    links: _links.all(),
    goalPeriods: _goals.periods(),
  );

  void restore(Backup backup) => _database.transaction(() {
    final recents = _recents.latest();
    _foods.deleteAll();
    _meals.deleteAll();
    switch (backup) {
      case BackupV6(
            :final foods,
            :final foodServings,
            :final foodUnits,
            :final foodReferences,
            :final barcodeLinks,
            :final meals,
            :final mealMappings,
          ) ||
          BackupV5(
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
    if (backup
        case BackupV6(
              :final entries,
              :final mfpLinks,
              :final ekkloLinks,
            ) ||
            BackupV5(:final entries, :final mfpLinks, :final ekkloLinks)) {
      _entries.restore(
        entries: entries,
        mfpLinks: mfpLinks,
        ekkloLinks: ekkloLinks,
      );
    }
    if (backup case BackupV6(
      :final weighIns,
      :final ekkloWeighInLinks,
      :final mfpWeighInLinks,
    )) {
      _weighIns.replaceAll(
        weighIns: weighIns,
        ekkloLinks: ekkloWeighInLinks,
        mfpLinks: mfpWeighInLinks,
      );
    }
    recents.forEach(_recents.record);
    _links.replaceAll(backup.links);
    _goals.replaceAll(backup.goalPeriods);
  });
}
