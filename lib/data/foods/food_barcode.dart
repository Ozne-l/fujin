import 'package:dart_mappable/dart_mappable.dart';

part 'food_barcode.mapper.dart';

@MappableClass()
final class FoodBarcode with FoodBarcodeMappable {
  const FoodBarcode({
    required this.id,
    required this.barcode,
    required this.foodId,
    required this.updatedAt,
    this.deletedAt,
  });

  final String id;
  final String barcode;
  final String foodId;
  final DateTime updatedAt;
  final DateTime? deletedAt;
}
