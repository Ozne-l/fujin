import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/sending/send_plan.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/common/pill_tone.dart';
import 'package:fujin/pages/sending/send_notifier.dart';
import 'package:fujin/pages/sending/widgets/plan_row.dart';
import 'package:fujin/pages/sending/widgets/review_card.dart';
import 'package:fujin/pages/sending/widgets/review_filters.dart';
import 'package:fujin/pages/sending/widgets/send_header.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ReviewView extends HookConsumerWidget {
  const ReviewView({required this.plan, super.key});

  final SendPlan plan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final chosen = useState<_Section?>(null);
    final available = [
      for (final section in _Section.values)
        if (section.count(plan) > 0) section,
    ];
    final section = switch (chosen.value) {
      final chosen? when available.contains(chosen) => chosen,
      _ => available.firstOrNull,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SendHeader(plan: plan),
        if (available.isNotEmpty)
          ReviewFilters(
            chips: [
              for (final filter in available)
                (
                  label: filter.label(l10n, filter.count(plan)),
                  tone: filter.tone,
                  selected: filter == section,
                  onSelected: () => chosen.value = filter,
                ),
            ],
          ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: FujinSpace.s4),
            children: [
              if (section case final section?) ...[
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: FujinSize.textInset,
                    end: FujinSize.textInset,
                    bottom: FujinSpace.s3,
                  ),
                  child: Text(
                    section.heading(l10n),
                    style: FujinText.inter12Medium.copyWith(
                      color: FujinColorRole.textSecondary,
                    ),
                  ),
                ),
                ...switch (section) {
                  _Section.toReview => [
                    for (final planned in plan.toReview)
                      Padding(
                        padding: const EdgeInsets.only(bottom: FujinSpace.s3),
                        child: ReviewCard(
                          key: ValueKey(planned.entryId),
                          planned: planned,
                        ),
                      ),
                  ],
                  _Section.automatic => [
                    PlanRow.card([
                      for (final planned in plan.automatic)
                        PlanRow.planned(planned),
                    ]),
                  ],
                  _Section.inEkklo => [
                    PlanRow.card([
                      for (final compared in plan.inEkklo)
                        PlanRow.inEkklo(compared),
                    ]),
                  ],
                },
              ],
            ],
          ),
        ),
        _Footer(plan: plan),
      ],
    );
  }
}

enum _Section {
  toReview(PillTone.attention),
  automatic(PillTone.validated),
  inEkklo(PillTone.muted);

  const _Section(this.tone);

  final PillTone tone;

  int count(SendPlan plan) => switch (this) {
    _Section.toReview => plan.toReview.length,
    _Section.automatic => plan.automatic.length,
    _Section.inEkklo => plan.inEkklo.length,
  };

  String label(AppLocalizations l10n, int count) => switch (this) {
    _Section.toReview => l10n.filterToReview(count),
    _Section.automatic => l10n.filterAutomatic(count),
    _Section.inEkklo => l10n.filterInEkklo(count),
  };

  String heading(AppLocalizations l10n) => switch (this) {
    _Section.toReview => l10n.sectionToReview,
    _Section.automatic => l10n.sectionAutomatic,
    _Section.inEkklo => l10n.sectionInEkklo,
  };
}

class _Footer extends ConsumerWidget {
  const _Footer({required this.plan});

  final SendPlan plan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final sent = plan.entries.where((planned) => planned.sends);
    final updates = sent.where((planned) => planned.replacing != null).length;
    final label = switch ((sent.length - updates, updates)) {
      (0, 0) => null,
      (final send, 0) => l10n.sendFoods(send),
      (0, final update) => l10n.updateFoods(update),
      (final send, final update) => l10n.sendAndUpdateFoods(send, update),
    };
    return ColoredBox(
      color: FujinColorRole.backgroundPage,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          FujinSize.screenMargin,
          FujinSpace.s4,
          FujinSize.screenMargin,
          FujinSpace.s2,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: FujinSpace.s3,
          children: [
            Text(
              l10n.proposalsUsed,
              textAlign: TextAlign.center,
              style: FujinText.inter12Regular.copyWith(
                color: FujinColorRole.textSecondary,
              ),
            ),
            FilledButton(
              onPressed: switch (label) {
                null => null,
                _ => () => unawaited(
                  ref.read(sendProvider(plan.date).notifier).send(plan),
                ),
              },
              child: Text(label ?? l10n.sendToEkklo),
            ),
          ],
        ),
      ),
    );
  }
}
