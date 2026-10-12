import 'dart:async';

import 'package:fujin/app/providers.dart';
import 'package:fujin/domain/adding/add_draft.dart';
import 'package:fujin/domain/journal/read_problem.dart';
import 'package:fujin/domain/sending/planned_entry.dart';
import 'package:fujin/pages/adding/add_form.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

final NotifierProviderFamily<AddFormNotifier, AddForm, AddDraft>
addFormProvider = NotifierProvider.autoDispose
    .family<AddFormNotifier, AddForm, AddDraft>(AddFormNotifier.new);

final class AddFormNotifier extends Notifier<AddForm> {
  AddFormNotifier(this.initial);

  final AddDraft initial;

  @override
  AddForm build() {
    final form = AddForm(draft: initial);
    unawaited(_plan(form));
    return form;
  }

  void serving(MfpServingSize servingSize) =>
      _replan(state.draft.copyWith(servingSize: servingSize));

  void servings(double servings) => _replan(
    state.draft.copyWith(servings: servings),
    previous: state.planned,
  );

  void meal(String mfpMealName) => _replan(
    state.draft.copyWith(mfpMealName: mfpMealName),
    previous: state.planned,
  );

  void date(DateTime date) =>
      _replan(state.draft.copyWith(date: date), previous: state.planned);

  void choose(PlannedEntry planned) => state = state.copyWith(planned: planned);

  void reload(MfpFood after) {
    final form = AddForm(
      draft: state.draft.withFood(after),
      changedFrom: state.draft.food,
    );
    state = form;
    unawaited(_plan(form));
  }

  Future<void> retryPlan() {
    final form = AddForm(draft: state.draft, changedFrom: state.changedFrom);
    state = form;
    return _plan(form);
  }

  void _replan(AddDraft draft, {PlannedEntry? previous}) {
    final form = AddForm(draft: draft, changedFrom: state.changedFrom);
    state = form;
    unawaited(_plan(form, previous: previous));
  }

  Future<void> _plan(AddForm form, {PlannedEntry? previous}) async {
    try {
      final planned = await ref
          .read(addFoodServiceProvider)
          .plan(form.draft, previous: previous);
      if (ref.mounted && state == form) {
        state = form.copyWith(planned: planned);
      }
    } on Object catch (error) {
      if (ref.mounted && state == form) {
        state = form.copyWith(planProblem: ReadProblem.of(error));
      }
    }
  }
}
