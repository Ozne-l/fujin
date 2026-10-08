import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/pages/common/sign_in_failure.dart';

part 'mfp_sign_in_state.mapper.dart';

@MappableClass(discriminatorKey: 'state')
sealed class MfpSignInState with MfpSignInStateMappable {
  const MfpSignInState();
}

@MappableClass(discriminatorValue: 'idle')
final class MfpSignInIdle extends MfpSignInState with MfpSignInIdleMappable {
  const MfpSignInIdle();
}

@MappableClass(discriminatorValue: 'running')
final class MfpSignInRunning extends MfpSignInState
    with MfpSignInRunningMappable {
  const MfpSignInRunning();
}

@MappableClass(discriminatorValue: 'done')
final class MfpSignInDone extends MfpSignInState with MfpSignInDoneMappable {
  const MfpSignInDone();
}

@MappableClass(discriminatorValue: 'failed')
final class MfpSignInFailed extends MfpSignInState
    with MfpSignInFailedMappable {
  const MfpSignInFailed(this.failure);

  final SignInFailure failure;
}
