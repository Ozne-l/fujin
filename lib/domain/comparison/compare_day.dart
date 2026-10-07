import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/data/links/sent_link.dart';
import 'package:fujin/data/memory/memory.dart';
import 'package:fujin/domain/comparison/compared_entry.dart';
import 'package:fujin/domain/comparison/day_comparison.dart';
import 'package:fujin/domain/comparison/entry_status.dart';
import 'package:fujin/domain/comparison/expected_item.dart';
import 'package:fujin/domain/comparison/update_kind.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

typedef _Placement = ({EkkloDailyMeal meal, EkkloDailyMealItem item});
typedef _Orphan = ({
  SentLink link,
  EkkloDailyMeal meal,
  EkkloDailyMealItem item,
});

DayComparison compareDay({
  required List<MfpFoodEntry> entries,
  required List<EkkloDailyMeal> meals,
  required List<SentLink> links,
  required Memory memory,
  required DateTime now,
}) {
  final placements = <String, _Placement>{
    for (final meal in meals)
      for (final item in meal.items) item.id: (meal: meal, item: item),
  };
  final entryIds = {for (final entry in entries) ?entry.id};
  final claimed = <String>{};
  final linked = <String, SentLink>{};
  final orphans = <_Orphan>[];
  final dropped = <SentLink>[];
  final adopted = <SentLink>[];

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
        final link => InEkklo(link),
      },
  ];

  SentLink adopt(
    MfpFoodEntry entry,
    String entryId,
    _Placement placement, {
    SentLink? replacing,
  }) {
    if (replacing case final SentLink old) dropped.add(old);
    final link = SentLink(
      mfpEntryId: entryId,
      date: entry.date,
      mfpFoodId: entry.food.id,
      mfpMealName: entry.mealName,
      mfpServings: entry.servings,
      mfpServingValue: entry.servingSize.value,
      mfpServingUnit: entry.servingSize.unit,
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
    final expected = ExpectedItem.forEntry(entry, memory);
    final match = placements.values
        .where(
          (placement) =>
              !claimed.contains(placement.item.id) &&
              (expected?.matches(placement.meal, placement.item) ?? false),
        )
        .firstOrNull;
    if (match case final _Placement placement) {
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
        final expected = ExpectedItem.forEntry(entry, memory);
        final unchanged = expected?.matches(meal, item) ?? false;
        final sameEkkloMeal = memory.ekkloMealName(entry.mealName) == meal.name;
        statuses[index] = switch ((unchanged, sameEkkloMeal)) {
          (true, _) => InEkklo(
            adopt(entry, id, (meal: meal, item: item), replacing: link),
          ),
          (false, true) => ToUpdate(link, UpdateKind.quantityOnly),
          (false, false) => ToUpdate(link, UpdateKind.mealChanged),
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
  );
}
