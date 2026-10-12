import 'package:dart_mappable/dart_mappable.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/data/database/calendar_date_hook.dart';

part 'unattended_item.mapper.dart';

@MappableClass()
final class UnattendedItem with UnattendedItemMappable {
  const UnattendedItem({
    required this.mfpEntryId,
    required this.date,
    required this.ekkloMealName,
    required this.ekkloFoodId,
    required this.quantity,
    required this.quantityType,
  });

  final String mfpEntryId;
  @MappableField(hook: CalendarDateHook())
  final DateTime date;
  final String ekkloMealName;
  final String ekkloFoodId;
  final double quantity;
  final EkkloQuantityType quantityType;
}
