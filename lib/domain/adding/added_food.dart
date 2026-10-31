import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/entries/logged_entry.dart';
import 'package:fujin/domain/sending/planned_entry.dart';

part 'added_food.mapper.dart';

@MappableClass()
final class AddedFood with AddedFoodMappable {
  const AddedFood({required this.entry, this.planned});

  final LoggedEntry entry;
  final PlannedEntry? planned;

  String get entryId => entry.entry.id;
}
