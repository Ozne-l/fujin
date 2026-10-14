import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/sending/send_plan.dart';
import 'package:fujin/domain/sending/send_progress.dart';
import 'package:fujin/domain/sending/send_step.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/sending/send_failure.dart';
import 'package:fujin/pages/sending/send_notifier.dart';
import 'package:fujin/pages/sending/widgets/step_list.dart';
import 'package:fujin/pages/sending/widgets/storm_card.dart';
import 'package:fujin/pages/sending/widgets/storm_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class InterruptedView extends ConsumerWidget {
  const InterruptedView({
    required this.plan,
    required this.progress,
    required this.failure,
    super.key,
  });

  final SendPlan plan;
  final SendProgress progress;
  final SendFailure failure;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remaining = progress.remainingEntries;
    return StormView(
      plan: plan,
      card: StormCard(
        title: context.intl.interruptedTitle,
        reason: _reason(context.intl),
        waiting: switch (remaining) {
          > 0 => context.intl.interruptedWaiting(remaining),
          _ => null,
        },
        action: switch (progress.steps) {
          [] => context.intl.tryAgain,
          _ => context.intl.sendRemaining(remaining),
        },
        onPressed: () => unawaited(
          ref.read(sendProvider(plan.date).notifier).send(plan),
        ),
      ),
      children: [
        if (progress.steps.isNotEmpty) ...[
          const SizedBox(height: FujinSpace.s2),
          StepList(steps: progress.steps),
        ],
        const SizedBox(height: FujinSpace.s6),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: FujinSize.textInset),
          child: Text(
            context.intl.interruptedNote,
            textAlign: TextAlign.center,
            style: FujinText.inter13Regular.copyWith(
              color: FujinColorRole.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  String _reason(AppLocalizations intl) => switch ((
    failure,
    _label(progress.failed),
  )) {
    (SendFailure.network, final step?) => intl.interruptedNetwork(step),
    (SendFailure.ekkloSession, final step?) => intl.interruptedSession(step),
    (SendFailure.refused, final step?) => intl.interruptedRefused(step),
    (SendFailure.blockedInDev, final step?) => intl.interruptedDev(step),
    (SendFailure.mfpSession, _) => intl.mfpSessionExpired,
    (SendFailure.other, final step?) => intl.interruptedOther(step),
    (SendFailure.network || SendFailure.blockedInDev, null) =>
      intl.sendFailedNetwork,
    (SendFailure.ekkloSession, null) => intl.ekkloSessionExpired,
    (SendFailure.refused || SendFailure.other, null) => intl.sendFailedOther,
  };

  static String? _label(SendStep? step) => switch (step) {
    MealStep(:final ekkloMealName) => ekkloMealName,
    OwnCopyStep(:final name) || QuantityUpdateStep(:final name) => name,
    null => null,
  };
}
