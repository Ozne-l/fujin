import 'package:fujin/app/app_environment.dart';
import 'package:fujin/domain/writing/connector_failure.dart';
import 'package:fujin/pages/sending/send_failure.dart';

extension StoppedFailure on ConnectorFailure {
  bool stoppedIn(AppEnvironment environment) =>
      SendFailure.of(error, environment) != SendFailure.network;
}
