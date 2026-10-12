import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/domain/adding/add_stage.dart';
import 'package:fujin/domain/adding/added_food.dart';
import 'package:fujin/domain/journal/read_problem.dart';

part 'add_write_state.mapper.dart';

@MappableClass(discriminatorKey: 'state')
sealed class AddWriteState with AddWriteStateMappable {
  const AddWriteState();
}

@MappableClass(discriminatorValue: 'idle')
final class AddWriteIdle extends AddWriteState with AddWriteIdleMappable {
  const AddWriteIdle();
}

@MappableClass(discriminatorValue: 'running')
final class AddWriteRunning extends AddWriteState with AddWriteRunningMappable {
  const AddWriteRunning(this.stage);

  final AddStage stage;
}

@MappableClass(discriminatorValue: 'done')
final class AddWriteDone extends AddWriteState with AddWriteDoneMappable {
  const AddWriteDone(this.added);

  final AddedFood added;
}

@MappableClass(discriminatorValue: 'failed')
final class AddWriteFailed extends AddWriteState with AddWriteFailedMappable {
  const AddWriteFailed(this.problem);

  final ReadProblem problem;
}

@MappableClass(discriminatorValue: 'ekklo_failed')
final class AddWriteEkkloFailed extends AddWriteState
    with AddWriteEkkloFailedMappable {
  const AddWriteEkkloFailed(this.added, this.problem, {this.undoing = false});

  final AddedFood added;
  final ReadProblem problem;
  final bool undoing;
}
