import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/domain/sending/planned_entry.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

part 'added_food.mapper.dart';

@MappableClass()
final class AddedFood with AddedFoodMappable {
  const AddedFood({required this.planned, required this.ekkloWritten});

  final PlannedEntry planned;
  final bool ekkloWritten;

  String get entryId => planned.entryId;

  MfpFoodEntry get entry => planned.entry;
}
