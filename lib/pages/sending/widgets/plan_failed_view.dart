import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fujin/domain/sending/send_plan.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context);
    return StormView(
      plan: plan,
      card: StormCard(
        title: l10n.searchFailedTitle,
        reason: switch (failure) {
          SendFailure.network ||
          SendFailure.blockedInDev => l10n.searchFailedNetwork,
          SendFailure.ekkloSession => l10n.ekkloSessionExpired,
          SendFailure.mfpSession => l10n.mfpSessionExpired,
          SendFailure.refused || SendFailure.other => l10n.searchFailedOther,
        },
        action: l10n.tryAgain,
        onPressed: () => unawaited(
          ref.read(sendPlanProvider(plan.date).notifier).retry(),
        ),
      ),
    );
  }
}
