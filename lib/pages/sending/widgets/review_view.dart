import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/comparison/entry_status.dart';
import 'package:fujin/domain/sending/planned_entry.dart';
import 'package:fujin/domain/sending/send_choice.dart';
import 'package:fujin/domain/sending/send_plan.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/fade_through.dart';
import 'package:fujin/pages/common/pill_tone.dart';
import 'package:fujin/pages/common/send_label.dart';
import 'package:fujin/pages/sending/send_notifier.dart';
import 'package:fujin/pages/sending/widgets/plan_row.dart';
import 'package:fujin/pages/sending/widgets/progress_card.dart';
import 'package:fujin/pages/sending/widgets/review_card.dart';
import 'package:fujin/pages/sending/widgets/review_filters.dart';
import 'package:fujin/pages/sending/widgets/send_footer.dart';
import 'package:fujin/pages/sending/widgets/send_header.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ReviewView extends StatelessWidget {
  const ReviewView({required this.plan, this.searching = false, super.key});

  final SendPlan plan;
  final bool searching;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      SendHeader(plan: plan),
      Expanded(
        child: FadeThrough(
          scale: _unscaled,
          child: switch (searching) {
            true => _Searching(key: const ValueKey(true), plan: plan),
            false => _Review(key: const ValueKey(false), plan: plan),
          },
        ),
      ),
      _Footer(plan: plan, searching: searching),
    ],
  );

  static const double _unscaled = 1;
}

class _Searching extends StatelessWidget {
  const _Searching({required this.plan, super.key});

  final SendPlan plan;

  @override
  Widget build(BuildContext context) {
    final rows = [
      for (final planned in plan.entries) PlanRow.planned(planned),
      for (final (index, entry) in plan.pending.indexed)
        PlanRow.pending(entry, searching: index == 0),
    ];
    return ListView(
      padding: const EdgeInsets.only(bottom: FujinSpace.s6),
      children: [
        ProgressCard(
          title: context.intl.searchingTitle,
          detail: context.intl.searchingDetail,
          note: context.intl.searchingNote,
          done: plan.entries.length,
          total: plan.total,
        ),
        if (rows.isNotEmpty) ...[
          const SizedBox(height: FujinSpace.s4),
          PlanRow.card(rows),
        ],
      ],
    );
  }
}

class _Review extends HookWidget {
  const _Review({required this.plan, super.key});

  final SendPlan plan;

  @override
  Widget build(BuildContext context) {
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
        if (available.isNotEmpty)
          ReviewFilters(
            chips: [
              for (final filter in available)
                (
                  key: ValueKey(filter),
                  label: filter.label(context.intl, filter.count(plan)),
                  tone: filter.tone,
                  selected: filter == section,
                  onSelected: () => chosen.value = filter,
                ),
            ],
          ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(
              top: FujinSpace.s4,
              bottom: FujinSpace.s6,
            ),
            children: [
              if (section case final section?) ...[
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: FujinSize.textInset,
                    end: FujinSize.textInset,
                    bottom: FujinSpace.s3,
                  ),
                  child: Text(
                    section.heading(context.intl),
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
                    if (plan.toReview.any(_showsDeltas))
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: FujinSize.textInset,
                        ),
                        child: Text(
                          context.intl.toleranceNote,
                          style: FujinText.inter12Regular.copyWith(
                            color: FujinColorRole.textTertiary,
                          ),
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
                        if (compared.status case InEkklo(:final link))
                          PlanRow.inEkklo(compared.entry, link),
                    ]),
                  ],
                },
              ],
            ],
          ),
        ),
      ],
    );
  }
}

bool _showsDeltas(PlannedEntry planned) => switch (planned.choice) {
  SendToEkkloFood(:final food) => food != null,
  SendAsOwnCopy() || SkipEntry() => false,
};

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

  String label(AppLocalizations intl, int count) => switch (this) {
    _Section.toReview => intl.filterToReview(count),
    _Section.automatic => intl.filterAutomatic(count),
    _Section.inEkklo => intl.filterInEkklo(count),
  };

  String heading(AppLocalizations intl) => switch (this) {
    _Section.toReview => intl.sectionToReview,
    _Section.automatic => intl.sectionAutomatic,
    _Section.inEkklo => intl.sectionInEkklo,
  };
}

class _Footer extends ConsumerWidget {
  const _Footer({required this.plan, required this.searching});

  final SendPlan plan;
  final bool searching;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final updates = plan.entries
        .where((planned) => planned.sends && planned.replacing != null)
        .length;
    final label = switch (searching) {
      true => null,
      false => SendLabel.of(context.intl, plan.sendCount - updates, updates),
    };
    return SendFooter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: FujinSpace.s3,
        children: [
          Text(
            context.intl.proposalsUsed,
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
            child: Text(label ?? context.intl.sendToEkklo),
          ),
        ],
      ),
    );
  }
}
