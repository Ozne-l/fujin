import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fujin/app/fujin_route.dart';
import 'package:fujin/app/providers.dart';
import 'package:fujin/app/theme/fujin_theme.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/adding/add_draft.dart';
import 'package:fujin/domain/adding/add_outcome.dart';
import 'package:fujin/domain/adding/ekklo_side.dart';
import 'package:fujin/domain/comparison/entry_quantity.dart';
import 'package:fujin/domain/comparison/entry_status.dart';
import 'package:fujin/domain/editing/draft_changes.dart';
import 'package:fujin/domain/editing/edit_outcome.dart';
import 'package:fujin/domain/editing/ekklo_edit.dart';
import 'package:fujin/domain/editing/remove_outcome.dart';
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
import 'package:fujin/pages/adding/add_write_notifier.dart';
import 'package:fujin/pages/adding/add_write_state.dart';
import 'package:fujin/pages/adding/edit_text.dart';
import 'package:fujin/pages/adding/edit_write_notifier.dart';
import 'package:fujin/pages/adding/edit_write_state.dart';
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
import 'package:fujin/pages/adding/widgets/write_panel.dart';
import 'package:fujin/pages/common/entry_text.dart';
import 'package:fujin/pages/common/flow_header.dart';
import 'package:fujin/pages/common/fujin_snack_bar.dart';
import 'package:fujin/pages/common/fujin_spinner.dart';
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
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

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
    final write = ref.watch(addWriteProvider);
    final writer = ref.read(addWriteProvider.notifier);
    final edit = ref.watch(editWriteProvider);
    final editor = ref.read(editWriteProvider.notifier);
    final original = editing?.original;
    final originalJournal = switch (original) {
      final original? => ref.watch(journalProvider(original.entry.date)),
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
    final day = switch (ref.watch(journalProvider(draft.date)).value?.diary) {
      final diary? => DayNutrients.ofEntries([
        for (final logged in diary.entries)
          if (original == null || logged.id != original.entry.id) logged,
      ]),
      null => null,
    };
    final mealNames = ref.watch(mealNamesProvider).value ?? const <String>[];
    final food = DayNutrients.ofEntries([entry]);
    final banner = switch ((form.changedFrom, editing)) {
      (final changed?, _) => (
        before: _perServing(draft.withFood(changed)),
        after: _perServing(draft),
        serving: AddText.serving(context.intl, draft.servingSize),
        changed: _changed(draft.withFood(changed).entry, entry),
      ),
      (null, EditingFood(newVersion: true, :final original)) => (
        before:
            DayNutrients.ofEntries([
              original.entry,
            ]).amount(Nutrient.kilocalories) /
            original.entry.servings,
        after: _perServing(initial),
        serving: AddText.serving(context.intl, initial.servingSize),
        changed: _changed(
          original.entry,
          initial.copyWith(servings: original.entry.servings).entry,
        ),
      ),
      _ => null,
    };
    final running = switch (mode) {
      AddingFood() => write is AddWriteRunning,
      EditingFood() => edit is EditWriteRunning,
    };
    final linked = switch (original?.status) {
      InEkklo() || ToUpdate() => true,
      ToSend() || null => false,
    };
    final changes = switch (original) {
      final original? => draftChanges(draft, original.entry),
      null => true,
    };

    ref
      ..listen(addWriteProvider, (previous, next) {
        if ((next, mode) case (
          AddWriteDone(:final added),
          AddingFood(:final onLeave),
        )) {
          onLeave(added);
        }
      })
      ..listen(removeEntryProvider, (previous, next) {
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

    Future<void> add() async {
      final current = ref.read(formProvider);
      if (current.planned case final planned?) {
        switch (mode) {
          case AddingFood(:final barcodeToLink):
            final outcome = await writer.add(
              current.draft,
              planned,
              barcodeToLink: barcodeToLink,
            );
            if (outcome case FoodChanged(:final after)) notifier.reload(after);
          case EditingFood(:final entryId, :final original, :final onLeave):
            final environment = ref.read(appEnvironmentProvider);
            switch (await editor.save(
              current.draft,
              planned,
              entryId: entryId,
              date: original.entry.date,
            )) {
              case EditFoodChanged(:final after):
                notifier.reload(after);
              case NotEdited(:final error):
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showWriteProblem(context.intl, error, environment);
                }
              case final EditOutcome written:
                if (context.mounted) onLeave(written);
              case null:
                break;
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
              entry: original.entry,
              reason: RemovalReason.delete,
            ),
            inEkklo: linked,
          ),
        );
      }
    }

    Future<void> undo() async {
      final environment = ref.read(appEnvironmentProvider);
      switch (await writer.undo()) {
        case StillInMfp(:final error) || NotRemoved(:final error):
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showWriteProblem(context.intl, error, environment);
          }
        case Removed() || null:
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
      switch ((mode, ref.read(addWriteProvider), ref.read(editWriteProvider))) {
        case (EditingFood(), _, EditWriteRunning()):
          break;
        case (EditingFood(), _, _):
          onBack();
        case (AddingFood(), AddWriteRunning(), _) ||
            (AddingFood(), AddWriteEkkloFailed(undoing: true), _):
          break;
        case (
          AddingFood(:final onLeave),
          AddWriteEkkloFailed(:final added) || AddWriteDone(:final added),
          _,
        ):
          onLeave(added);
        case (AddingFood(), AddWriteIdle() || AddWriteFailed(), _):
          onBack();
      }
    }

    final side = switch (planned) {
      final planned? => EkkloSide.of(planned),
      null => null,
    };
    final (primaryLabel, onPrimary) = switch ((side, banner, mode)) {
      (EkkloSide.toChoose, _, AddingFood()) => (
        context.intl.addChooseEkkloFood,
        () => unawaited(chooseEkklo()),
      ),
      (EkkloSide.toChoose, _, EditingFood()) when linked => (
        context.intl.addChooseEkkloFood,
        () => unawaited(chooseEkklo()),
      ),
      (_, _, EditingFood()) => (
        switch (linked) {
          true => context.intl.editSaveBoth,
          false => context.intl.editSaveMfpOnly,
        },
        () => unawaited(add()),
      ),
      (_, _?, AddingFood()) => (
        context.intl.addConfirmAndAdd,
        () => unawaited(add()),
      ),
      (_, null, AddingFood()) => (
        context.intl.addToBoth,
        () => unawaited(add()),
      ),
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
              switch (original) {
                final original? => EditFoodHeader(
                  entry: original.entry,
                  onBack: back,
                ),
                null => FlowHeader(
                  title: context.intl.addToMeal(draft.mfpMealName),
                  subtitle: dayTitle,
                  onBack: back,
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
                      switch ((mode, running)) {
                        (EditingFood(), true) => FilledButton.icon(
                          style: FujinTheme.floatingButtonStyle(context.colors),
                          onPressed: null,
                          icon: const FujinSpinner.button(),
                          label: Text(primaryLabel),
                        ),
                        _ => FilledButton(
                          style: FujinTheme.floatingButtonStyle(context.colors),
                          onPressed: switch ((
                            planned,
                            running,
                            readOnly,
                            changes || banner != null,
                          )) {
                            (_?, false, null, true) => onPrimary,
                            _ => null,
                          },
                          child: Text(primaryLabel),
                        ),
                      },
                      if ((mode, readOnly) case (EditingFood(), null))
                        OutlinedButton(
                          style: GlassFill.style(
                            context.colors,
                            GlassFinish.alert,
                          ).merge(FujinTheme.largeOutlinedButtonStyle),
                          onPressed: switch (running) {
                            true => null,
                            false => remove,
                          },
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
          if (mode case AddingFood())
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

  static Set<Nutrient> _changed(MfpFoodEntry before, MfpFoodEntry after) {
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
