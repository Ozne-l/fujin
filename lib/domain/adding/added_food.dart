import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/entries/logged_entry.dart';
import 'package:fujin/domain/sending/planned_entry.dart';

part 'added_food.mapper.dart';

@MappableClass()
final class AddedFood with AddedFoodMappable {
  const AddedFood({required this.planned});

  final PlannedEntry planned;

  String get entryId => planned.entryId;

  LoggedEntry get entry => planned.entry;

  bool get toEkklo => planned.sends;
}
