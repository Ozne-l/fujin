import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/database/calendar_date_hook.dart';
import 'package:fujin/data/entries/copied_food.dart';
import 'package:fujin/data/entries/copied_meal.dart';
import 'package:fujin/data/entries/ekklo_link.dart';
import 'package:fujin/data/entries/entry.dart';
import 'package:fujin/data/entries/mfp_link.dart';

part 'day_changes.mapper.dart';

@MappableClass()
final class DayChanges with DayChangesMappable {
  const DayChanges({
    required this.date,
    this.foods = const [],
    this.meals = const [],
    this.addedEntries = const [],
    this.changedEntries = const [],
    this.deletedEntryIds = const [],
    this.addedMfpLinks = const [],
    this.changedMfpLinks = const [],
    this.deletedMfpLinkIds = const [],
    this.addedEkkloLinks = const [],
    this.changedEkkloLinks = const [],
    this.droppedEkkloLinkIds = const [],
    this.forgetsWaiting = false,
  });

  @MappableField(hook: CalendarDateHook())
  final DateTime date;
  final List<CopiedFood> foods;
  final List<CopiedMeal> meals;
  final List<Entry> addedEntries;
  final List<Entry> changedEntries;
  final List<String> deletedEntryIds;
  final List<MfpLink> addedMfpLinks;
  final List<MfpLink> changedMfpLinks;
  final List<String> deletedMfpLinkIds;
  final List<EkkloLink> addedEkkloLinks;
  final List<EkkloLink> changedEkkloLinks;
  final List<String> droppedEkkloLinkIds;
  final bool forgetsWaiting;
}
