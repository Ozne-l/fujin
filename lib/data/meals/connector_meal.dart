import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/connectors/connector.dart';

part 'connector_meal.mapper.dart';

@MappableClass()
final class ConnectorMeal with ConnectorMealMappable {
  const ConnectorMeal({
    required this.id,
    required this.mealId,
    required this.connector,
    required this.name,
    required this.updatedAt,
    this.deletedAt,
  });

  final String id;
  final String mealId;
  final Connector connector;
  final String name;
  final DateTime updatedAt;
  final DateTime? deletedAt;
}
