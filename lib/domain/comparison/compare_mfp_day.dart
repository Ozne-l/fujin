import 'package:fujin/data/connectors/role.dart';
import 'package:fujin/data/database/id_source.dart';
import 'package:fujin/data/entries/entry.dart';
import 'package:fujin/data/entries/logged_entry.dart';
import 'package:fujin/data/entries/mfp_link.dart';
import 'package:fujin/data/entries/mfp_write.dart';
import 'package:fujin/data/foods/food.dart';
import 'package:fujin/domain/comparison/day_catalog.dart';
import 'package:fujin/domain/comparison/day_draft.dart';
import 'package:fujin/domain/comparison/replacement.dart';
import 'package:fujin/domain/comparison/replacing_row.dart';
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
  required Role role,
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
  int byEntryId(LoggedEntry first, LoggedEntry second) =>
      first.entry.id.compareTo(second.entry.id);

  final byId = [...day.entries]..sort(byEntryId);

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
  final editCopies = <String, MfpFoodEntry>{};
  for (final logged in byId) {
    if ((MfpWrite.of(logged), writtenRow(logged, diary, held)) case (
      MfpEdit(),
      MfpFoodEntry(id: final mfpEntryId?) && final row,
    )) {
      held.add(mfpEntryId);
      editCopies[logged.entry.id] = row;
    }
  }

  bool gone(MfpLink link) =>
      !fresh(link) && !inDiary.containsKey(link.mfpEntryId);
  bool keepsFujin(LoggedEntry logged) =>
      !role.copiesIn || MfpWrite.of(logged) is MfpEdit;
  final owedById = [...day.owed]..sort(byEntryId);
  final editsGone = [
    for (final logged in byId)
      if (logged.mfpLink case final link?
          when keepsFujin(logged) &&
              gone(link) &&
              sameDay(link.date, logged.entry.date))
        logged,
    for (final logged in owedById)
      if (MfpWrite.of(logged) case MfpEdit(:final link) when gone(link)) logged,
  ]..sort(byEntryId);
  final deletionsGone = [
    for (final logged in owedById)
      if (MfpWrite.of(logged) case MfpDeletion(:final link) when gone(link))
        logged,
  ];
  MfpLink movedTo(MfpLink link, MfpFoodEntry row, String mfpEntryId) =>
      MfpLink.of(
        row,
        id: link.id,
        entryId: link.entryId,
        mfpEntryId: mfpEntryId,
        updatedAt: link.updatedAt,
      );
  final moved = <String, MfpLink>{
    for (final logged in editsGone)
      if ((logged.mfpLink, editCopies[logged.entry.id]) case (
        final link?,
        MfpFoodEntry(id: final mfpEntryId?) && final row,
      ))
        logged.entry.id: movedTo(link, row, mfpEntryId),
  };
  for (final candidates in [editsGone, deletionsGone]) {
    for (final sameMeal in const [true, false]) {
      for (final logged in candidates) {
        final link = logged.mfpLink;
        if (link == null || moved.containsKey(logged.entry.id)) {
          continue;
        }
        final row = replacingRow(
          link,
          mfpFoodId: logged.mfpFoodId,
          diary: diary,
          held: held,
          sameMeal: sameMeal,
        );
        if (row case MfpFoodEntry(id: final mfpEntryId?)) {
          held.add(mfpEntryId);
          moved[logged.entry.id] = movedTo(link, row, mfpEntryId);
        }
      }
    }
  }

  final replaced = <Replacement>[];
  void replacedEdit(LoggedEntry logged, MfpLink before) {
    if (MfpWrite.of(logged) case MfpEdit()) {
      replaced.add(ReplacedEdit(logged, before: before));
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
    switch ((keepsFujin(logged), inDiary[link.mfpEntryId], logged.ekkloLink)) {
      case (true, final row?, _):
        final refreshed = MfpLink.of(
          row,
          id: link.id,
          entryId: link.entryId,
          mfpEntryId: link.mfpEntryId,
          updatedAt: link.updatedAt,
        );
        final kept = logged.copyWith(mfpLink: refreshed);
        entries.add(kept);
        if (!_sameWrite(refreshed, link)) {
          replacedEdit(kept, refreshed);
        }
      case (true, null, _):
        switch (moved[logged.entry.id]) {
          case final link?:
            final kept = logged.copyWith(mfpLink: link);
            entries.add(kept);
            replacedEdit(kept, link);
          case null:
            entries.add(logged.copyWith(mfpLink: null));
        }
      case (false, final row?, _):
        entries.add(updated(logged, link, row));
      case (false, null, _?):
        deleted.add(
          logged.copyWith(
            entry: logged.entry.copyWith(deletedAt: now),
            mfpLink: null,
          ),
        );
      case (false, null, null):
        continue;
    }
  }
  final owed = <LoggedEntry>[];
  for (final logged in day.owed) {
    switch ((logged.mfpLink, moved[logged.entry.id])) {
      case (_, final link?):
        final kept = logged.copyWith(mfpLink: link);
        owed.add(kept);
        switch (MfpWrite.of(logged)) {
          case MfpDeletion():
            replaced.add(ReplacedDeletion(kept));
          case MfpEdit():
            replacedEdit(kept, link);
          case MfpAdd() || null:
            continue;
        }
      case (final link?, null) when gone(link):
        owed.add(logged.copyWith(mfpLink: null));
      case _:
        owed.add(logged);
    }
  }
  final unstored = <LoggedEntry>[];
  for (final entry in [if (role.copiesIn) ...diary]) {
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
            ekkloLink: pending.remove(logged.entry.id),
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
    pendingLinks: [...pending.values],
    replaced: [...day.replaced, ...replaced],
  );
}

bool _sameWrite(MfpLink first, MfpLink second) =>
    sameDay(first.date, second.date) &&
    first.mealName == second.mealName &&
    first.foodId == second.foodId &&
    first.servings == second.servings &&
    first.servingValue == second.servingValue &&
    first.servingUnit == second.servingUnit;
