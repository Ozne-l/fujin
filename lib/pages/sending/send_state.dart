import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/domain/sending/send_progress.dart';
import 'package:fujin/domain/sending/send_report.dart';
import 'package:fujin/pages/sending/send_failure.dart';

part 'send_state.mapper.dart';

@MappableClass(discriminatorKey: 'state')
sealed class SendState with SendStateMappable {
  const SendState();
}

@MappableClass(discriminatorValue: 'idle')
final class SendIdle extends SendState with SendIdleMappable {
  const SendIdle();
}

@MappableClass(discriminatorValue: 'running')
final class SendRunning extends SendState with SendRunningMappable {
  const SendRunning(this.progress);

  final SendProgress progress;
}

@MappableClass(discriminatorValue: 'done')
final class SendDone extends SendState with SendDoneMappable {
  const SendDone(this.report);

  final SendReport report;
}

@MappableClass(discriminatorValue: 'failed')
final class SendFailed extends SendState with SendFailedMappable {
  const SendFailed(this.progress, this.failure);

  final SendProgress progress;
  final SendFailure failure;
}
