import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/database/fujin_id.dart';
import 'package:fujin/data/entries/entry.dart';
import 'package:fujin/data/entries/entry_repository.dart';
import 'package:fujin/data/entries/mfp_link.dart';
import 'package:fujin/data/foods/food_repository.dart';
import 'package:fujin/data/goals/goals_repository.dart';
import 'package:fujin/data/links/sent_link_repository.dart';
import 'package:fujin/data/meals/meal_repository.dart';
import 'package:fujin/data/memory/memory_repository.dart';
import 'package:fujin/data/recents/recent_food_repository.dart';
import 'package:fujin/data/unattended/unattended_item_repository.dart';
import 'package:fujin/domain/journal/journal_service.dart';
import 'package:fujin/domain/sending/send_service.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

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

EntryRepository entriesOf(FujinDatabase database) =>
    EntryRepository(database, () => now);

String storeEntry(FujinDatabase database, MfpFoodEntry entry, String id) {
  final foodId = foodsOf(database).copiedMfpFood(
    entry.food.id,
    id: FujinId.at(now),
    name: entry.food.description,
    brand: entry.food.brandName,
  );
  final mealId = mealsOf(
    database,
  ).mfpMeal(entry.mealName, id: FujinId.at(now));
  entriesOf(database).save(
    Entry.copyOf(entry, id: id, mealId: mealId, foodId: foodId, updatedAt: now),
    MfpLink.of(
      entry,
      id: FujinId.at(now),
      entryId: id,
      mfpEntryId: entry.id ?? id,
      updatedAt: now,
    ),
  );
  return id;
}

JournalService journalOver(
  FujinDatabase database, {
  required MyFitnessPalClient mfp,
  required EkkloClient ekklo,
}) => JournalService(
  mfp: mfp,
  ekklo: ekklo,
  entries: entriesOf(database),
  links: SentLinkRepository(database),
  unattended: UnattendedItemRepository(database),
  memory: memoryOf(database),
  foods: foodsOf(database),
  meals: mealsOf(database),
  database: database,
  clock: () => now,
);

SendService sendingOver(
  FujinDatabase database, {
  required JournalService journal,
  required EkkloClient ekklo,
}) => SendService(
  journal: journal,
  ekklo: ekklo,
  memory: memoryOf(database),
  entries: entriesOf(database),
  database: database,
  clock: () => now,
);
