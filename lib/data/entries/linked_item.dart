import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/entries/entry.dart';

part 'linked_item.mapper.dart';

@MappableClass()
final class LinkedItem with LinkedItemMappable {
  const LinkedItem({
    required this.ekkloMealId,
    required this.ekkloItemId,
    required this.mealId,
    required this.foodId,
    required this.servings,
    required this.servingValue,
    required this.servingUnit,
    required this.sentAt,
  });

  factory LinkedItem.of(
    Entry entry, {
    required String ekkloMealId,
    required String ekkloItemId,
    required DateTime sentAt,
  }) => LinkedItem(
    ekkloMealId: ekkloMealId,
    ekkloItemId: ekkloItemId,
    mealId: entry.mealId,
    foodId: entry.foodId,
    servings: entry.servings,
    servingValue: entry.servingValue,
    servingUnit: entry.servingUnit,
    sentAt: sentAt,
  );

  static const itemIdKey = 'ekklo_item_id';

  final String ekkloMealId;
  @MappableField(key: itemIdKey)
  final String ekkloItemId;
  final String mealId;
  final String foodId;
  final double servings;
  final double servingValue;
  final String servingUnit;
  final DateTime sentAt;

  LinkedItem refreshedFrom(Entry entry) => LinkedItem.of(
    entry,
    ekkloMealId: ekkloMealId,
    ekkloItemId: ekkloItemId,
    sentAt: sentAt,
  );
}
