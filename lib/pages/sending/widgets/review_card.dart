import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/sending/nutrient_deltas.dart';
import 'package:fujin/domain/sending/planned_entry.dart';
import 'package:fujin/domain/sending/rank_candidates.dart';
import 'package:fujin/domain/sending/review_reason.dart';
import 'package:fujin/domain/sending/send_choice.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/common/entry_text.dart';
import 'package:fujin/pages/common/status_pill.dart';
import 'package:fujin/pages/sending/send_plan_notifier.dart';
import 'package:fujin/pages/sending/send_text.dart';
import 'package:fujin/pages/sending/sheets/match_sheet.dart';
import 'package:fujin/pages/sending/sheets/own_copy_sheet.dart';
import 'package:fujin/pages/sending/sheets/weight_sheet.dart';
import 'package:fujin/pages/sending/widgets/delta_pills.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ReviewCard extends ConsumerWidget {
  const ReviewCard({required this.planned, super.key});

  final PlannedEntry planned;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final entry = planned.entry;
    final (reasonLabel, reasonTone) = SendText.reason(l10n, planned.reason);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: FujinSize.screenMargin),
      padding: const EdgeInsets.fromLTRB(
        FujinSpace.s3,
        FujinSpace.s4,
        FujinSpace.s3,
        FujinSpace.s1,
      ),
      decoration: BoxDecoration(
        color: FujinColorRole.backgroundCard,
        borderRadius: BorderRadius.circular(FujinRadius.card),
        border: Border.all(color: FujinColorRole.borderCard),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: FujinSpace.s3,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(start: FujinSpace.s2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: FujinSpace.s1,
              children: [
                Text(
                  switch (planned.ekkloMealName == entry.mealName) {
                    true => entry.mealName,
                    false => l10n.mealTowards(
                      entry.mealName,
                      planned.ekkloMealName,
                    ),
                  }.toUpperCase(),
                  style: FujinText.inter12Medium.copyWith(
                    color: FujinColorRole.textTertiary,
                  ),
                ),
                Text(
                  entry.food.description,
                  style: FujinText.inter16Medium.copyWith(
                    color: FujinColorRole.textPrimary,
                  ),
                ),
                Text(
                  l10n.entryDetail(
                    EntryText.brandedServing(l10n, entry),
                    EntryText.energy(l10n, entry),
                  ),
                  style: FujinText.inter13Regular.copyWith(
                    color: FujinColorRole.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: FujinSpace.s1,
            children: [
              _Proposal(planned: planned, onChange: () => _change(context)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: FujinSpace.s2),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minHeight: FujinSize.buttonMedium,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    spacing: FujinSpace.s3,
                    children: [
                      Flexible(
                        child: StatusPill(label: reasonLabel, tone: reasonTone),
                      ),
                      if (_confirmable(planned.reason))
                        FilledButton(
                          onPressed: () => _confirm(context, ref),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(0, FujinSize.buttonMedium),
                            padding: const EdgeInsets.symmetric(
                              horizontal: FujinSpace.s3,
                            ),
                            backgroundColor: FujinColor.fujin,
                            foregroundColor: FujinColorRole.textOnDark,
                            textStyle: FujinText.inter16Medium,
                          ),
                          child: Text(l10n.confirm),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static bool _confirmable(ReviewReason reason) => switch (reason) {
    ReviewReason.weightToConfirm ||
    ReviewReason.newAssociation ||
    ReviewReason.noCloseFood => true,
    ReviewReason.skipped || ReviewReason.confirmed => false,
  };

  void _confirm(BuildContext context, WidgetRef ref) {
    switch (planned.reason) {
      case ReviewReason.weightToConfirm:
        unawaited(showWeightSheet(context, planned: planned));
      case ReviewReason.newAssociation ||
          ReviewReason.noCloseFood ||
          ReviewReason.skipped ||
          ReviewReason.confirmed:
        ref
            .read(sendPlanProvider(planned.entry.date).notifier)
            .confirm(planned.entryId);
    }
  }

  void _change(BuildContext context) {
    switch (planned.choice) {
      case SendAsOwnCopy(reuse: null):
        unawaited(showOwnCopySheet(context, planned: planned));
      case SendToEkkloFood() || SendAsOwnCopy() || SkipEntry():
        unawaited(showMatchSheet(context, planned: planned));
    }
  }
}

class _Proposal extends StatelessWidget {
  const _Proposal({required this.planned, required this.onChange});

  final PlannedEntry planned;
  final VoidCallback onChange;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (title, detail, deltas) = _content(l10n);
    return Container(
      padding: const EdgeInsets.all(FujinSpace.s3),
      decoration: BoxDecoration(
        color: FujinColorRole.backgroundPage,
        borderRadius: BorderRadius.circular(FujinRadius.field),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: FujinSpace.s1,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: FujinSpace.s3,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: FujinText.inter14Medium.copyWith(
                    color: FujinColorRole.textPrimary,
                  ),
                ),
              ),
              Semantics(
                button: true,
                child: InkWell(
                  onTap: onChange,
                  child: Text(
                    l10n.change,
                    style: FujinText.inter13Medium.copyWith(
                      color: FujinColorRole.textLink,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (detail case final detail?)
            Text(
              detail,
              style: FujinText.inter12Regular.copyWith(
                color: FujinColorRole.textSecondary,
              ),
            ),
          if (deltas case final deltas?)
            Padding(
              padding: const EdgeInsets.only(top: FujinSpace.s1),
              child: DeltaPills(deltas: deltas),
            ),
        ],
      ),
    );
  }

  (String, String?, NutrientDeltas?) _content(AppLocalizations l10n) =>
      switch (planned.choice) {
        SendToEkkloFood(
          :final ekkloFoodId,
          :final ekkloFoodName,
          :final grams,
          :final gramsPerUnit,
          :final food,
        ) =>
          (
            l10n.towards(ekkloFoodName),
            switch (planned.candidates
                .where((candidate) => candidate.food.id == ekkloFoodId)
                .firstOrNull) {
              null => l10n.ekkloAmount(SendText.grams(l10n, grams)),
              final candidate => l10n.ekkloAmountMatch(
                SendText.grams(l10n, grams),
                SendText.nameMatch(l10n, candidate.nameMatch),
              ),
            },
            switch (food) {
              null => null,
              final food => evaluateCandidate(
                food,
                planned.entry,
                gramsPerUnit: gramsPerUnit,
              )?.deltas,
            },
          ),
        SendAsOwnCopy(reuse: null) => (
          l10n.towards(l10n.ownCopyToCreate),
          l10n.ownCopyExact,
          null,
        ),
        SendAsOwnCopy() => (
          l10n.towards(l10n.ownCopyReused),
          l10n.ownCopyExact,
          null,
        ),
        SkipEntry() => (l10n.skippedDetail, null, null),
      };
}
