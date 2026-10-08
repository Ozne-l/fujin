import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fujin/pages/sending/send_notifier.dart';
import 'package:fujin/pages/sending/send_plan_notifier.dart';
import 'package:fujin/pages/sending/send_plan_state.dart';
import 'package:fujin/pages/sending/send_state.dart';
import 'package:fujin/pages/sending/widgets/interrupted_view.dart';
import 'package:fujin/pages/sending/widgets/plan_failed_view.dart';
import 'package:fujin/pages/sending/widgets/review_view.dart';
import 'package:fujin/pages/sending/widgets/searching_view.dart';
import 'package:fujin/pages/sending/widgets/sending_view.dart';
import 'package:fujin/pages/sending/widgets/sent_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SendPage extends HookConsumerWidget {
  const SendPage({required this.date, super.key});

  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planState = ref.watch(sendPlanProvider(date));
    final sendState = ref.watch(sendProvider(date));

    ref.listen(sendPlanProvider(date), (previous, next) {
      if (next case SendPlanReady(
        :final plan,
      ) when plan.entries.isNotEmpty && plan.updatesOnly) {
        unawaited(ref.read(sendProvider(date).notifier).send(plan));
      }
    });

    return PopScope(
      canPop: sendState is! SendRunning,
      child: Scaffold(
        body: SafeArea(
          child: switch ((sendState, planState)) {
            (SendDone(:final report), _) => SentView(report: report),
            (SendRunning(:final progress), SendPlanReady(:final plan)) =>
              SendingView(plan: plan, progress: progress),
            (
              SendFailed(:final progress, :final failure),
              SendPlanReady(:final plan),
            ) =>
              InterruptedView(plan: plan, progress: progress, failure: failure),
            (_, SendPlanSearching(:final plan)) => SearchingView(plan: plan),
            (_, SendPlanReady(:final plan)) => ReviewView(plan: plan),
            (_, SendPlanFailed(:final plan, :final failure)) => PlanFailedView(
              plan: plan,
              failure: failure,
            ),
          },
        ),
      ),
    );
  }
}
