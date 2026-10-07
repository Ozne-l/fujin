import 'package:dart_mappable/dart_mappable.dart';

part 'remembered_food.mapper.dart';

@MappableClass(discriminatorKey: 'kind')
sealed class RememberedFood with RememberedFoodMappable {
  const RememberedFood({
    required this.mfpFoodId,
    required this.mfpDescription,
    required this.ekkloFoodId,
    required this.ekkloFoodName,
  });

  final String mfpFoodId;
  final String mfpDescription;
  final String ekkloFoodId;
  final String ekkloFoodName;
}

@MappableClass(discriminatorValue: 'ekklo')
final class MatchedFood extends RememberedFood with MatchedFoodMappable {
  const MatchedFood({
    required super.mfpFoodId,
    required super.mfpDescription,
    required super.ekkloFoodId,
    required super.ekkloFoodName,
  });
}

@MappableClass(discriminatorValue: 'own_copy')
final class OwnCopy extends RememberedFood with OwnCopyMappable {
  const OwnCopy({
    required super.mfpFoodId,
    required super.mfpDescription,
    required super.ekkloFoodId,
    required super.ekkloFoodName,
    this.mfpFoodVersion,
  });

  final String? mfpFoodVersion;
}
