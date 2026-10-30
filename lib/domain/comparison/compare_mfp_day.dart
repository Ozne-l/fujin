import 'package:fujin/data/database/id_source.dart';
import 'package:fujin/data/entries/entry.dart';
import 'package:fujin/data/entries/logged_entry.dart';
import 'package:fujin/data/entries/mfp_link.dart';
import 'package:fujin/data/entries/mfp_write.dart';
import 'package:fujin/data/foods/food.dart';
import 'package:fujin/domain/comparison/day_catalog.dart';
import 'package:fujin/domain/comparison/day_draft.dart';
import 'package:fujin/domain/comparison/written_row.dart';
import 'package:fujin/domain/journal/same_day.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

DayDraft compareMfpDay(
  DayDraft day, {
  required List<MfpFoodEntry> diary,
  required Food? Function(String mfpFoodId) foodOf,
  required String? Function(String mfpMealName) mealOf,
  required DateTime now,
  required DateTime readAt,
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
    for (final logged in [...day.entries, ...day.owed])
      ?logged.mfpLink?.mfpEntryId,
  };
  final byId = [...day.entries]
    ..sort((first, second) => first.entry.id.compareTo(second.entry.id));

  bool fresh(MfpLink link) => link.updatedAt.isAfter(readAt);

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

  final adopted = <String, LoggedEntry>{};
  for (final logged in byId) {
    if ((logged.mfpLink, writtenRow(logged, diary, held)) case (
      null,
      MfpFoodEntry(id: final mfpEntryId?) && final row,
    )) {
      held.add(mfpEntryId);
      adopted[logged.entry.id] = logged.copyWith(
        mfpLink: MfpLink.of(
          row,
          id: ids(),
          entryId: logged.entry.id,
          mfpEntryId: mfpEntryId,
          updatedAt: now,
        ),
      );
    }
  }
  for (final logged in byId) {
    if ((MfpWrite.of(logged), writtenRow(logged, diary, held)) case (
      MfpEdit(),
      MfpFoodEntry(id: final mfpEntryId?),
    )) {
      held.add(mfpEntryId);
    }
  }

  final entries = <LoggedEntry>[];
  final deleted = <LoggedEntry>[];
  for (final logged in day.entries) {
    final MfpLink link;
    switch (logged.mfpLink) {
      case null:
        entries.add(adopted[logged.entry.id] ?? logged);
        continue;
      case final current
          when fresh(current) || !sameDay(current.date, logged.entry.date):
        entries.add(logged);
        continue;
      case final current:
        link = current;
    }
    switch ((
      MfpWrite.of(logged),
      inDiary[link.mfpEntryId],
      logged.ekkloLink,
    )) {
      case (MfpEdit(), final row?, _):
        entries.add(
          logged.copyWith(
            mfpLink: MfpLink.of(
              row,
              id: link.id,
              entryId: link.entryId,
              mfpEntryId: link.mfpEntryId,
              updatedAt: link.updatedAt,
            ),
          ),
        );
      case (MfpEdit(), null, _):
        entries.add(logged.copyWith(mfpLink: null));
      case (_, final row?, _):
        entries.add(updated(logged, link, row));
      case (_, null, _?):
        deleted.add(
          logged.copyWith(
            entry: logged.entry.copyWith(deletedAt: now),
            mfpLink: null,
          ),
        );
      case (_, null, null):
        continue;
    }
  }
  final owed = [
    for (final logged in day.owed)
      switch (logged.mfpLink) {
        final link?
            when !fresh(link) && !inDiary.containsKey(link.mfpEntryId) =>
          logged.copyWith(mfpLink: null),
        _ => logged,
      },
  ];
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
    owed: owed,
    unstored: [...day.unstored, ...unstored],
    foods: catalog.foods,
    meals: catalog.meals,
    plannedEntryIds: const {},
    pendingLinks: const [],
  );
}
