import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/data/database/id_source.dart';
import 'package:fujin/data/entries/ekklo_link.dart';
import 'package:fujin/data/entries/linked_item.dart';
import 'package:fujin/data/entries/logged_entry.dart';
import 'package:fujin/data/entries/mfp_write.dart';
import 'package:fujin/data/memory/memory.dart';
import 'package:fujin/domain/comparison/compared_entry.dart';
import 'package:fujin/domain/comparison/day_comparison.dart';
import 'package:fujin/domain/comparison/day_draft.dart';
import 'package:fujin/domain/comparison/entry_status.dart';
import 'package:fujin/domain/comparison/entry_status_link.dart';
import 'package:fujin/domain/comparison/expected_item.dart';
import 'package:fujin/domain/comparison/mfp_status.dart';
import 'package:fujin/domain/comparison/placement.dart';
import 'package:fujin/domain/comparison/update_kind.dart';
import 'package:fujin/domain/journal/same_day.dart';

typedef _Orphan = ({
  LoggedEntry deleted,
  EkkloLink link,
  LinkedItem item,
  Placement placement,
});

DayComparison compareEkkloDay(
  DayDraft day, {
  required List<EkkloDailyMeal> meals,
  required Memory memory,
  required DateTime now,
  required IdSource ids,
}) {
  final placements = placementsOf(meals);
  final entries = [...day.entries];
  final statuses = List<EntryStatus?>.filled(entries.length, null);
  final claimed = <String>{};
  final orphans = <_Orphan>[];

  ExpectedItem? sentOf(EkkloLink link) => switch (link.unattended) {
    final unattended? => ExpectedItem.unattended(unattended),
    null => null,
  };

  UpdateKind updateKindOf(
    LoggedEntry logged,
    EkkloDailyMeal meal,
    ExpectedItem? sent,
  ) => switch ((memory.ekkloMealName(logged.mealName) ?? sent?.ekkloMealName) ==
      meal.name) {
    true => UpdateKind.quantityOnly,
    false => UpdateKind.mealChanged,
  };

  EntryStatus linkedStatus(
    LoggedEntry logged,
    EkkloLink link,
    LinkedItem item,
    Placement placement,
  ) {
    final entry = logged.entry;
    final sameMeal = item.mealId == entry.mealId;
    final unchanged =
        sameMeal &&
        item.foodId == entry.foodId &&
        item.servings == entry.servings &&
        item.servingValue == entry.servingValue &&
        item.servingUnit == entry.servingUnit;
    final sent = sentOf(link);
    final expected = ExpectedItem.forEntry(logged, memory);
    final (:meal, item: ekkloItem) = placement;
    return switch ((unchanged, expected, sent)) {
      (true, final expected?, final sent?)
          when !expected.matches(meal, ekkloItem) =>
        ToUpdate(link, updateKindOf(logged, meal, sent)),
      (true, _, _) => InEkklo(link),
      (false, final expected?, _) when expected.matches(meal, ekkloItem) =>
        InEkklo(link.copyWith(item: item.refreshedFrom(entry))),
      (false, _, _) => ToUpdate(
        link,
        updateKindOf(logged, meal, switch (sameMeal) {
          true => sent,
          false => null,
        }),
      ),
    };
  }

  void settle(int index, LoggedEntry logged, EntryStatus status) {
    statuses[index] = status;
    entries[index] = logged.copyWith(ekkloLink: status.ekkloLink);
  }

  for (final (index, logged) in day.entries.indexed) {
    if (logged.ekkloLink case EkkloLink(item: final item?) && final link) {
      switch ((placements[item.ekkloItemId], logged.mfpLink)) {
        case (final placement?, _):
          claimed.add(item.ekkloItemId);
          settle(index, logged, linkedStatus(logged, link, item, placement));
        case (null, final mfpLink?)
            when !sameDay(mfpLink.date, logged.entry.date):
          settle(index, logged, ToUpdate(link, UpdateKind.mealChanged));
        case (null, _):
          entries[index] = logged.copyWith(
            ekkloLink: switch (link.unattended) {
              _? => link.copyWith(item: null),
              null => null,
            },
          );
      }
    }
  }

  final owed = {
    for (final logged in day.owed)
      if (MfpWrite.of(logged) case MfpDeletion()) logged.entry.id,
  };
  final itemsGone = <String, EkkloLink?>{};
  for (final logged in day.deleted) {
    if (logged.ekkloLink case EkkloLink(item: final item?) && final link) {
      switch ((placements[item.ekkloItemId], owed.contains(logged.entry.id))) {
        case (_?, true):
          claimed.add(item.ekkloItemId);
        case (final placement?, false):
          claimed.add(item.ekkloItemId);
          orphans.add((
            deleted: logged,
            link: link,
            item: item,
            placement: placement,
          ));
        case (null, true):
          itemsGone[logged.entry.id] = switch (link.unattended) {
            _? => link.copyWith(item: null),
            null => null,
          };
        case (null, false):
          continue;
      }
    }
  }

  LoggedEntry withoutGoneItem(LoggedEntry logged) =>
      switch (itemsGone.containsKey(logged.entry.id)) {
        true => logged.copyWith(ekkloLink: itemsGone[logged.entry.id]),
        false => logged,
      };

  Iterable<(int, LoggedEntry)> unresolved() sync* {
    for (final (index, logged) in entries.indexed) {
      if (statuses[index] == null) yield (index, logged);
    }
  }

  for (final (index, logged) in unresolved()) {
    final expectations = [
      ?ExpectedItem.forEntry(logged, memory),
      if (logged.ekkloLink case final link?) ?sentOf(link),
    ];
    final match = placements.values
        .where(
          (placement) =>
              !claimed.contains(placement.item.id) &&
              expectations.any(
                (expected) => expected.matches(placement.meal, placement.item),
              ),
        )
        .firstOrNull;
    if (match case (:final meal, :final item)) {
      claimed.add(item.id);
      final linked = LinkedItem.of(
        logged.entry,
        ekkloMealId: meal.id,
        ekkloItemId: item.id,
        sentAt: item.createdAt ?? now,
      );
      final link = switch (logged.ekkloLink) {
        final link? => link.copyWith(item: linked),
        null => EkkloLink(
          id: ids(),
          entryId: logged.entry.id,
          item: linked,
          updatedAt: now,
        ),
      };
      settle(index, logged, InEkklo(link));
    }
  }

  for (final sameMeal in const [true, false]) {
    for (final (index, logged) in unresolved()) {
      final orphan = orphans
          .where(
            (orphan) =>
                orphan.item.foodId == logged.entry.foodId &&
                (!sameMeal || orphan.item.mealId == logged.entry.mealId),
          )
          .firstOrNull;
      if (orphan case (
        :final link,
        :final item,
        :final placement,
        deleted: _,
      )) {
        orphans.remove(orphan);
        final moved = link.copyWith(
          entryId: logged.entry.id,
          unattended: logged.ekkloLink?.unattended ?? link.unattended,
        );
        settle(
          index,
          logged,
          linkedStatus(
            logged.copyWith(ekkloLink: moved),
            moved,
            item,
            placement,
          ),
        );
      }
    }
  }

  final kept = {...owed, for (final orphan in orphans) orphan.deleted.entry.id};
  final settled = day.copyWith(
    entries: entries,
    deleted: [
      for (final logged in day.deleted)
        if (kept.contains(logged.entry.id)) withoutGoneItem(logged),
    ],
    owed: [for (final logged in day.owed) withoutGoneItem(logged)],
  );
  return DayComparison(
    entries: [
      for (final (index, logged) in entries.indexed)
        ComparedEntry(
          logged,
          statuses[index] ?? const ToSend(),
          mfp: switch (MfpWrite.of(logged)) {
            MfpAdd() || MfpEdit() => const MfpPending(),
            MfpDeletion() || null => null,
          },
        ),
      for (final logged in day.unstored)
        ComparedEntry(logged, const ToSend(), stored: false),
    ],
    leaving: settled.leaving,
    changes: settled.changes,
    replaced: day.replaced,
  );
}
