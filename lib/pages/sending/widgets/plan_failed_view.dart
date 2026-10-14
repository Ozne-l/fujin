import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fujin/domain/sending/send_plan.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/sending/send_failure.dart';
import 'package:fujin/pages/sending/send_plan_notifier.dart';
import 'package:fujin/pages/sending/widgets/storm_card.dart';
import 'package:fujin/pages/sending/widgets/storm_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PlanFailedView extends ConsumerWidget {
  const PlanFailedView({required this.plan, required this.failure, super.key});

  final SendPlan plan;
  final SendFailure failure;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StormView(
      plan: plan,
      card: StormCard(
        title: context.intl.searchFailedTitle,
        reason: switch (failure) {
          SendFailure.network ||
          SendFailure.blockedInDev => context.intl.searchFailedNetwork,
          SendFailure.ekkloSession => context.intl.ekkloSessionExpired,
          SendFailure.mfpSession => context.intl.mfpSessionExpired,
          SendFailure.refused ||
          SendFailure.other => context.intl.searchFailedOther,
        },
        action: context.intl.tryAgain,
        onPressed: () => unawaited(
          ref.read(sendPlanProvider(plan.date).notifier).retry(),
        ),
      ),
    );
  }
}
