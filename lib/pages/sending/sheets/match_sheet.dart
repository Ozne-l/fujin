import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/sending/ekklo_candidate.dart';
import 'package:fujin/domain/sending/planned_entry.dart';
import 'package:fujin/domain/sending/send_choice.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/entry_text.dart';
import 'package:fujin/pages/common/source_dot.dart';
import 'package:fujin/pages/sending/ekklo_search_notifier.dart';
import 'package:fujin/pages/sending/ekklo_search_state.dart';
import 'package:fujin/pages/sending/entry_choices.dart';
import 'package:fujin/pages/sending/send_failure.dart';
import 'package:fujin/pages/sending/send_text.dart';
import 'package:fujin/pages/sending/sheets/candidate_card.dart';
import 'package:fujin/pages/sending/sheets/own_copy_sheet.dart';
import 'package:fujin/pages/sending/sheets/sheet_frame.dart';
import 'package:fujin/pages/sending/sheets/sheet_message.dart';
import 'package:fujin/pages/sending/sheets/sheet_searching.dart';
import 'package:fujin/pages/sending/widgets/delta_pills.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> showMatchSheet(
  BuildContext context, {
  required PlannedEntry planned,
  required EntryChoices choices,
  String? query,
}) => SheetFrame.show(
  context,
  builder: (_) => _MatchSheet(
    planned: planned,
    choices: choices,
    query: query,
    opener: context,
  ),
);

class _MatchSheet extends HookConsumerWidget {
  const _MatchSheet({
    required this.planned,
    required this.choices,
    required this.query,
    required this.opener,
  });

  final PlannedEntry planned;
  final EntryChoices choices;
  final String? query;
  final BuildContext opener;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entry = planned.entry;
    final search = ref.watch(ekkloSearchProvider(planned));
    final picked = useState<String?>(null);
    final selected = _selected(switch (search) {
      EkkloSearchDone(:final results) => results,
      EkkloSearchRunning() || EkkloSearchFailed() => const [],
    }, picked.value);
    useEffect(() {
      if (query case final typed?) {
        unawaited(
          Future(
            () => ref.read(ekkloSearchProvider(planned).notifier).search(typed),
          ),
        );
      }
      return null;
    }, const []);
    final navigator = Navigator.of(context);

    return SheetFrame(
      title: entry.food.description,
      subtitle: EntryText.brandedServing(context.intl, entry),
      lead: [_MfpReference(planned: planned)],
      initialQuery: search.query,
      onSearch: (text) => unawaited(
        ref.read(ekkloSearchProvider(planned).notifier).search(text),
      ),
      sectionLabel: context.intl.ekkloCandidates,
      body: [
        ..._candidates(context.intl, search, selected, picked),
        SheetFrame.inset(
          Text(
            context.intl.toleranceNote,
            style: FujinText.inter12Regular.copyWith(
              color: FujinColorRole.textTertiary,
            ),
          ),
        ),
      ],
      primaryLabel: context.intl.associateAndRemember,
      onPrimary: switch (selected) {
        final candidate? => () {
          choices.choose(candidate);
          navigator.pop();
        },
        null => null,
      },
      secondaryLabel: context.intl.ownCopy,
      onSecondary: () {
        navigator.pop();
        unawaited(
          showOwnCopySheet(opener, planned: planned, choices: choices),
        );
      },
      onSkip: switch (choices.skip) {
        final skip? => () {
          skip();
          navigator.pop();
        },
        null => null,
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
    AppLocalizations intl,
    EkkloSearchState search,
    EkkloCandidate? selected,
    ValueNotifier<String?> picked,
  ) => switch (search) {
    EkkloSearchFailed(:final failure) => [
      SheetMessage(
        text: switch (failure) {
          SendFailure.network => intl.searchFailedNetwork,
          SendFailure.ekkloSession ||
          SendFailure.mfpSession ||
          SendFailure.refused ||
          SendFailure.blockedInDev ||
          SendFailure.other => intl.searchFailedOther,
        },
        color: FujinColorRole.textAlert,
      ),
    ],
    EkkloSearchRunning() => [const SheetSearching()],
    EkkloSearchDone(results: []) => [
      SheetMessage(
        text: intl.noEkkloResult,
        color: FujinColorRole.textSecondary,
      ),
    ],
    EkkloSearchDone(:final results) => [
      for (final candidate in results)
        CandidateCard(
          key: ValueKey(candidate.food.id),
          selected: candidate == selected,
          onTap: () => picked.value = candidate.food.id,
          child: _CandidateDetail(candidate: candidate),
        ),
    ],
  };
}

class _MfpReference extends StatelessWidget {
  const _MfpReference({required this.planned});

  final PlannedEntry planned;

  @override
  Widget build(BuildContext context) {
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
              const SourceDot(color: FujinColorRole.sourceMfp),
              Expanded(
                child: Text(
                  context.intl.sourceMyFitnessPal,
                  style: FujinText.inter12Medium.copyWith(
                    color: FujinColorRole.textSecondary,
                  ),
                ),
              ),
              Text(
                EntryText.energy(context.intl, planned.entry),
                style: FujinText.inter15Semibold.copyWith(
                  color: FujinColorRole.textPrimary,
                ),
              ),
            ],
          ),
          Text(
            EntryText.macros(context.intl, planned.entry.nutrients),
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
                  SendText.grams(context.intl, candidate.grams),
                  style: FujinText.inter13Regular.copyWith(
                    color: FujinColorRole.textSecondary,
                  ),
                ),
              ],
            ),
            Text(
              CandidateCard.origin(context.intl, candidate),
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
