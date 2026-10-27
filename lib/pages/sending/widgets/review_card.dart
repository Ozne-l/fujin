import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/sending/nutrient_deltas.dart';
import 'package:fujin/domain/sending/planned_entry.dart';
import 'package:fujin/domain/sending/rank_candidates.dart';
import 'package:fujin/domain/sending/review_reason.dart';
import 'package:fujin/domain/sending/send_choice.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/entry_text.dart';
import 'package:fujin/pages/common/glass_fill.dart';
import 'package:fujin/pages/common/glass_finish.dart';
import 'package:fujin/pages/common/status_pill.dart';
import 'package:fujin/pages/sending/entry_choices.dart';
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
    final entry = planned.entry;
    final (reasonLabel, reasonTone) = SendText.reason(
      context.intl,
      planned.reason,
    );
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: FujinSize.screenMargin),
      padding: const EdgeInsets.fromLTRB(
        FujinSpace.s3,
        FujinSpace.s4,
        FujinSpace.s3,
        FujinSpace.s1,
      ),
      decoration: BoxDecoration(
        color: context.colors.backgroundCard,
        borderRadius: BorderRadius.circular(FujinRadius.card),
        border: Border.all(color: context.colors.borderCard),
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
                    false => context.intl.mealTowards(
                      entry.mealName,
                      planned.ekkloMealName,
                    ),
                  }.toUpperCase(),
                  style: FujinText.inter12Medium.copyWith(
                    color: context.colors.textTertiary,
                  ),
                ),
                Text(
                  entry.food.description,
                  style: FujinText.inter16Medium.copyWith(
                    color: context.colors.textPrimary,
                  ),
                ),
                Text(
                  context.intl.entryDetail(
                    EntryText.brandedServing(context.intl, entry),
                    EntryText.energy(context.intl, entry),
                  ),
                  style: FujinText.inter13Regular.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: FujinSpace.s1,
            children: [
              _Proposal(
                planned: planned,
                onChange: () => _change(context, ref),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: FujinSpace.s2),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minHeight: FujinSize.buttonMedium,
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    runAlignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: FujinSpace.s3,
                    runSpacing: FujinSpace.s2,
                    children: [
                      StatusPill(label: reasonLabel, tone: reasonTone),
                      if (_confirmable(planned.reason))
                        FilledButton(
                          onPressed: () => _confirm(context, ref),
                          style:
                              GlassFill.style(
                                context.colors,
                                GlassFinish.validated,
                              ).merge(
                                FilledButton.styleFrom(
                                  minimumSize: const Size(
                                    0,
                                    FujinSize.buttonCompact,
                                  ),
                                  tapTargetSize: MaterialTapTargetSize.padded,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: FujinSpace.s4,
                                  ),
                                  textStyle: FujinText.inter14Medium,
                                ),
                              ),
                          child: Text(context.intl.confirm),
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

  EntryChoices _choices(WidgetRef ref) {
    final plan = ref.read(sendPlanProvider(planned.entry.date).notifier);
    final entryId = planned.entryId;
    return (
      choose: (candidate) => plan.choose(entryId, candidate),
      ownCopy: () => plan.ownCopy(entryId),
      weigh: (gramsPerUnit) => plan.weigh(entryId, gramsPerUnit),
      skip: () => plan.skip(entryId),
    );
  }

  void _confirm(BuildContext context, WidgetRef ref) {
    switch (planned.reason) {
      case ReviewReason.weightToConfirm:
        unawaited(
          showWeightSheet(context, planned: planned, choices: _choices(ref)),
        );
      case ReviewReason.newAssociation ||
          ReviewReason.noCloseFood ||
          ReviewReason.skipped ||
          ReviewReason.confirmed:
        ref
            .read(sendPlanProvider(planned.entry.date).notifier)
            .confirm(planned.entryId);
    }
  }

  void _change(BuildContext context, WidgetRef ref) {
    final choices = _choices(ref);
    switch (planned.choice) {
      case SendAsOwnCopy(reuse: null):
        unawaited(
          showOwnCopySheet(context, planned: planned, choices: choices),
        );
      case SendToEkkloFood() || SendAsOwnCopy() || SkipEntry():
        unawaited(showMatchSheet(context, planned: planned, choices: choices));
    }
  }
}

class _Proposal extends StatelessWidget {
  const _Proposal({required this.planned, required this.onChange});

  final PlannedEntry planned;
  final VoidCallback onChange;

  @override
  Widget build(BuildContext context) {
    final (title, detail, deltas) = _content(context.intl);
    return Container(
      padding: const EdgeInsets.all(FujinSpace.s3),
      decoration: BoxDecoration(
        color: context.colors.backgroundPage,
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
                    color: context.colors.textPrimary,
                  ),
                ),
              ),
              Semantics(
                button: true,
                child: InkWell(
                  onTap: onChange,
                  child: Text(
                    context.intl.change,
                    style: FujinText.inter13Medium.copyWith(
                      color: context.colors.textLink,
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
                color: context.colors.textSecondary,
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

  (String, String?, NutrientDeltas?) _content(AppLocalizations intl) =>
      switch (planned.choice) {
        SendToEkkloFood(
          :final ekkloFoodId,
          :final ekkloFoodName,
          :final grams,
          :final gramsPerUnit,
          :final food,
        ) =>
          (
            intl.towards(ekkloFoodName),
            switch (planned.candidates
                .where((candidate) => candidate.food.id == ekkloFoodId)
                .firstOrNull) {
              null => intl.ekkloAmount(SendText.grams(intl, grams)),
              final candidate => intl.ekkloAmountMatch(
                SendText.grams(intl, grams),
                SendText.nameMatch(intl, candidate.nameMatch),
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
          intl.towards(intl.ownCopyToCreate),
          intl.ownCopyExact,
          null,
        ),
        SendAsOwnCopy() => (
          intl.towards(intl.ownCopy),
          intl.ownCopyExact,
          null,
        ),
        SkipEntry() => (intl.skippedDetail, null, null),
      };
}
