import 'package:fujin/data/connectors/role.dart';
import 'package:fujin/data/database/id_source.dart';
import 'package:fujin/data/entries/ekklo_link.dart';
import 'package:fujin/data/entries/entry.dart';
import 'package:fujin/data/entries/linked_item.dart';
import 'package:fujin/data/entries/logged_entry.dart';
import 'package:fujin/data/entries/unattended_expectation.dart';
import 'package:fujin/data/foods/food.dart';
import 'package:fujin/data/links/sent_link.dart';
import 'package:fujin/data/unattended/unattended_item.dart';
import 'package:fujin/domain/comparison/day_catalog.dart';
import 'package:fujin/domain/comparison/day_draft.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

sealed class _Holder {
  const _Holder();
}

final class _Stored extends _Holder {
  const _Stored(this.index);

  final int index;
}

final class _Planned extends _Holder {
  const _Planned(this.entryId);

  final String entryId;
}

final class _Orphan extends _Holder {
  const _Orphan(this.index);

  final int index;
}

DayDraft adoptWaiting(
  DayDraft day, {
  required List<MfpFoodEntry> diary,
  required List<SentLink> links,
  required List<UnattendedItem> unattended,
  required Food? Function(String mfpFoodId) foodOf,
  required String? Function(String mfpMealName) mealOf,
  required DateTime now,
  required IdSource ids,
  required Role role,
}) {
  if (links.isEmpty && unattended.isEmpty) return day;
  final copiesIn = switch (role) {
    Role.twoWay => true,
    Role.receiveOnly => false,
  };
  final catalog = DayCatalog(
    foodOf: foodOf,
    mealOf: mealOf,
    ids: ids,
    foods: day.foods,
    meals: day.meals,
  );
  final entries = [...day.entries];
  final orphans = <LoggedEntry>[];
  final pending = {for (final link in day.pendingLinks) link.entryId: link};
  final storedIndex = {
    for (final (index, logged) in entries.indexed)
      if (logged.mfpLink case final link?) link.mfpEntryId: index,
  };
  final unheld = {
    for (final entry in diary)
      if (entry.id case final id? when !storedIndex.containsKey(id)) id,
  };
  final planned = {
    for (final id in [if (copiesIn) ...unheld])
      id: day.plannedEntryIds[id] ?? ids(),
  };
  final ignored = switch (copiesIn) {
    true => const <String>{},
    false => unheld,
  };
  final orphanIndex = <String, int>{};
  final linkedItems = {
    for (final logged in [...entries, ...day.deleted])
      if (logged.ekkloLink?.item case final item?) item.ekkloItemId,
    for (final link in pending.values)
      if (link.item case final item?) item.ekkloItemId,
  };

  _Holder? holderOf(String mfpEntryId) => switch ((
    storedIndex[mfpEntryId],
    planned[mfpEntryId],
    orphanIndex[mfpEntryId],
  )) {
    (final index?, _, _) => _Stored(index),
    (null, final entryId?, _) => _Planned(entryId),
    (null, null, final index?) => _Orphan(index),
    (null, null, null) => null,
  };

  LinkedItem itemOf(SentLink link) => LinkedItem(
    ekkloMealId: link.ekkloMealId,
    ekkloItemId: link.ekkloItemId,
    mealId: catalog.meal(link.mfpMealName),
    foodId: catalog.food(link.mfpFoodId).id,
    servings: link.mfpServings,
    servingValue: link.mfpServingValue,
    servingUnit: link.mfpServingUnit,
    sentAt: link.sentAt,
  );

  EkkloLink newLink(
    String entryId, {
    LinkedItem? item,
    UnattendedExpectation? unattended,
  }) => EkkloLink(
    id: ids(),
    entryId: entryId,
    item: item,
    unattended: unattended,
    updatedAt: now,
  );

  LoggedEntry orphanOf(SentLink link) {
    final food = catalog.food(link.mfpFoodId);
    final entry = Entry(
      id: ids(),
      date: link.date,
      mealId: catalog.meal(link.mfpMealName),
      foodId: food.id,
      servingValue: link.mfpServingValue,
      servingUnit: link.mfpServingUnit,
      servings: link.mfpServings,
      updatedAt: now,
      deletedAt: now,
    );
    return LoggedEntry(
      entry: entry,
      mealName: link.mfpMealName,
      foodName: food.name,
      brand: food.brand,
      mfpFoodId: link.mfpFoodId,
      ekkloLink: newLink(entry.id, item: itemOf(link)),
    );
  }

  final keepsWaiting = [
    for (final link in links) link.mfpEntryId,
    for (final item in unattended) item.mfpEntryId,
  ].any(ignored.contains);
  for (final link in links) {
    if (linkedItems.contains(link.ekkloItemId) ||
        ignored.contains(link.mfpEntryId)) {
      continue;
    }
    switch (holderOf(link.mfpEntryId)) {
      case _Stored(:final index) when entries[index].ekkloLink == null:
        final logged = entries[index];
        entries[index] = logged.copyWith(
          ekkloLink: newLink(logged.entry.id, item: itemOf(link)),
        );
      case _Planned(:final entryId) when !pending.containsKey(entryId):
        pending[entryId] = newLink(entryId, item: itemOf(link));
      case null:
        orphanIndex[link.mfpEntryId] = orphans.length;
        orphans.add(orphanOf(link));
      case _Stored() || _Planned() || _Orphan():
        continue;
    }
    linkedItems.add(link.ekkloItemId);
  }

  final waitingEntryIds = {
    for (final entry in diary) ?entry.id,
    for (final link in links) link.mfpEntryId,
  };
  for (final item in unattended) {
    if (!waitingEntryIds.contains(item.mfpEntryId) ||
        ignored.contains(item.mfpEntryId)) {
      continue;
    }
    final expectation = UnattendedExpectation(
      ekkloMealName: item.ekkloMealName,
      ekkloFoodId: item.ekkloFoodId,
      quantity: item.quantity,
      quantityType: item.quantityType,
    );
    EkkloLink expecting(String entryId, EkkloLink? current) =>
        switch (current) {
          final link? when link.unattended == null => link.copyWith(
            unattended: expectation,
          ),
          final link? => link,
          null => newLink(entryId, unattended: expectation),
        };
    switch (holderOf(item.mfpEntryId)) {
      case _Stored(:final index):
        final logged = entries[index];
        entries[index] = logged.copyWith(
          ekkloLink: expecting(logged.entry.id, logged.ekkloLink),
        );
      case _Planned(:final entryId):
        pending[entryId] = expecting(entryId, pending[entryId]);
      case _Orphan(:final index):
        final logged = orphans[index];
        orphans[index] = logged.copyWith(
          ekkloLink: expecting(logged.entry.id, logged.ekkloLink),
        );
      case null:
        continue;
    }
  }

  return day.copyWith(
    entries: entries,
    deleted: [...day.deleted, ...orphans],
    foods: catalog.foods,
    meals: catalog.meals,
    plannedEntryIds: planned,
    pendingLinks: [...pending.values],
    forgetsWaiting: !keepsWaiting,
  );
}
