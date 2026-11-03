import 'package:dart_mappable/dart_mappable.dart';

part 'copied_food.mapper.dart';

@MappableClass()
final class CopiedFood with CopiedFoodMappable {
  const CopiedFood({
    required this.id,
    required this.mfpFoodId,
    this.name,
    this.brand,
  });

  final String id;
  final String mfpFoodId;
  final String? name;
  final String? brand;
}
