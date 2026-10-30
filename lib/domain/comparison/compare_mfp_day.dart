import 'package:fujin/data/database/id_source.dart';
import 'package:fujin/data/entries/entry.dart';
import 'package:fujin/data/entries/logged_entry.dart';
import 'package:fujin/data/entries/mfp_link.dart';
import 'package:fujin/data/foods/food.dart';
import 'package:fujin/domain/comparison/day_catalog.dart';
import 'package:fujin/domain/comparison/day_draft.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

DayDraft compareMfpDay(
  DayDraft day, {
  required List<MfpFoodEntry> diary,
  required Food? Function(String mfpFoodId) foodOf,
  required String? Function(String mfpMealName) mealOf,
  required DateTime now,
  required IdSource ids,
}) {
  final catalog = DayCatalog(
    foodOf: foodOf,
    mealOf: mealOf,
    ids: ids,
    foods: day.foods,
    meals: day.meals,
  );
  final pending = {for (final link in day.pendingLinks) link.entryId: link};
  final inDiary = {for (final entry in diary) ?entry.id: entry};
  final held = {
    for (final logged in day.entries) ?logged.mfpLink?.mfpEntryId,
  };

  LoggedEntry updated(LoggedEntry logged, MfpLink link, MfpFoodEntry entry) {
    final food = switch (link.foodId == entry.food.id) {
      true => null,
      false => catalog.food(
        entry.food.id,
        name: entry.food.description,
        brand: entry.food.brandName,
      ),
    };
    final values =
        Entry.copyOf(
          entry,
          id: logged.entry.id,
          mealId: switch (link.mealName == entry.mealName) {
            true => logged.entry.mealId,
            false => catalog.meal(entry.mealName),
          },
          foodId: food?.id ?? logged.entry.foodId,
          updatedAt: logged.entry.updatedAt,
        ).copyWith(
          date: logged.entry.date,
          deletedAt: logged.entry.deletedAt,
        );
    final written = MfpLink.of(
      entry,
      id: link.id,
      entryId: link.entryId,
      mfpEntryId: link.mfpEntryId,
      updatedAt: link.updatedAt,
    ).copyWith(date: link.date, deletedAt: link.deletedAt);
    return switch (values == logged.entry && written == link) {
      true => logged,
      false => logged.copyWith(
        entry: values,
        mfpLink: written,
        mealName: entry.mealName,
        mfpFoodId: entry.food.id,
        foodName: switch (food) {
          final food? => food.name,
          null => logged.foodName,
        },
        brand: switch (food) {
          final food? => food.brand,
          null => logged.brand,
        },
      ),
    };
  }

  LoggedEntry copied(MfpFoodEntry entry, {required String? entryId}) {
    final id = entryId ?? ids();
    final mealId = catalog.meal(entry.mealName);
    final food = catalog.food(
      entry.food.id,
      name: entry.food.description,
      brand: entry.food.brandName,
    );
    return LoggedEntry(
      entry: Entry.copyOf(
        entry,
        id: id,
        mealId: mealId,
        foodId: food.id,
        updatedAt: now,
      ),
      mealName: entry.mealName,
      foodName: food.name,
      brand: food.brand,
      mfpFoodId: entry.food.id,
    );
  }

  final entries = <LoggedEntry>[];
  final deleted = <LoggedEntry>[];
  for (final logged in day.entries) {
    switch ((
      logged.mfpLink,
      inDiary[logged.mfpLink?.mfpEntryId],
      logged.ekkloLink,
    )) {
      case (null, _, _):
        entries.add(logged);
      case (final link?, final entry?, _):
        entries.add(updated(logged, link, entry));
      case (_?, null, _?):
        deleted.add(
          logged.copyWith(
            entry: logged.entry.copyWith(deletedAt: now),
            mfpLink: null,
          ),
        );
      case (_?, null, null):
        continue;
    }
  }
  final unstored = <LoggedEntry>[];
  for (final entry in diary) {
    switch (entry.id) {
      case final mfpEntryId? when !held.contains(mfpEntryId):
        final logged = copied(
          entry,
          entryId: day.plannedEntryIds[mfpEntryId],
        );
        entries.add(
          logged.copyWith(
            mfpLink: MfpLink.of(
              entry,
              id: ids(),
              entryId: logged.entry.id,
              mfpEntryId: mfpEntryId,
              updatedAt: now,
            ),
            ekkloLink: pending[logged.entry.id],
          ),
        );
      case _?:
        continue;
      case null:
        unstored.add(copied(entry, entryId: null));
    }
  }

  return day.copyWith(
    entries: entries,
    deleted: [...day.deleted, ...deleted],
    unstored: [...day.unstored, ...unstored],
    foods: catalog.foods,
    meals: catalog.meals,
    plannedEntryIds: const {},
    pendingLinks: const [],
  );
}
