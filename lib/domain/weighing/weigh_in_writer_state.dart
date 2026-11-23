import 'package:fujin/data/weigh_ins/weigh_in.dart';
import 'package:fujin/domain/weighing/weigh_in_failure.dart';

sealed class WeighInWriterState {
  const WeighInWriterState({this.failures = const []});

  final List<WeighInFailure> failures;
}

final class WeighInWriterIdle extends WeighInWriterState {
  const WeighInWriterIdle({super.failures});
}

final class WeighInWriterRunning extends WeighInWriterState {
  const WeighInWriterRunning({required this.current, super.failures});

  final WeighIn? current;
}
