import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/sending/ekklo_candidate.dart';
import 'package:fujin/domain/sending/planned_entry.dart';
import 'package:fujin/domain/sending/send_choice.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/common/entry_text.dart';
import 'package:fujin/pages/sending/ekklo_search_notifier.dart';
import 'package:fujin/pages/sending/ekklo_search_state.dart';
import 'package:fujin/pages/sending/send_failure.dart';
import 'package:fujin/pages/sending/send_plan_notifier.dart';
import 'package:fujin/pages/sending/send_text.dart';
import 'package:fujin/pages/sending/sheets/candidate_card.dart';
import 'package:fujin/pages/sending/sheets/own_copy_sheet.dart';
import 'package:fujin/pages/sending/sheets/sheet_frame.dart';
import 'package:fujin/pages/sending/widgets/delta_pills.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> showMatchSheet(
  BuildContext context, {
  required PlannedEntry planned,
}) => SheetFrame.show(
  context,
  builder: (_) => _MatchSheet(planned: planned, opener: context),
);

class _MatchSheet extends HookConsumerWidget {
  const _MatchSheet({required this.planned, required this.opener});

  final PlannedEntry planned;
  final BuildContext opener;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final entry = planned.entry;
    final search = ref.watch(ekkloSearchProvider(planned));
    final picked = useState<String?>(null);
    final selected = _selected(search.results ?? const [], picked.value);
    final plan = ref.read(sendPlanProvider(entry.date).notifier);
    final navigator = Navigator.of(context);

    return SheetFrame(
      title: entry.food.description,
      subtitle: EntryText.brandedServing(l10n, entry),
      lead: [_MfpReference(planned: planned)],
      initialQuery: search.query,
      onSearch: (text) => unawaited(
        ref.read(ekkloSearchProvider(planned).notifier).search(text),
      ),
      sectionLabel: l10n.ekkloCandidates,
      body: [
        ..._candidates(l10n, search, selected, picked),
        SheetFrame.inset(
          Text(
            l10n.toleranceNote,
            style: FujinText.inter12Regular.copyWith(
              color: FujinColorRole.textTertiary,
            ),
          ),
        ),
      ],
      primaryLabel: l10n.associateAndRemember,
      onPrimary: switch (selected) {
        final candidate? => () {
          plan.choose(planned.entryId, candidate);
          navigator.pop();
        },
        null => null,
      },
      secondaryLabel: l10n.ownCopy,
      onSecondary: () {
        navigator.pop();
        unawaited(showOwnCopySheet(opener, planned: planned));
      },
      onSkip: () {
        plan.skip(planned.entryId);
        navigator.pop();
      },
    );
  }

  EkkloCandidate? _selected(List<EkkloCandidate> results, String? picked) =>
      _withId(results, picked) ??
      _withId(results, switch (planned.choice) {
        SendToEkkloFood(:final ekkloFoodId) => ekkloFoodId,
        SendAsOwnCopy() || SkipEntry() => null,
      }) ??
      results.where((candidate) => candidate.acceptable).firstOrNull;

  static EkkloCandidate? _withId(List<EkkloCandidate> results, String? id) =>
      results.where((candidate) => candidate.food.id == id).firstOrNull;

  static List<Widget> _candidates(
    AppLocalizations l10n,
    EkkloSearchState search,
    EkkloCandidate? selected,
    ValueNotifier<String?> picked,
  ) => switch (search) {
    EkkloSearchState(failure: final failure?) => [
      _Message(
        text: switch (failure) {
          SendFailure.network => l10n.searchFailedNetwork,
          SendFailure.ekkloSession ||
          SendFailure.mfpSession ||
          SendFailure.refused ||
          SendFailure.blockedInDev ||
          SendFailure.other => l10n.searchFailedOther,
        },
        color: FujinColorRole.textAlert,
      ),
    ],
    EkkloSearchState(results: null) => [const _Searching()],
    EkkloSearchState(results: []) => [
      _Message(
        text: l10n.noEkkloResult,
        color: FujinColorRole.textSecondary,
      ),
    ],
    EkkloSearchState(results: final results?) => [
      for (final candidate in results)
        CandidateCard(
          selected: candidate == selected,
          onTap: () => picked.value = candidate.food.id,
          child: _CandidateDetail(candidate: candidate),
        ),
    ],
  };
}

class _MfpReference extends StatelessWidget {
  const _MfpReference({required this.planned});

  static const _dotSize = 8.0;

  final PlannedEntry planned;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(FujinSpace.s3),
      decoration: BoxDecoration(
        color: FujinColorRole.backgroundPage,
        borderRadius: BorderRadius.circular(FujinRadius.field),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: FujinSpace.s1,
        children: [
          Row(
            spacing: FujinSpace.s2,
            children: [
              const DecoratedBox(
                decoration: BoxDecoration(
                  color: FujinColorRole.sourceMfp,
                  shape: BoxShape.circle,
                ),
                child: SizedBox.square(dimension: _dotSize),
              ),
              Expanded(
                child: Text(
                  l10n.sourceMyFitnessPal,
                  style: FujinText.inter12Medium.copyWith(
                    color: FujinColorRole.textSecondary,
                  ),
                ),
              ),
              Text(
                EntryText.energy(l10n, planned.entry),
                style: FujinText.inter15Semibold.copyWith(
                  color: FujinColorRole.textPrimary,
                ),
              ),
            ],
          ),
          Text(
            EntryText.macros(l10n, planned.entry.nutrients),
            style: FujinText.inter12Medium.copyWith(
              color: FujinColorRole.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

class _CandidateDetail extends StatelessWidget {
  const _CandidateDetail({required this.candidate});

  final EkkloCandidate candidate;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: FujinSpace.s1,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: FujinSpace.s3,
              children: [
                Expanded(
                  child: Text(
                    candidate.food.name,
                    style: FujinText.inter15Medium.copyWith(
                      color: FujinColorRole.textPrimary,
                    ),
                  ),
                ),
                Text(
                  SendText.grams(l10n, candidate.grams),
                  style: FujinText.inter13Regular.copyWith(
                    color: FujinColorRole.textSecondary,
                  ),
                ),
              ],
            ),
            Text(
              CandidateCard.origin(l10n, candidate),
              style: FujinText.inter12Regular.copyWith(
                color: FujinColorRole.textSecondary,
              ),
            ),
          ],
        ),
        DeltaPills(deltas: candidate.deltas),
      ],
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => SheetFrame.inset(
    Text(text, style: FujinText.inter13Regular.copyWith(color: color)),
  );
}

class _Searching extends StatelessWidget {
  const _Searching();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(vertical: FujinSpace.s4),
    child: Center(
      child: SizedBox.square(
        dimension: FujinSize.icon,
        child: CircularProgressIndicator(strokeWidth: FujinStroke.icon),
      ),
    ),
  );
}
