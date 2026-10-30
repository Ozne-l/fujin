import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/fujin_route.dart';
import 'package:fujin/app/providers.dart';
import 'package:fujin/app/theme/fujin_theme.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/data/entries/logged_entry.dart';
import 'package:fujin/domain/adding/add_draft.dart';
import 'package:fujin/domain/adding/ekklo_side.dart';
import 'package:fujin/domain/comparison/entry_quantity.dart';
import 'package:fujin/domain/comparison/entry_status.dart';
import 'package:fujin/domain/editing/draft_changes.dart';
import 'package:fujin/domain/editing/edit_outcome.dart';
import 'package:fujin/domain/editing/ekklo_edit.dart';
import 'package:fujin/domain/journal/day_nutrients.dart';
import 'package:fujin/domain/journal/journal_read.dart';
import 'package:fujin/domain/journal/read_problem.dart';
import 'package:fujin/domain/sending/nutrient.dart';
import 'package:fujin/domain/sending/planned_entry.dart';
import 'package:fujin/domain/sending/send_choice.dart';
import 'package:fujin/domain/sending/unit_weight.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/adding/add_form_notifier.dart';
import 'package:fujin/pages/adding/add_text.dart';
import 'package:fujin/pages/adding/edit_text.dart';
import 'package:fujin/pages/adding/food_view_mode.dart';
import 'package:fujin/pages/adding/widgets/add_section_label.dart';
import 'package:fujin/pages/adding/widgets/edit_food_header.dart';
import 'package:fujin/pages/adding/widgets/ekklo_summary_card.dart';
import 'package:fujin/pages/adding/widgets/food_changed_banner.dart';
import 'package:fujin/pages/adding/widgets/food_identity.dart';
import 'package:fujin/pages/adding/widgets/meal_date_row.dart';
import 'package:fujin/pages/adding/widgets/my_day_sheet.dart';
import 'package:fujin/pages/adding/widgets/nutrition_card.dart';
import 'package:fujin/pages/adding/widgets/serving_field.dart';
import 'package:fujin/pages/adding/widgets/servings_picker.dart';
import 'package:fujin/pages/common/entry_text.dart';
import 'package:fujin/pages/common/flow_header.dart';
import 'package:fujin/pages/common/fujin_snack_bar.dart';
import 'package:fujin/pages/common/glass_fill.dart';
import 'package:fujin/pages/common/glass_finish.dart';
import 'package:fujin/pages/common/goals_notifier.dart';
import 'package:fujin/pages/common/title_text.dart';
import 'package:fujin/pages/journal/entry_removal.dart';
import 'package:fujin/pages/journal/journal_notifier.dart';
import 'package:fujin/pages/journal/removal_reason.dart';
import 'package:fujin/pages/journal/remove_entry_notifier.dart';
import 'package:fujin/pages/journal/remove_entry_state.dart';
import 'package:fujin/pages/journal/selected_day.dart';
import 'package:fujin/pages/journal/widgets/remove_sheet.dart';
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
    required this.mode,
    required this.onBack,
    this.barcode,
    super.key,
  });

  static const _decimals = 1;

  final AddDraft initial;
  final FoodViewMode mode;
  final String? barcode;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formProvider = addFormProvider(initial);
    final form = ref.watch(formProvider);
    final notifier = ref.read(formProvider.notifier);
    final editing = switch (mode) {
      final EditingFood editing => editing,
      AddingFood() => null,
    };
    final saving = useRef(false);
    final original = editing?.original;
    final originalJournal = switch (original) {
      final original? => ref.watch(journalProvider(original.logged.entry.date)),
      null => null,
    };
    final readOnly = switch (originalJournal) {
      final journal? => EditText.readOnly(context.intl, switch (journal) {
        AsyncValue(:final error?) => ReadProblem.of(error),
        AsyncValue(value: MfpOnly(:final ekkloProblem)) => ekkloProblem,
        AsyncValue(value: EkkloOnly(:final mfpProblem)) => mfpProblem,
        AsyncValue() => null,
      }),
      null => null,
    };
    final today = ref.watch(todayProvider);
    final goals = ref.watch(goalsProvider);
    final draft = form.draft;
    final entry = draft.entry;
    final planned = form.planned;
    final read = ref.watch(journalProvider(draft.date)).value;
    final day = switch (read?.diaryMeals) {
      final meals? => DayNutrients.ofEntries([
        for (final meal in meals)
          for (final logged in meal.entries)
            if (original == null || logged.entry.id != original.entryId) logged,
      ]),
      null => null,
    };
    final mealNames = ref.watch(mealNamesProvider).value ?? const <String>[];
    final food = DayNutrients.ofEntries([entry]);
    final banner = switch (editing) {
      EditingFood(newVersion: true, :final original) => (
        before:
            DayNutrients.ofEntries([
              original.logged,
            ]).amount(Nutrient.kilocalories) /
            original.logged.entry.servings,
        after: _perServing(initial),
        serving: AddText.serving(context.intl, initial.servingSize),
        changed: _changed(
          original.logged,
          initial.copyWith(servings: original.logged.entry.servings).entry,
        ),
      ),
      _ => null,
    };
    final linked = switch (original?.status) {
      InEkklo() || ToUpdate() => true,
      ToSend() || null => false,
    };
    final changes = switch (original) {
      final original? => draftChanges(draft, original.logged),
      null => true,
    };

    ref.listen(removeEntryProvider, (previous, next) {
      if (next case RemoveEntryDone(
        :final removal,
      ) when removal.entryId == editing?.entryId) {
        onBack();
      }
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

    void add() {
      final current = ref.read(formProvider);
      if (current.planned case final planned? when !saving.value) {
        saving.value = true;
        switch (mode) {
          case AddingFood(:final barcodeToLink, :final onLeave):
            onLeave(
              ref
                  .read(addFoodServiceProvider)
                  .add(current.draft, planned, barcodeToLink: barcodeToLink),
            );
          case EditingFood(:final entryId, :final onLeave):
            switch (ref
                .read(editEntryServiceProvider)
                .save(current.draft, planned, entryId: entryId)) {
              case NotEdited(:final error):
                saving.value = false;
                ScaffoldMessenger.of(context).showWriteProblem(
                  context.intl,
                  error,
                  ref.read(appEnvironmentProvider),
                );
              case final Edited edited:
                onLeave(edited);
            }
        }
      }
    }

    void remove() {
      if (editing case EditingFood(:final entryId, :final original)) {
        unawaited(
          showRemoveSheet(
            context,
            removal: EntryRemoval(
              entryId: entryId,
              entry: original.logged,
              reason: RemovalReason.delete,
            ),
            inEkklo: linked,
          ),
        );
      }
    }

    Future<void> signInToPlan() async {
      if (await context.push<bool>(FujinRoute.ekkloSignIn.path) ?? false) {
        await notifier.retryPlan();
      }
    }

    final side = switch (planned) {
      final planned? => EkkloSide.of(planned),
      null => null,
    };
    final (primaryLabel, onPrimary) = switch ((side, mode)) {
      (EkkloSide.toChoose, AddingFood()) => (
        context.intl.addChooseEkkloFood,
        () => unawaited(chooseEkklo()),
      ),
      (EkkloSide.toChoose, EditingFood()) when linked => (
        context.intl.addChooseEkkloFood,
        () => unawaited(chooseEkklo()),
      ),
      (_, EditingFood()) => (
        switch (linked) {
          true => context.intl.editSaveBoth,
          false => context.intl.editSaveMfpOnly,
        },
        add,
      ),
      (_, AddingFood()) => (context.intl.addToBoth, add),
    };
    final ekkloEdit = switch ((original, planned, originalJournal?.value)) {
      (final original?, final planned?, final read?) => EkkloEdit.of(
        original: original,
        planned: planned,
        ekkloMeals: switch (read) {
          BothSides(:final day) => day.ekkloMeals,
          MfpOnly() || EkkloOnly() => const [],
        },
        changed: changes,
      ),
      _ => null,
    };
    final grams = switch (entryGrams(entry.entry)) {
      final grams? => SendText.grams(context.intl, grams),
      null => EntryText.serving(context.intl, entry),
    };
    final dayTitle = TitleText.capitalized(context.intl.journalDay(draft.date));

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) onBack();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          switch (original) {
            final original? => EditFoodHeader(
              entry: original.logged,
              onBack: onBack,
            ),
            null => FlowHeader(
              title: context.intl.addToMeal(draft.mfpMealName),
              subtitle: dayTitle,
              onBack: onBack,
            ),
          },
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: FujinSpace.s4),
              children: [
                if (banner case (
                  :final before,
                  :final after,
                  :final serving,
                  changed: _,
                )) ...[
                  FoodChangedBanner(
                    before: before,
                    after: after,
                    serving: serving,
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
                  lastDay: switch (mode) {
                    EditingFood() => today,
                    AddingFood() => null,
                  },
                ),
                const SizedBox(height: FujinSpace.s3),
                NutritionCard(
                  servingLine: AddText.forServing(context.intl, draft),
                  food: food,
                  day: day,
                  goals: goals,
                  changed: banner?.changed ?? const {},
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
                  summary: switch (ekkloEdit) {
                    final ekkloEdit? => EditText.ekkloSummary(
                      context.intl,
                      ekkloEdit,
                    ),
                    null => null,
                  },
                ),
                const SizedBox(height: FujinSpace.s3),
                Text(
                  context.intl.addWriteOrder,
                  textAlign: TextAlign.center,
                  style: FujinText.inter12Regular.copyWith(
                    color: context.colors.textSecondary,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: FujinSpace.s3,
                children: [
                  if (readOnly case final readOnly?)
                    Text(
                      readOnly,
                      textAlign: TextAlign.center,
                      style: FujinText.inter13Regular.copyWith(
                        color: context.colors.textSecondary,
                      ),
                    ),
                  FilledButton(
                    style: FujinTheme.floatingButtonStyle(context.colors),
                    onPressed: switch ((
                      planned,
                      readOnly,
                      changes || banner != null,
                    )) {
                      (_?, null, true) => onPrimary,
                      _ => null,
                    },
                    child: Text(primaryLabel),
                  ),
                  if ((mode, readOnly) case (EditingFood(), null))
                    OutlinedButton(
                      style: GlassFill.style(
                        context.colors,
                        GlassFinish.alert,
                      ).merge(FujinTheme.largeOutlinedButtonStyle),
                      onPressed: remove,
                      child: Text(switch (linked) {
                        true => context.intl.editDeleteBoth,
                        false => context.intl.editDeleteMfpOnly,
                      }),
                    ),
                ],
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

  static Set<Nutrient> _changed(LoggedEntry before, LoggedEntry after) {
    final was = DayNutrients.ofEntries([before]);
    final now = DayNutrients.ofEntries([after]);
    return {
      for (final nutrient in Nutrient.values)
        if (was.amount(nutrient).toStringAsFixed(_decimals) !=
            now.amount(nutrient).toStringAsFixed(_decimals))
          nutrient,
    };
  }
}
