import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/entries/logged_entry.dart';

part 'edited_food.mapper.dart';

@MappableClass()
final class EditedFood with EditedFoodMappable {
  const EditedFood({required this.original, required this.entry});

  final LoggedEntry original;
  final LoggedEntry entry;

  String get entryId => original.entry.id;
}
