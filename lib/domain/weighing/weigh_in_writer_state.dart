import 'package:fujin/data/connectors/connector.dart';
import 'package:fujin/data/weigh_ins/weigh_in.dart';
import 'package:fujin/domain/weighing/weigh_in_failure.dart';

sealed class WeighInWriterState {
  const WeighInWriterState({this.failures = const []});

  final List<WeighInFailure> failures;

  String? get _currentId => switch (this) {
    WeighInWriterRunning(:final current?) => current.id,
    WeighInWriterRunning() || WeighInWriterIdle() => null,
  };

  List<WeighInFailure> get stopped => [
    for (final failure in failures)
      if (failure.weighIn.id != _currentId) failure,
  ];

  Set<(Connector, String)> get stoppedKeys => {
    for (final failure in stopped) failure.key,
  };
}

final class WeighInWriterIdle extends WeighInWriterState {
  const WeighInWriterIdle({super.failures});
}

final class WeighInWriterRunning extends WeighInWriterState {
  const WeighInWriterRunning({required this.current, super.failures});

  final WeighIn? current;
}
