import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/domain/comparison/compared_entry.dart';
import 'package:fujin/domain/sending/planned_entry.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

part 'send_plan.mapper.dart';

@MappableClass()
final class SendPlan with SendPlanMappable {
  const SendPlan({
    required this.date,
    this.entries = const [],
    this.pending = const [],
    this.inEkklo = const [],
  });

  final DateTime date;
  final List<PlannedEntry> entries;
  final List<MfpFoodEntry> pending;
  final List<ComparedEntry> inEkklo;

  bool get searching => pending.isNotEmpty;

  int get total => entries.length + pending.length;

  List<PlannedEntry> get toReview => [
    for (final planned in entries)
      if (planned.reviewed) planned,
  ];

  List<PlannedEntry> get automatic => [
    for (final planned in entries)
      if (!planned.reviewed) planned,
  ];

  int get sendCount => entries.where((planned) => planned.sends).length;

  bool get updatesOnly =>
      entries.isNotEmpty &&
      toReview.isEmpty &&
      entries.every((planned) => planned.replacing != null);

  PlannedEntry? entry(String entryId) =>
      entries.where((planned) => planned.entryId == entryId).firstOrNull;

  SendPlan updating(
    String entryId,
    PlannedEntry Function(PlannedEntry planned) change,
  ) => copyWith(
    entries: [
      for (final planned in entries)
        planned.entryId == entryId ? change(planned) : planned,
    ],
  );
}
