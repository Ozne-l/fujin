import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fujin/domain/sending/send_mode.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/automatic_mode_notifier.dart';
import 'package:fujin/pages/common/fade_through.dart';
import 'package:fujin/pages/common/fujin_snack_bar.dart';
import 'package:fujin/pages/sending/send_notifier.dart';
import 'package:fujin/pages/sending/send_plan_notifier.dart';
import 'package:fujin/pages/sending/send_plan_state.dart';
import 'package:fujin/pages/sending/send_state.dart';
import 'package:fujin/pages/sending/widgets/automatic_sent_view.dart';
import 'package:fujin/pages/sending/widgets/interrupted_view.dart';
import 'package:fujin/pages/sending/widgets/plan_failed_view.dart';
import 'package:fujin/pages/sending/widgets/review_view.dart';
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
      if (next case SendPlanReady(:final plan)
          when plan.updatesOnly ||
              (ref.read(automaticModeProvider) && plan.sendCount > 0)) {
        unawaited(ref.read(sendProvider(date).notifier).send(plan));
      }
    });

    return PopScope(
      canPop: sendState is! SendRunning,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showFujinSnackBar(
            SnackBar(
              content: Text(context.intl.sendingStay),
            ),
          );
      },
      child: Scaffold(
        body: SafeArea(
          top: false,
          child: FadeThrough(
            child: switch ((sendState, planState)) {
              (SendDone(:final report), _) => _belowStatusBar(
                switch (report.mode) {
                  SendMode.reviewed => SentView(report: report),
                  SendMode.automatic => AutomaticSentView(report: report),
                },
              ),
              (SendRunning(:final progress), SendPlanReady(:final plan)) =>
                _belowStatusBar(SendingView(plan: plan, progress: progress)),
              (
                SendFailed(:final progress, :final failure),
                SendPlanReady(:final plan),
              ) =>
                _belowStatusBar(
                  InterruptedView(
                    plan: plan,
                    progress: progress,
                    failure: failure,
                  ),
                ),
              (_, SendPlanSearching(:final plan)) => ReviewView(
                plan: plan,
                searching: true,
              ),
              (_, SendPlanReady(:final plan)) => ReviewView(plan: plan),
              (_, SendPlanFailed(:final plan, :final failure)) =>
                _belowStatusBar(
                  PlanFailedView(
                    plan: plan,
                    failure: failure,
                  ),
                ),
            },
          ),
        ),
      ),
    );
  }

  static Widget _belowStatusBar(Widget view) => SafeArea(
    key: ValueKey(view.runtimeType),
    bottom: false,
    child: view,
  );
}
