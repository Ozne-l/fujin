import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/pages/common/sign_in_failure.dart';

part 'ekklo_sign_in_state.mapper.dart';

@MappableClass(discriminatorKey: 'state')
sealed class EkkloSignInState with EkkloSignInStateMappable {
  const EkkloSignInState();
}

@MappableClass(discriminatorValue: 'idle')
final class EkkloSignInIdle extends EkkloSignInState
    with EkkloSignInIdleMappable {
  const EkkloSignInIdle();
}

@MappableClass(discriminatorValue: 'running')
final class EkkloSignInRunning extends EkkloSignInState
    with EkkloSignInRunningMappable {
  const EkkloSignInRunning();
}

@MappableClass(discriminatorValue: 'done')
final class EkkloSignInDone extends EkkloSignInState
    with EkkloSignInDoneMappable {
  const EkkloSignInDone();
}

@MappableClass(discriminatorValue: 'failed')
final class EkkloSignInFailed extends EkkloSignInState
    with EkkloSignInFailedMappable {
  const EkkloSignInFailed(this.failure, {this.message});

  final SignInFailure failure;
  final String? message;
}
