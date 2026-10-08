import 'package:fujin/domain/sending/send_progress.dart';

final class SendInterruption implements Exception {
  const SendInterruption(this.progress, this.cause);

  final SendProgress progress;
  final Object cause;

  @override
  String toString() => 'SendInterruption: $cause';
}
