import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/entries/ekklo_link.dart';
import 'package:fujin/data/entries/logged_entry.dart';
import 'package:fujin/domain/adding/add_draft.dart';
import 'package:fujin/domain/sending/planned_entry.dart';

part 'edited_food.mapper.dart';

@MappableClass()
final class EditedFood with EditedFoodMappable {
  const EditedFood({
    required this.original,
    required this.draft,
    required this.entry,
    this.planned,
    this.link,
  });

  final LoggedEntry original;
  final AddDraft draft;
  final LoggedEntry entry;
  final PlannedEntry? planned;
  final EkkloLink? link;

  String get entryId => original.entry.id;
}
