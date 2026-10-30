import 'package:fujin/data/entries/logged_entry.dart';
import 'package:fujin/domain/writing/write_failure.dart';

sealed class WriterState {
  const WriterState({this.failures = const []});

  final List<WriteFailure> failures;
}

final class WriterIdle extends WriterState {
  const WriterIdle({super.failures});
}

final class WriterRunning extends WriterState {
  const WriterRunning({required this.current, super.failures});

  final LoggedEntry? current;
}
