import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/data/links/sent_link.dart';
import 'package:fujin/data/memory/memory.dart';
import 'package:fujin/data/unattended/unattended_item.dart';
import 'package:fujin/domain/comparison/compared_entry.dart';
import 'package:fujin/domain/comparison/day_comparison.dart';
import 'package:fujin/domain/comparison/entry_status.dart';
import 'package:fujin/domain/comparison/expected_item.dart';
import 'package:fujin/domain/comparison/placement.dart';
import 'package:fujin/domain/comparison/update_kind.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

typedef _Orphan = ({
  SentLink link,
  EkkloDailyMeal meal,
  EkkloDailyMealItem item,
});

DayComparison compareDay({
  required List<MfpFoodEntry> entries,
  required List<EkkloDailyMeal> meals,
  required List<SentLink> links,
  required List<UnattendedItem> unattended,
  required Memory memory,
  required DateTime now,
}) {
  final placements = placementsOf(meals);
  final entryIds = {for (final entry in entries) ?entry.id};
  final unattendedItems = {
    for (final item in unattended)
      item.mfpEntryId: ExpectedItem.unattended(item),
  };
  final claimed = <String>{};
  final linked = <String, SentLink>{};
  final orphans = <_Orphan>[];
  final dropped = <SentLink>[];
  final adopted = <SentLink>[];
  final unattendedToAdopt = <UnattendedItem>[];

  List<ExpectedItem> expectationsOf(MfpFoodEntry entry, String entryId) => [
    ?ExpectedItem.forEntry(entry, memory),
    ?unattendedItems[entryId],
  ];

  UpdateKind updateKindOf(
    MfpFoodEntry entry,
    EkkloDailyMeal meal,
    ExpectedItem? sent,
  ) => switch ((memory.ekkloMealName(entry.mealName) ?? sent?.ekkloMealName) ==
      meal.name) {
    true => UpdateKind.quantityOnly,
    false => UpdateKind.mealChanged,
  };

  EntryStatus linkedStatus(MfpFoodEntry entry, SentLink link) => switch ((
    unattendedItems[link.mfpEntryId],
    ExpectedItem.forEntry(entry, memory),
    placements[link.ekkloItemId],
  )) {
    (final sent?, final expected?, (:final meal, :final item))
        when !expected.matches(meal, item) =>
      ToUpdate(link, updateKindOf(entry, meal, sent)),
    _ => InEkklo(link),
  };

  for (final link in links) {
    switch ((
      placements[link.ekkloItemId],
      entryIds.contains(link.mfpEntryId),
    )) {
      case (null, _):
        dropped.add(link);
      case (_, true):
        claimed.add(link.ekkloItemId);
        linked[link.mfpEntryId] = link;
      case ((:final meal, :final item), false):
        claimed.add(link.ekkloItemId);
        orphans.add((link: link, meal: meal, item: item));
    }
  }

  final statuses = <EntryStatus?>[
    for (final entry in entries)
      switch (linked[entry.id]) {
        null => null,
        final link => linkedStatus(entry, link),
      },
  ];

  SentLink adopt(
    MfpFoodEntry entry,
    String entryId,
    Placement placement, {
    SentLink? replacing,
  }) {
    if (replacing case final SentLink old) dropped.add(old);
    final link = SentLink.forEntry(
      entry,
      entryId: entryId,
      ekkloMealId: placement.meal.id,
      ekkloItemId: placement.item.id,
      sentAt: placement.item.createdAt ?? now,
    );
    claimed.add(placement.item.id);
    adopted.add(link);
    return link;
  }

  Iterable<(int, MfpFoodEntry, String)> unresolved() sync* {
    for (final (index, entry) in entries.indexed) {
      if ((statuses[index], entry.id) case (null, final String id)) {
        yield (index, entry, id);
      }
    }
  }

  for (final (index, entry, id) in unresolved()) {
    final expectations = expectationsOf(entry, id);
    final match = placements.values
        .where(
          (placement) =>
              !claimed.contains(placement.item.id) &&
              expectations.any(
                (expected) => expected.matches(placement.meal, placement.item),
              ),
        )
        .firstOrNull;
    if (match case final Placement placement) {
      statuses[index] = InEkklo(adopt(entry, id, placement));
    }
  }

  for (final sameMeal in const [true, false]) {
    for (final (index, entry, id) in unresolved()) {
      final orphan = orphans
          .where(
            (orphan) =>
                orphan.link.mfpFoodId == entry.food.id &&
                (!sameMeal || orphan.link.mfpMealName == entry.mealName),
          )
          .firstOrNull;
      if (orphan case (:final link, :final meal, :final item)) {
        orphans.remove(orphan);
        final sent = unattendedItems[id] ?? unattendedItems[link.mfpEntryId];
        if ((unattendedItems[id], sent) case (null, final ExpectedItem moved)) {
          unattendedToAdopt.add(moved.unattendedFor(id, entry.date));
        }
        final sameMealInMfp = entry.mealName == link.mfpMealName;
        final sameEntry =
            sameMealInMfp &&
            entry.servings == link.mfpServings &&
            entry.servingSize.value == link.mfpServingValue &&
            entry.servingSize.unit == link.mfpServingUnit;
        final unchanged = [
          ?ExpectedItem.forEntry(entry, memory),
          if (sameEntry) ?sent,
        ].any((expected) => expected.matches(meal, item));
        statuses[index] = switch (unchanged) {
          true => InEkklo(
            adopt(entry, id, (meal: meal, item: item), replacing: link),
          ),
          false => ToUpdate(
            link,
            updateKindOf(entry, meal, switch (sameMealInMfp) {
              true => sent,
              false => null,
            }),
          ),
        };
      }
    }
  }

  return DayComparison(
    entries: [
      for (final (index, entry) in entries.indexed)
        ComparedEntry(entry, statuses[index] ?? const ToSend()),
    ],
    linksToAdopt: adopted,
    linksToDrop: dropped,
    unattendedToAdopt: unattendedToAdopt,
  );
}
