import 'package:dart_mappable/dart_mappable.dart';

part 'retained_weight.mapper.dart';

@MappableClass()
final class RetainedWeight with RetainedWeightMappable {
  const RetainedWeight({required this.unit, required this.grams});

  final String unit;
  final double grams;
}
