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
    required this.planned,
    this.link,
  });

  final LoggedEntry original;
  final AddDraft draft;
  final EkkloLink? link;
  final PlannedEntry planned;

  String get entryId => original.entry.id;

  LoggedEntry get entry => planned.entry;
}
