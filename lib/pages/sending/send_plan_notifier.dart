import 'dart:async';

import 'package:fujin/app/providers.dart';
import 'package:fujin/domain/sending/ekklo_candidate.dart';
import 'package:fujin/domain/sending/planned_entry.dart';
import 'package:fujin/domain/sending/send_plan.dart';
import 'package:fujin/domain/sending/send_service.dart';
import 'package:fujin/pages/sending/send_failure.dart';
import 'package:fujin/pages/sending/send_plan_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart';

final NotifierProviderFamily<SendPlanNotifier, SendPlanState, DateTime>
sendPlanProvider = NotifierProvider.autoDispose
    .family<SendPlanNotifier, SendPlanState, DateTime>(SendPlanNotifier.new);

final class SendPlanNotifier extends Notifier<SendPlanState> {
  SendPlanNotifier(this.date);

  final DateTime date;

  @override
  SendPlanState build() {
    final service = ref.watch(sendServiceProvider);
    unawaited(Future(() => _plan(service)));
    return SendPlanSearching(SendPlan(date: date));
  }

  Future<void> retry() async {
    state = SendPlanSearching(SendPlan(date: date));
    await _plan(ref.read(sendServiceProvider));
  }

  void choose(String entryId, EkkloCandidate candidate) =>
      _change(entryId, (planned) => planned.choose(candidate));

  void ownCopy(String entryId) =>
      _change(entryId, (planned) => planned.asOwnCopy());

  void skip(String entryId) => _change(entryId, (planned) => planned.skip());

  void confirm(String entryId) =>
      _change(entryId, (planned) => planned.confirm());

  void weigh(String entryId, double gramsPerUnit) =>
      _change(entryId, (planned) => planned.weighing(gramsPerUnit));

  Future<void> _plan(SendService service) async {
    var latest = SendPlan(date: date);
    try {
      final plan = await service.plan(
        date,
        onProgress: (plan) {
          latest = plan;
          if (ref.mounted) state = SendPlanSearching(plan);
        },
      );
      if (ref.mounted) state = SendPlanReady(plan);
    } on Object catch (error) {
      if (ref.mounted) {
        state = SendPlanFailed(
          latest,
          SendFailure.of(error, ref.read(appEnvironmentProvider)),
        );
      }
    }
  }

  void _change(
    String entryId,
    PlannedEntry Function(PlannedEntry planned) change,
  ) {
    if (state case SendPlanReady(:final plan)) {
      state = SendPlanReady(plan.updating(entryId, change));
    }
  }
}
