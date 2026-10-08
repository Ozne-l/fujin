import 'package:fujin/app/providers.dart';
import 'package:fujin/domain/sending/send_interruption.dart';
import 'package:fujin/domain/sending/send_plan.dart';
import 'package:fujin/domain/sending/send_progress.dart';
import 'package:fujin/pages/sending/send_failure.dart';
import 'package:fujin/pages/sending/send_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart';

final NotifierProviderFamily<SendNotifier, SendState, DateTime> sendProvider =
    NotifierProvider.autoDispose.family<SendNotifier, SendState, DateTime>(
      SendNotifier.new,
    );

final class SendNotifier extends Notifier<SendState> {
  SendNotifier(this.date);

  final DateTime date;

  @override
  SendState build() => const SendIdle();

  Future<void> send(SendPlan plan) async {
    if (state case SendRunning()) return;
    state = const SendRunning(SendProgress());
    try {
      final report = await ref
          .read(sendServiceProvider)
          .send(
            plan,
            onProgress: (progress) {
              if (ref.mounted) state = SendRunning(progress);
            },
          );
      if (ref.mounted) state = SendDone(report);
    } on Object catch (error) {
      if (ref.mounted) {
        state = SendFailed(
          switch (error) {
            SendInterruption(:final progress) => progress,
            _ => const SendProgress(),
          },
          SendFailure.of(error, ref.read(appEnvironmentProvider)),
        );
      }
    }
  }
}
