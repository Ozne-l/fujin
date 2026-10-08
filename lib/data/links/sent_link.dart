import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/database/calendar_date_hook.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

part 'sent_link.mapper.dart';

@MappableClass()
final class SentLink with SentLinkMappable {
  const SentLink({
    required this.mfpEntryId,
    required this.date,
    required this.mfpFoodId,
    required this.mfpMealName,
    required this.mfpServings,
    required this.mfpServingValue,
    required this.mfpServingUnit,
    required this.ekkloMealId,
    required this.ekkloItemId,
    required this.sentAt,
  });

  factory SentLink.forEntry(
    MfpFoodEntry entry, {
    required String entryId,
    required String ekkloMealId,
    required String ekkloItemId,
    required DateTime sentAt,
  }) => SentLink(
    mfpEntryId: entryId,
    date: entry.date,
    mfpFoodId: entry.food.id,
    mfpMealName: entry.mealName,
    mfpServings: entry.servings,
    mfpServingValue: entry.servingSize.value,
    mfpServingUnit: entry.servingSize.unit,
    ekkloMealId: ekkloMealId,
    ekkloItemId: ekkloItemId,
    sentAt: sentAt,
  );

  final String mfpEntryId;
  @MappableField(hook: CalendarDateHook())
  final DateTime date;
  final String mfpFoodId;
  final String mfpMealName;
  final double mfpServings;
  final double mfpServingValue;
  final String mfpServingUnit;
  final String ekkloMealId;
  final String ekkloItemId;
  final DateTime sentAt;
}
