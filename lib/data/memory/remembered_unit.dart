import 'package:dart_mappable/dart_mappable.dart';

part 'remembered_unit.mapper.dart';

@MappableClass()
final class RememberedUnit with RememberedUnitMappable {
  const RememberedUnit({
    required this.mfpFoodId,
    required this.mfpUnit,
    required this.grams,
  });

  final String mfpFoodId;
  final String mfpUnit;
  final double grams;
}
