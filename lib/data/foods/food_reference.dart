import 'package:dart_mappable/dart_mappable.dart';

part 'food_reference.mapper.dart';

@MappableClass(discriminatorKey: 'kind')
sealed class FoodReference with FoodReferenceMappable {
  const FoodReference({
    required this.id,
    required this.foodId,
    required this.externalId,
    required this.updatedAt,
    this.deletedAt,
  });

  final String id;
  final String foodId;
  final String externalId;
  final DateTime updatedAt;
  final DateTime? deletedAt;
}

@MappableClass(discriminatorValue: 'mfp')
final class MfpReference extends FoodReference with MfpReferenceMappable {
  const MfpReference({
    required super.id,
    required super.foodId,
    required super.externalId,
    required super.updatedAt,
    this.version,
    super.deletedAt,
  });

  final String? version;
}

@MappableClass(discriminatorValue: 'ekklo')
final class EkkloReference extends FoodReference with EkkloReferenceMappable {
  const EkkloReference({
    required super.id,
    required super.foodId,
    required super.externalId,
    required super.updatedAt,
    required this.name,
    super.deletedAt,
  });

  final String name;
}

@MappableClass(discriminatorValue: 'own_copy')
final class OwnCopyReference extends FoodReference
    with OwnCopyReferenceMappable {
  const OwnCopyReference({
    required super.id,
    required super.foodId,
    required super.externalId,
    required super.updatedAt,
    required this.name,
    required this.unit,
    this.version,
    super.deletedAt,
  });

  final String name;
  final String unit;
  final String? version;
}
