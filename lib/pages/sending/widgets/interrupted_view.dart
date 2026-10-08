import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/sending/send_plan.dart';
import 'package:fujin/domain/sending/send_progress.dart';
import 'package:fujin/domain/sending/send_step.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context);
    final remaining = progress.remainingEntries;
    return StormView(
      plan: plan,
      card: StormCard(
        title: l10n.interruptedTitle,
        reason: _reason(l10n),
        waiting: switch (remaining) {
          > 0 => l10n.interruptedWaiting(remaining),
          _ => null,
        },
        action: switch (progress.steps) {
          [] => l10n.tryAgain,
          _ => l10n.sendRemaining(remaining),
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
            l10n.interruptedNote,
            textAlign: TextAlign.center,
            style: FujinText.inter13Regular.copyWith(
              color: FujinColorRole.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  String _reason(AppLocalizations l10n) => switch ((
    failure,
    _label(progress.failed),
  )) {
    (SendFailure.network, final step?) => l10n.interruptedNetwork(step),
    (SendFailure.ekkloSession, final step?) => l10n.interruptedSession(step),
    (SendFailure.refused, final step?) => l10n.interruptedRefused(step),
    (SendFailure.blockedInDev, final step?) => l10n.interruptedDev(step),
    (SendFailure.mfpSession, _) => l10n.mfpSessionExpired,
    (SendFailure.other, final step?) => l10n.interruptedOther(step),
    (SendFailure.network || SendFailure.blockedInDev, null) =>
      l10n.sendFailedNetwork,
    (SendFailure.ekkloSession, null) => l10n.ekkloSessionExpired,
    (SendFailure.refused || SendFailure.other, null) => l10n.sendFailedOther,
  };

  static String? _label(SendStep? step) => switch (step) {
    MealStep(:final ekkloMealName) => ekkloMealName,
    OwnCopyStep(:final name) || QuantityUpdateStep(:final name) => name,
    null => null,
  };
}
