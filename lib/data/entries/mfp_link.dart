import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/database/calendar_date_hook.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

part 'mfp_link.mapper.dart';

@MappableClass()
final class MfpLink with MfpLinkMappable {
  const MfpLink({
    required this.id,
    required this.entryId,
    required this.mfpEntryId,
    required this.date,
    required this.mealName,
    required this.foodId,
    required this.servings,
    required this.servingValue,
    required this.servingUnit,
    required this.updatedAt,
    this.foodVersion,
    this.deletedAt,
  });

  factory MfpLink.of(
    MfpFoodEntry entry, {
    required String id,
    required String entryId,
    required String mfpEntryId,
    required DateTime updatedAt,
  }) => MfpLink(
    id: id,
    entryId: entryId,
    mfpEntryId: mfpEntryId,
    date: entry.date,
    mealName: entry.mealName,
    foodId: entry.food.id,
    foodVersion: entry.food.version,
    servings: entry.servings,
    servingValue: entry.servingSize.value,
    servingUnit: entry.servingSize.unit,
    updatedAt: updatedAt,
  );

  final String id;
  final String entryId;
  final String mfpEntryId;
  @MappableField(hook: CalendarDateHook())
  final DateTime date;
  final String mealName;
  final String foodId;
  final String? foodVersion;
  final double servings;
  final double servingValue;
  final String servingUnit;
  final DateTime updatedAt;
  final DateTime? deletedAt;
}
