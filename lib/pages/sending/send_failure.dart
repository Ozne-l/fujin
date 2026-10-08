import 'package:dart_mappable/dart_mappable.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/app/app_environment.dart';
import 'package:fujin/domain/sending/send_interruption.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

part 'send_failure.mapper.dart';

@MappableEnum()
enum SendFailure {
  network,
  ekkloSession,
  mfpSession,
  refused,
  blockedInDev,
  other;

  static SendFailure of(Object error, AppEnvironment environment) =>
      switch ((error, environment)) {
        (SendInterruption(:final cause), _) => of(cause, environment),
        (EkkloNetworkException(), AppEnvironment.dev) => blockedInDev,
        (EkkloNetworkException() || MfpNetworkException(), _) => network,
        (EkkloAuthException(), _) => ekkloSession,
        (MfpAuthException(), _) => mfpSession,
        (EkkloApiException(), _) => refused,
        _ => other,
      };
}
