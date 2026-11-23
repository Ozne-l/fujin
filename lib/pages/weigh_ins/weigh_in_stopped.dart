import 'package:fujin/app/app_environment.dart';
import 'package:fujin/data/connectors/connector.dart';
import 'package:fujin/domain/weighing/weigh_in_failure.dart';
import 'package:fujin/domain/weighing/weigh_in_writer_state.dart';
import 'package:fujin/pages/sending/stopped_failure.dart';

extension WeighInStopped on WeighInWriterState {
  String? get _currentId => switch (this) {
    WeighInWriterRunning(:final current?) => current.id,
    WeighInWriterRunning() || WeighInWriterIdle() => null,
  };

  List<WeighInFailure> stopped(AppEnvironment environment) => [
    for (final failure in failures)
      if (failure.weighIn.id != _currentId && failure.stoppedIn(environment))
        failure,
  ];

  Set<(Connector, String)> stoppedKeys(AppEnvironment environment) => {
    for (final failure in stopped(environment)) failure.key,
  };
}
