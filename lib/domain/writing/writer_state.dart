import 'package:fujin/data/entries/logged_entry.dart';
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
