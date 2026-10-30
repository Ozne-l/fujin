import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/domain/adding/add_draft.dart';
import 'package:fujin/domain/journal/read_problem.dart';
import 'package:fujin/domain/sending/planned_entry.dart';

part 'add_form.mapper.dart';

@MappableClass()
final class AddForm with AddFormMappable {
  const AddForm({
    required this.draft,
    this.planned,
    this.planProblem,
  });

  final AddDraft draft;
  final PlannedEntry? planned;
  final ReadProblem? planProblem;
}
