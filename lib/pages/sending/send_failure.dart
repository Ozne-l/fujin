import 'package:dart_mappable/dart_mappable.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/app/app_environment.dart';
import 'package:fujin/data/http/read_only_http_client.dart';
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

  static const _firstServerErrorStatus = 500;

  static SendFailure of(Object error, AppEnvironment environment) =>
      switch ((error, environment)) {
        (SendInterruption(:final cause), _) => of(cause, environment),
        (EkkloNetworkException(:final method), AppEnvironment.dev)
            when !ReadOnlyHttpClient.reads(method) =>
          blockedInDev,
        (EkkloNetworkException() || MfpNetworkException(), _) => network,
        (EkkloAuthException(), _) => ekkloSession,
        (MfpAuthException(), _) => mfpSession,
        (EkkloApiException(:final statusCode), _)
            when statusCode < _firstServerErrorStatus =>
          refused,
        _ => other,
      };
}
