import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/domain/adding/add_draft.dart';
import 'package:fujin/domain/journal/read_problem.dart';
import 'package:fujin/domain/sending/planned_entry.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

part 'add_form.mapper.dart';

@MappableClass()
final class AddForm with AddFormMappable {
  const AddForm({
    required this.draft,
    this.planned,
    this.planProblem,
    this.changedFrom,
  });

  final AddDraft draft;
  final PlannedEntry? planned;
  final ReadProblem? planProblem;
  final MfpFood? changedFrom;
}
