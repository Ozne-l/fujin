import 'package:flutter/material.dart' hide StepState;
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/sending/food_words.dart';
import 'package:fujin/domain/sending/send_plan.dart';
import 'package:fujin/domain/sending/send_progress.dart';
import 'package:fujin/domain/sending/send_step.dart';
import 'package:fujin/domain/sending/step_state.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/sending/widgets/progress_card.dart';
import 'package:fujin/pages/sending/widgets/send_header.dart';
import 'package:fujin/pages/sending/widgets/step_list.dart';
import 'package:fujin/pages/sending/widgets/transit_card.dart';

class SendingView extends StatelessWidget {
  const SendingView({required this.plan, required this.progress, super.key});

  final SendPlan plan;
  final SendProgress progress;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SendHeader(plan: plan, closable: false),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(bottom: FujinSpace.s6),
            children: [
              ProgressCard(
                title: l10n.sendingTitle,
                detail: l10n.sendingDetail,
                note: l10n.sendingNote,
                done: progress.done,
                total: progress.steps.length,
              ),
              const SizedBox(height: FujinSpace.s5),
              StepList(steps: progress.steps),
              const SizedBox(height: FujinSpace.s6),
              TransitCard(names: _inTransit()),
            ],
          ),
        ),
      ],
    );
  }

  List<String> _inTransit() => switch (progress.steps
      .where((step) => step.state == StepState.running)
      .firstOrNull) {
    MealStep(:final entryIds) => [
      for (final entryId in entryIds)
        if (plan.entry(entryId) case final planned?)
          productName(planned.entry.food),
    ],
    OwnCopyStep(:final name) || QuantityUpdateStep(:final name) => [name],
    null => const [],
  };
}
