import 'package:dart_mappable/dart_mappable.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

part 'read_problem.mapper.dart';

@MappableEnum()
enum ReadProblem {
  mfpSessionExpired,
  ekkloSessionExpired,
  offline,
  mfpUnavailable,
  ekkloUnavailable,
  unknown;

  static ReadProblem of(Object error) => switch (error) {
    MfpAuthException() => mfpSessionExpired,
    EkkloAuthException() => ekkloSessionExpired,
    MfpNetworkException() || EkkloNetworkException() => offline,
    MfpException() => mfpUnavailable,
    EkkloException() => ekkloUnavailable,
    _ => unknown,
  };
}
