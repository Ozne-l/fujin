import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/domain/adding/added_food.dart';
import 'package:fujin/domain/journal/read_problem.dart';

part 'undo_add_state.mapper.dart';

@MappableClass(discriminatorKey: 'state')
sealed class UndoAddState with UndoAddStateMappable {
  const UndoAddState();
}

@MappableClass(discriminatorValue: 'idle')
final class UndoAddIdle extends UndoAddState with UndoAddIdleMappable {
  const UndoAddIdle();
}

@MappableClass(discriminatorValue: 'running')
final class UndoAddRunning extends UndoAddState with UndoAddRunningMappable {
  const UndoAddRunning();
}

@MappableClass(discriminatorValue: 'done')
final class UndoAddDone extends UndoAddState with UndoAddDoneMappable {
  const UndoAddDone(this.added);

  final AddedFood added;
}

@MappableClass(discriminatorValue: 'failed')
final class UndoAddFailed extends UndoAddState with UndoAddFailedMappable {
  const UndoAddFailed(
    this.added,
    this.problem, {
    required this.removedFromEkklo,
  });

  final AddedFood added;
  final ReadProblem problem;
  final bool removedFromEkklo;
}
