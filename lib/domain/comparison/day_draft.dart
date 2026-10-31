import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/database/calendar_date_hook.dart';
import 'package:fujin/data/entries/copied_food.dart';
import 'package:fujin/data/entries/copied_meal.dart';
import 'package:fujin/data/entries/day_changes.dart';
import 'package:fujin/data/entries/ekklo_link.dart';
import 'package:fujin/data/entries/logged_entry.dart';
import 'package:fujin/data/entries/stored_day.dart';
import 'package:fujin/domain/comparison/replacement.dart';

part 'day_draft.mapper.dart';

@MappableClass()
final class DayDraft with DayDraftMappable {
  const DayDraft({
    required this.date,
    this.stored = const StoredDay(),
    this.entries = const [],
    this.deleted = const [],
    this.owed = const [],
    this.unstored = const [],
    this.foods = const [],
    this.meals = const [],
    this.plannedEntryIds = const {},
    this.pendingLinks = const [],
    this.forgetsWaiting = false,
    this.replaced = const [],
  });

  factory DayDraft.of(StoredDay stored, {required DateTime date}) => DayDraft(
    date: date,
    stored: stored,
    entries: stored.entries,
    deleted: stored.deleted,
    owed: stored.owed,
  );

  @MappableField(hook: CalendarDateHook())
  final DateTime date;
  final StoredDay stored;
  final List<LoggedEntry> entries;
  final List<LoggedEntry> deleted;
  final List<LoggedEntry> owed;
  final List<LoggedEntry> unstored;
  final List<CopiedFood> foods;
  final List<CopiedMeal> meals;
  final Map<String, String> plannedEntryIds;
  final List<EkkloLink> pendingLinks;
  final bool forgetsWaiting;
  final List<Replacement> replaced;

  List<LoggedEntry> get leaving {
    final byId = {
      for (final logged in deleted)
        logged.entry.id: logged.copyWith(mfpLink: null),
      for (final logged in owed)
        if ((logged.entry.deletedAt, logged.mfpLink) case (_?, _?))
          logged.entry.id: logged,
    };
    return [...byId.values]
      ..sort((first, second) => first.entry.id.compareTo(second.entry.id));
  }

  DayChanges get changes {
    final before = [...stored.entries, ...stored.deleted];
    final after = [...entries, ...deleted];
    final entriesBefore = {
      for (final logged in before) logged.entry.id: logged.entry,
    };
    final live = {for (final logged in entries) logged.entry.id};
    final mfpBefore = {
      for (final link in [
        for (final logged in [...stored.entries, ...stored.owed])
          ?logged.mfpLink,
      ])
        link.id: link,
    };
    final mfpAfter = [
      for (final logged in [...entries, ...owed]) ?logged.mfpLink,
    ];
    final ekkloBefore = {
      for (final link in [for (final logged in before) ?logged.ekkloLink])
        link.id: link,
    };
    final ekkloAfter = [for (final logged in after) ?logged.ekkloLink];
    final addedEntries = [
      for (final logged in after)
        if (!entriesBefore.containsKey(logged.entry.id)) logged.entry,
    ];
    final changedEntries = [
      for (final logged in entries)
        if (entriesBefore[logged.entry.id] case final entry?
            when entry != logged.entry)
          logged.entry,
    ];
    final addedEkkloLinks = [
      for (final link in ekkloAfter)
        if (!ekkloBefore.containsKey(link.id)) link,
    ];
    final changedEkkloLinks = [
      for (final link in ekkloAfter)
        if (ekkloBefore[link.id] case final old? when old != link) link,
    ];
    final referenced = {
      for (final entry in [...addedEntries, ...changedEntries]) ...[
        entry.foodId,
        entry.mealId,
      ],
      for (final link in [...addedEkkloLinks, ...changedEkkloLinks])
        if (link.item case final item?) ...[item.foodId, item.mealId],
    };
    return DayChanges(
      date: date,
      foods: [
        for (final food in foods)
          if (referenced.contains(food.id)) food,
      ],
      meals: [
        for (final meal in meals)
          if (referenced.contains(meal.id)) meal,
      ],
      addedEntries: addedEntries,
      changedEntries: changedEntries,
      deletedEntryIds: [
        for (final logged in stored.entries)
          if (!live.contains(logged.entry.id)) logged.entry.id,
      ],
      addedMfpLinks: [
        for (final link in mfpAfter)
          if (!mfpBefore.containsKey(link.id)) link,
      ],
      changedMfpLinks: [
        for (final link in mfpAfter)
          if (mfpBefore[link.id] case final old? when old != link) link,
      ],
      deletedMfpLinkIds: [
        for (final id in mfpBefore.keys)
          if (!mfpAfter.any((link) => link.id == id)) id,
      ],
      addedEkkloLinks: addedEkkloLinks,
      changedEkkloLinks: changedEkkloLinks,
      droppedEkkloLinkIds: [
        for (final id in ekkloBefore.keys)
          if (!ekkloAfter.any((link) => link.id == id)) id,
      ],
      forgetsWaiting: forgetsWaiting && pendingLinks.isEmpty,
    );
  }
}
