import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/sending/ekklo_candidate.dart';
import 'package:fujin/domain/sending/food_words.dart';
import 'package:fujin/domain/sending/nutrient.dart';
import 'package:fujin/domain/sending/planned_entry.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/common/entry_text.dart';
import 'package:fujin/pages/common/pill_size.dart';
import 'package:fujin/pages/common/status_pill.dart';
import 'package:fujin/pages/sending/send_plan_notifier.dart';
import 'package:fujin/pages/sending/send_text.dart';
import 'package:fujin/pages/sending/sheets/candidate_card.dart';
import 'package:fujin/pages/sending/sheets/match_sheet.dart';
import 'package:fujin/pages/sending/sheets/sheet_frame.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> showOwnCopySheet(
  BuildContext context, {
  required PlannedEntry planned,
}) => SheetFrame.show(
  context,
  builder: (_) => _OwnCopySheet(planned: planned, opener: context),
);

class _OwnCopySheet extends ConsumerWidget {
  const _OwnCopySheet({required this.planned, required this.opener});

  final PlannedEntry planned;
  final BuildContext opener;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final entry = planned.entry;
    final plan = ref.read(sendPlanProvider(entry.date).notifier);
    final navigator = Navigator.of(context);
    final energy = EntryText.energy(l10n, entry);

    void chooseCandidate() {
      navigator.pop();
      unawaited(showMatchSheet(opener, planned: planned));
    }

    return SheetFrame(
      title: entry.food.description,
      subtitle: l10n.entryDetail(EntryText.serving(l10n, entry), energy),
      lead: [
        const _NoCloseFood(),
        CandidateCard(
          selected: true,
          onTap: null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: FujinSpace.s1,
            children: [
              Text(
                l10n.ownCopyLabel,
                style: FujinText.inter12Medium.copyWith(
                  color: FujinColorRole.textLink,
                ),
              ),
              Text(
                productName(entry.food),
                style: FujinText.inter15Medium.copyWith(
                  color: FujinColorRole.textPrimary,
                ),
              ),
              Text(
                l10n.ownCopyServing(EntryText.serving(l10n, entry), energy),
                style: FujinText.inter12Regular.copyWith(
                  color: FujinColorRole.textSecondary,
                ),
              ),
              Text(
                EntryText.macros(l10n, entry.nutrients),
                style: FujinText.inter12Medium.copyWith(
                  color: FujinColorRole.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ],
      onSearch: (text) {
        navigator.pop();
        unawaited(showMatchSheet(opener, planned: planned, query: text));
      },
      sectionLabel: l10n.rejectedCandidates,
      body: [
        if (planned.candidates.isNotEmpty)
          _Rejected(candidates: planned.candidates, onTap: chooseCandidate),
      ],
      primaryLabel: l10n.createOwnCopy,
      onPrimary: () {
        plan.ownCopy(planned.entryId);
        navigator.pop();
      },
      secondaryLabel: l10n.chooseCandidate,
      onSecondary: chooseCandidate,
      onSkip: () {
        plan.skip(planned.entryId);
        navigator.pop();
      },
    );
  }
}

class _NoCloseFood extends StatelessWidget {
  const _NoCloseFood();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(FujinSpace.s3),
      decoration: BoxDecoration(
        color: FujinColorRole.backgroundInfo,
        borderRadius: BorderRadius.circular(FujinRadius.field),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: FujinSpace.s3,
        children: [
          const Icon(
            Icons.info_outline,
            size: FujinSize.icon,
            color: FujinColor.sora,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: FujinSpace.s1,
              children: [
                Text(
                  l10n.noCloseFoodTitle,
                  style: FujinText.inter14Medium.copyWith(
                    color: FujinColorRole.textPrimary,
                  ),
                ),
                Text(
                  l10n.noCloseFoodDetail,
                  style: FujinText.inter12Regular.copyWith(
                    color: FujinColorRole.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Rejected extends StatelessWidget {
  const _Rejected({required this.candidates, required this.onTap});

  final List<EkkloCandidate> candidates;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: FujinColorRole.backgroundCard,
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(FujinRadius.card),
      side: const BorderSide(color: FujinColorRole.borderCard),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (index, candidate) in candidates.indexed) ...[
          if (index > 0)
            const Divider(
              indent: FujinSpace.s5,
              endIndent: FujinSpace.s5,
            ),
          _RejectedRow(candidate: candidate, onTap: onTap),
        ],
      ],
    ),
  );
}

class _RejectedRow extends StatelessWidget {
  const _RejectedRow({required this.candidate, required this.onTap});

  final EkkloCandidate candidate;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final worst = _worst(candidate);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: FujinSpace.s5,
          vertical: FujinSpace.s3,
        ),
        child: Row(
          spacing: FujinSpace.s3,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: FujinSpace.s1,
                children: [
                  Text(
                    candidate.food.name,
                    style: FujinText.inter15Medium.copyWith(
                      color: FujinColorRole.textPrimary,
                    ),
                  ),
                  Text(
                    CandidateCard.origin(l10n, candidate),
                    style: FujinText.inter12Regular.copyWith(
                      color: FujinColorRole.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            StatusPill(
              label: SendText.delta(l10n, candidate.deltas, worst),
              tone: SendText.deltaTone(candidate.deltas, worst),
              size: PillSize.small,
            ),
          ],
        ),
      ),
    );
  }

  static Nutrient _worst(EkkloCandidate candidate) => Nutrient.values.reduce(
    (worst, nutrient) => switch ((
      candidate.deltas.of(nutrient),
      candidate.deltas.of(worst),
    )) {
      (final gap?, final worstGap?) when gap.abs() > worstGap.abs() => nutrient,
      (_?, null) => nutrient,
      _ => worst,
    },
  );
}
