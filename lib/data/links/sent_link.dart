import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/database/calendar_date_hook.dart';

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
