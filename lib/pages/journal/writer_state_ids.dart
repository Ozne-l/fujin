import 'package:fujin/app/app_environment.dart';
import 'package:fujin/data/entries/mfp_write.dart';
import 'package:fujin/domain/writing/ekklo_job.dart';
import 'package:fujin/domain/writing/write_failure.dart';
import 'package:fujin/domain/writing/writer_state.dart';
import 'package:fujin/pages/sending/send_failure.dart';

extension WriterStateIds on WriterState {
  String? get _currentId => switch (this) {
    WriterRunning(:final current?) => current.entry.id,
    WriterRunning() || WriterIdle() => null,
  };

  Iterable<WriteFailure> stopped(AppEnvironment environment) => [
    for (final failure in failures)
      if (failure.entryId != _currentId &&
          SendFailure.of(failure.error, environment) != SendFailure.network)
        failure,
  ];

  Set<String> mfpFailedIds(AppEnvironment environment) => {
    for (final failure in stopped(environment))
      if (switch (failure) {
        MfpNotWritten() => true,
        EkkloNotWritten(:final logged) => MfpWrite.of(logged) != null,
      })
        failure.entryId,
  };

  Set<String> failedIds(AppEnvironment environment) => {
    for (final failure in stopped(environment)) failure.entryId,
  };

  Set<String> get ekkloSendIds => {
    for (final MapEntry(:key, :value) in held.entries)
      if (value is EkkloSend) key,
  };

  Set<String> get ekkloRemovalIds => {
    for (final MapEntry(:key, :value) in held.entries)
      if (value is EkkloRemoval) key,
  };
}
