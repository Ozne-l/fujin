import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/domain/sending/send_step.dart';
import 'package:fujin/domain/sending/step_state.dart';

part 'send_progress.mapper.dart';

@MappableClass()
final class SendProgress with SendProgressMappable {
  const SendProgress({this.steps = const []});

  final List<SendStep> steps;

  int get done => steps.where((step) => step.state == StepState.done).length;

  int get remainingEntries => steps
      .where((step) => step.state != StepState.done)
      .fold(0, (sum, step) => sum + step.entryCount);

  SendStep? get failed =>
      steps.where((step) => step.state == StepState.failed).firstOrNull;

  SendProgress marking(int index, StepState state) => copyWith(
    steps: [
      for (final (position, step) in steps.indexed)
        position == index ? step.copyWith(state: state) : step,
    ],
  );
}
