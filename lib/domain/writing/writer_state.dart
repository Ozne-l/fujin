import 'package:fujin/data/entries/logged_entry.dart';
import 'package:fujin/data/entries/mfp_write.dart';
import 'package:fujin/domain/comparison/replacement.dart';
import 'package:fujin/domain/writing/ekklo_job.dart';
import 'package:fujin/domain/writing/write_failure.dart';

sealed class WriterState {
  const WriterState({
    this.failures = const [],
    this.held = const {},
    this.replaced = const [],
  });

  final List<WriteFailure> failures;
  final Map<String, EkkloJob> held;
  final List<Replacement> replaced;

  WriterState withHeld(Map<String, EkkloJob> held);

  LoggedEntry? writtenSince(WriterState? previous) =>
      switch ((previous, this)) {
        (WriterRunning(current: final written?), WriterIdle()) => written,
        (
          WriterRunning(current: final written?),
          WriterRunning(:final current),
        )
            when current != written =>
          written,
        _ => null,
      };

  WriterIdle? runEndedSince(WriterState? previous) =>
      switch ((previous, this)) {
        (WriterRunning(), final WriterIdle idle) => idle,
        _ => null,
      };

  String? get _currentId => switch (this) {
    WriterRunning(:final current?) => current.entry.id,
    WriterRunning() || WriterIdle() => null,
  };

  Iterable<WriteFailure> get stopped => [
    for (final failure in failures)
      if (failure.entryId != _currentId) failure,
  ];

  Set<String> get mfpFailedIds => {
    for (final failure in stopped)
      if (switch (failure) {
        MfpNotWritten() => true,
        EkkloNotWritten(:final logged) => MfpWrite.of(logged) != null,
      })
        failure.entryId,
  };

  Set<String> get failedIds => {for (final failure in stopped) failure.entryId};

  Set<String> get ekkloSendIds => {
    for (final MapEntry(:key, :value) in held.entries)
      if (value is EkkloSend) key,
  };

  Set<String> get ekkloRemovalIds => {
    for (final MapEntry(:key, :value) in held.entries)
      if (value is EkkloRemoval) key,
  };
}

final class WriterIdle extends WriterState {
  const WriterIdle({super.failures, super.held, super.replaced});

  @override
  WriterIdle withHeld(Map<String, EkkloJob> held) =>
      WriterIdle(failures: failures, held: held, replaced: replaced);
}

final class WriterRunning extends WriterState {
  const WriterRunning({required this.current, super.failures, super.held});

  final LoggedEntry? current;

  @override
  WriterRunning withHeld(Map<String, EkkloJob> held) =>
      WriterRunning(current: current, failures: failures, held: held);
}
