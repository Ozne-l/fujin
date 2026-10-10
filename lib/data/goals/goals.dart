import 'package:dart_mappable/dart_mappable.dart';

part 'goals.mapper.dart';

@MappableClass()
final class Goals with GoalsMappable {
  const Goals({
    required this.kilocalories,
    this.protein,
    this.carbohydrates,
    this.fat,
    this.fiber,
  });

  final double kilocalories;
  final double? protein;
  final double? carbohydrates;
  final double? fat;
  final double? fiber;
}
