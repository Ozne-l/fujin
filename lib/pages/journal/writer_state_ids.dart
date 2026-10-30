import 'package:fujin/data/entries/mfp_write.dart';
import 'package:fujin/domain/writing/write_failure.dart';
import 'package:fujin/domain/writing/writer_state.dart';

extension WriterStateIds on WriterState {
  Set<String> get mfpFailedIds {
    final current = switch (this) {
      WriterRunning(:final current?) => current.entry.id,
      WriterRunning() || WriterIdle() => null,
    };
    return {
      for (final failure in failures)
        if (failure.entryId != current)
          if (switch (failure) {
            MfpNotWritten() => true,
            EkkloNotWritten(:final logged) => MfpWrite.of(logged) != null,
          })
            failure.entryId,
    };
  }
}
