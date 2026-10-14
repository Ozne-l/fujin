import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fujin/app/fujin_route.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/adding/add_draft.dart';
import 'package:fujin/domain/adding/add_outcome.dart';
import 'package:fujin/domain/adding/added_food.dart';
import 'package:fujin/domain/adding/ekklo_side.dart';
import 'package:fujin/domain/adding/undo_outcome.dart';
import 'package:fujin/domain/comparison/entry_quantity.dart';
import 'package:fujin/domain/journal/day_nutrients.dart';
import 'package:fujin/domain/journal/read_problem.dart';
import 'package:fujin/domain/sending/nutrient.dart';
import 'package:fujin/domain/sending/planned_entry.dart';
import 'package:fujin/domain/sending/send_choice.dart';
import 'package:fujin/domain/sending/unit_weight.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/adding/add_form_notifier.dart';
import 'package:fujin/pages/adding/add_text.dart';
import 'package:fujin/pages/adding/add_write_notifier.dart';
import 'package:fujin/pages/adding/add_write_state.dart';
import 'package:fujin/pages/adding/widgets/add_section_label.dart';
import 'package:fujin/pages/adding/widgets/ekklo_summary_card.dart';
import 'package:fujin/pages/adding/widgets/food_changed_banner.dart';
import 'package:fujin/pages/adding/widgets/food_identity.dart';
import 'package:fujin/pages/adding/widgets/meal_date_row.dart';
import 'package:fujin/pages/adding/widgets/my_day_sheet.dart';
import 'package:fujin/pages/adding/widgets/nutrition_card.dart';
import 'package:fujin/pages/adding/widgets/serving_field.dart';
import 'package:fujin/pages/adding/widgets/servings_picker.dart';
import 'package:fujin/pages/adding/widgets/write_panel.dart';
import 'package:fujin/pages/common/entry_text.dart';
import 'package:fujin/pages/common/flow_header.dart';
import 'package:fujin/pages/common/fujin_snack_bar.dart';
import 'package:fujin/pages/common/goals_notifier.dart';
import 'package:fujin/pages/common/title_text.dart';
import 'package:fujin/pages/journal/journal_notifier.dart';
import 'package:fujin/pages/sending/entry_choices.dart';
import 'package:fujin/pages/sending/send_text.dart';
import 'package:fujin/pages/sending/sheets/match_sheet.dart';
import 'package:fujin/pages/sending/sheets/own_copy_sheet.dart';
import 'package:fujin/pages/sending/sheets/weight_sheet.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FoodView extends HookConsumerWidget {
  const FoodView({
    required this.initial,
    required this.onBack,
    required this.onLeave,
    this.barcode,
    this.barcodeToLink,
    super.key,
  });

  static const _decimals = 1;

  final AddDraft initial;
  final String? barcode;
  final String? barcodeToLink;
  final VoidCallback onBack;
  final ValueChanged<AddedFood> onLeave;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formProvider = addFormProvider(initial);
    final form = ref.watch(formProvider);
    final notifier = ref.read(formProvider.notifier);
    final write = ref.watch(addWriteProvider);
    final writer = ref.read(addWriteProvider.notifier);
    final goals = ref.watch(goalsProvider);
    final draft = form.draft;
    final entry = draft.entry;
    final planned = form.planned;
    final day = switch (ref.watch(journalProvider(draft.date)).value?.diary) {
      final diary? => DayNutrients.ofEntries(diary.entries),
      null => null,
    };
    final mealNames = ref.watch(mealNamesProvider).value ?? const <String>[];
    final food = DayNutrients.ofEntries([entry]);
    final before = switch (form.changedFrom) {
      final changed? => draft.withFood(changed),
      null => null,
    };
    final running = write is AddWriteRunning;

    ref.listen(addWriteProvider, (previous, next) {
      if (next case AddWriteDone(:final added)) onLeave(added);
    });

    EntryChoices choices(PlannedEntry planned) => (
      choose: (candidate) => notifier.choose(planned.choose(candidate)),
      ownCopy: () => notifier.choose(planned.asOwnCopy()),
      weigh: (gramsPerUnit) => notifier.choose(planned.weighing(gramsPerUnit)),
      skip: null,
    );

    Future<void> chooseEkklo() async {
      final current = ref.read(formProvider).planned;
      if (current == null) return;
      switch (current.choice) {
        case SendAsOwnCopy(reuse: null):
          await showOwnCopySheet(
            context,
            planned: current,
            choices: choices(current),
          );
        case SendToEkkloFood() || SendAsOwnCopy() || SkipEntry():
          await showMatchSheet(
            context,
            planned: current,
            choices: choices(current),
          );
      }
      if (!context.mounted) return;
      if (ref.read(formProvider).planned
          case PlannedEntry(
                choice: SendToEkkloFood(weight: UnitWeight.estimated),
              ) &&
              final chosen) {
        await showWeightSheet(
          context,
          planned: chosen,
          choices: choices(chosen),
        );
      }
    }

    Future<void> add() async {
      final current = ref.read(formProvider);
      if (current.planned case final planned?) {
        final outcome = await writer.add(
          current.draft,
          planned,
          barcodeToLink: barcodeToLink,
        );
        if (outcome case FoodChanged(:final after)) notifier.reload(after);
      }
    }

    Future<void> undo() async {
      switch (await writer.undo()) {
        case StillInMfp(:final error) || NotUndone(:final error):
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showProblem(context.intl, ReadProblem.of(error));
          }
        case Undone() || null:
          break;
      }
    }

    Future<bool> signedIn(FujinRoute route) async =>
        await context.push<bool>(route.path) ?? false;

    Future<void> signInToWrite(FujinRoute route) async {
      if (!await signedIn(route)) return;
      switch (ref.read(addWriteProvider)) {
        case AddWriteEkkloFailed(:final added):
          await writer.retryEkklo(added);
        case AddWriteFailed():
          writer.dismiss();
          await add();
        case AddWriteIdle() || AddWriteRunning() || AddWriteDone():
          break;
      }
    }

    Future<void> signInToPlan() async {
      if (await signedIn(FujinRoute.ekkloSignIn)) await notifier.retryPlan();
    }

    void back() {
      switch (ref.read(addWriteProvider)) {
        case AddWriteRunning() || AddWriteEkkloFailed(undoing: true):
          break;
        case AddWriteEkkloFailed(:final added) || AddWriteDone(:final added):
          onLeave(added);
        case AddWriteIdle() || AddWriteFailed():
          onBack();
      }
    }

    final side = switch (planned) {
      final planned? => EkkloSide.of(planned),
      null => null,
    };
    final (primaryLabel, onPrimary) = switch ((side, before)) {
      (EkkloSide.toChoose, _) => (
        context.intl.addChooseEkkloFood,
        () => unawaited(chooseEkklo()),
      ),
      (_, _?) => (context.intl.addConfirmAndAdd, () => unawaited(add())),
      (_, null) => (context.intl.addToBoth, () => unawaited(add())),
    };
    final grams = switch (entryGrams(entry)) {
      final grams? => SendText.grams(context.intl, grams),
      null => EntryText.serving(context.intl, entry),
    };
    final dayTitle = TitleText.capitalized(context.intl.journalDay(draft.date));

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) back();
      },
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FlowHeader(
                title: context.intl.addToMeal(draft.mfpMealName),
                subtitle: dayTitle,
                onBack: back,
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(bottom: FujinSpace.s4),
                  children: [
                    if (before case final before?) ...[
                      FoodChangedBanner(
                        before: _perServing(before),
                        after: _perServing(draft),
                        serving: AddText.serving(
                          context.intl,
                          draft.servingSize,
                        ),
                      ),
                      const SizedBox(height: FujinSpace.s3),
                    ],
                    FoodIdentity(food: draft.food, barcode: barcode),
                    const SizedBox(height: FujinSpace.s4),
                    AddSectionLabel(label: context.intl.addServingSize),
                    const SizedBox(height: FujinSpace.s2),
                    ServingField(
                      servings: draft.food.servingSizes,
                      selected: draft.servingSize,
                      onSelected: notifier.serving,
                    ),
                    const SizedBox(height: FujinSpace.s4),
                    AddSectionLabel(label: context.intl.addServings),
                    const SizedBox(height: FujinSpace.s2),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: FujinSize.screenMargin,
                      ),
                      child: ServingsPicker(
                        servings: draft.servings,
                        onServings: notifier.servings,
                      ),
                    ),
                    const SizedBox(height: FujinSpace.s3),
                    MealDateRow(
                      meal: draft.mfpMealName,
                      meals: mealNames,
                      date: draft.date,
                      onMeal: notifier.meal,
                      onDate: notifier.date,
                    ),
                    const SizedBox(height: FujinSpace.s3),
                    NutritionCard(
                      servingLine: AddText.forServing(context.intl, draft),
                      food: food,
                      day: day,
                      goals: goals,
                      changed: switch (before) {
                        final before? => _changed(before, draft),
                        null => const {},
                      },
                      onMyDay: () => unawaited(
                        showMyDaySheet(
                          context,
                          subtitle: context.intl.addDaySubtitle(
                            dayTitle,
                            draft.food.description,
                            grams,
                          ),
                          entry: entry,
                          day: day,
                          goals: goals,
                        ),
                      ),
                    ),
                    const SizedBox(height: FujinSpace.s3),
                    EkkloSummaryCard(
                      planned: planned,
                      problem: form.planProblem,
                      onTap: () => unawaited(chooseEkklo()),
                      onRetry: () => unawaited(notifier.retryPlan()),
                      onSignIn: () => unawaited(signInToPlan()),
                    ),
                    const SizedBox(height: FujinSpace.s3),
                    Text(
                      context.intl.addWriteOrder,
                      textAlign: TextAlign.center,
                      style: FujinText.inter12Regular.copyWith(
                        color: FujinColorRole.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                height: FujinStroke.card,
                thickness: FujinStroke.card,
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    FujinSize.screenMargin,
                    FujinSpace.s3,
                    FujinSize.screenMargin,
                    FujinSpace.s4,
                  ),
                  child: FilledButton(
                    onPressed: switch ((planned, running)) {
                      (_?, false) => onPrimary,
                      _ => null,
                    },
                    child: Text(primaryLabel),
                  ),
                ),
              ),
            ],
          ),
          Positioned.fill(
            child: WritePanel(
              state: write,
              draft: draft,
              actions: (
                retry: () => unawaited(add()),
                retryEkklo: () {
                  if (write case AddWriteEkkloFailed(:final added)) {
                    unawaited(writer.retryEkklo(added));
                  }
                },
                undo: () => unawaited(undo()),
                dismiss: writer.dismiss,
                signIn: (route) => unawaited(signInToWrite(route)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static double _perServing(AddDraft draft) => DayNutrients.ofEntries([
    draft.copyWith(servings: AddDraft.oneServing).entry,
  ]).amount(Nutrient.kilocalories);

  static Set<Nutrient> _changed(AddDraft before, AddDraft after) {
    final was = DayNutrients.ofEntries([before.entry]);
    final now = DayNutrients.ofEntries([after.entry]);
    return {
      for (final nutrient in Nutrient.values)
        if (was.amount(nutrient).toStringAsFixed(_decimals) !=
            now.amount(nutrient).toStringAsFixed(_decimals))
          nutrient,
    };
  }
}
