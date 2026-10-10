import 'dart:async';

import 'package:checks/checks.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fujin/data/goals/goals.dart';
import 'package:fujin/data/hints/hint_repository.dart';
import 'package:fujin/domain/goals/day_goal_state.dart';
import 'package:fujin/pages/journal/widgets/day_ring.dart';
import 'package:fujin/pages/journal/widgets/nutrient_ring.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

import '../support/fake_backends.dart';
import '../support/fixtures.dart';
import '../support/in_memory_preferences.dart';
import '../support/pump_fujin.dart';

const _space = '\u202f';
const _bandHint = 'Glisse pour voir les semaines passées';
const _goals = Goals(
  kilocalories: 3000,
  protein: 160,
  carbohydrates: 400,
  fat: 70,
  fiber: 40,
);
final _monday = DateTime.utc(2026, 10, 5);
final _yesterday = DateTime.utc(2026, 10, 6);

Future<void> _pullToRefresh(WidgetTester tester) async {
  await tester.fling(
    find.byType(CustomScrollView),
    const Offset(0, 400),
    1000,
  );
  await tester.pumpAndSettle();
}

DayRing _ring(WidgetTester tester, String date) => tester.widget<DayRing>(
  find.ancestor(of: find.text(date), matching: find.byType(DayRing)),
);

double? _goalOf(WidgetTester tester, String label) => tester
    .widgetList<NutrientRing>(find.byType(NutrientRing))
    .singleWhere((ring) => ring.label == label)
    .goal;

Finder _rich(String text) => find.text(text, findRichText: true);

FilledButton _button(WidgetTester tester, String label) =>
    tester.widget<FilledButton>(
      find.ancestor(of: find.text(label), matching: find.byType(FilledButton)),
    );

void main() {
  testWidgets('counts what is left to send and to update on the button', (
    tester,
  ) async {
    await pumpFujin(
      tester,
      FakeBackends(
        mealNames: [breakfast, lunch],
        entries: [
          entry('E-1'),
          entry('E-2', food: rice),
          entry('E-3', meal: lunch, servings: 2),
        ],
        ekkloMeals: [
          meal('meal-1', [item('I-1')]),
        ],
      ),
    );

    check(
      find.text('Envoyer 2 aliments vers Ekklo').evaluate(),
    ).length.equals(1);
    check(find.text('1/2 dans Ekklo').evaluate()).length.equals(1);
  });

  testWidgets('says nothing is new only after a pull that changed nothing', (
    tester,
  ) async {
    final backends = FakeBackends(
      mealNames: [breakfast],
      entries: [entry('E-1')],
    );
    await pumpFujin(tester, backends);
    check(find.text('Rien de nouveau').evaluate()).isEmpty();

    backends.entries = [entry('E-1'), entry('E-2')];
    await _pullToRefresh(tester);
    check(find.text('Rien de nouveau').evaluate()).isEmpty();

    await _pullToRefresh(tester);
    check(find.text('Rien de nouveau').evaluate()).length.equals(1);
  });

  testWidgets('does not say nothing is new when Ekklo stops answering', (
    tester,
  ) async {
    final backends = FakeBackends(
      mealNames: [breakfast],
      entries: [entry('E-1')],
    );
    final store = await backends.ekkloTokenStore();
    await pumpFujin(tester, backends, ekklo: backends.ekkloWith(store));

    await store.write(FakeBackends.staleEkkloTokens);
    await _pullToRefresh(tester);

    check(find.text('Ta session Ekklo a expiré.').evaluate()).length.equals(1);
    check(find.text('Rien de nouveau').evaluate()).isEmpty();
  });

  testWidgets('shows the reading card until both apps answer', (
    tester,
  ) async {
    final gate = Completer<void>();
    final backends = FakeBackends(mealNames: [breakfast])..diaryGate = gate;
    await pumpFujin(tester, backends, goals: _goals);

    check(
      find.text("Lecture de MyFitnessPal\net d'Ekklo…").evaluate(),
    ).length.equals(1);
    check(_button(tester, 'Envoyer vers Ekklo').onPressed).isNull();

    gate.complete();
    await tester.pumpAndSettle();
    check(
      find.text("Lecture de MyFitnessPal\net d'Ekklo…").evaluate(),
    ).isEmpty();
  });

  group('with goals', () {
    testWidgets('rings each day against the kilocalorie goal', (tester) async {
      await pumpFujin(
        tester,
        FakeBackends(
          mealNames: [breakfast],
          entries: [
            entry('E-1', date: _monday, nutrients: nutrients(kcal: 2990)),
            entry('E-2', date: _yesterday, nutrients: nutrients(kcal: 3120)),
            entry('E-3', nutrients: nutrients(kcal: 1898)),
          ],
        ),
        goals: _goals,
      );

      check(_ring(tester, '5').state).equals(DayGoalState.reached);
      check(_ring(tester, '6').state).equals(DayGoalState.exceeded);
      check(_ring(tester, '7'))
        ..has((ring) => ring.state, 'state').equals(DayGoalState.inProgress)
        ..has((ring) => ring.selected, 'selected').isTrue();
      check(_ring(tester, '8').state).equals(DayGoalState.upcoming);
      check(
        _rich('1${_space}898 / 3${_space}000 kcal').evaluate(),
      ).length.equals(1);
    });

    testWidgets('shows a past day under the month with a way back to today', (
      tester,
    ) async {
      await pumpFujin(
        tester,
        FakeBackends(
          mealNames: [breakfast],
          entries: [
            entry('E-1', date: _yesterday, nutrients: nutrients(kcal: 3120)),
          ],
        ),
        goals: _goals,
      );

      await tester.tap(find.text('6'));
      await tester.pumpAndSettle();
      check(find.text('Octobre').evaluate()).length.equals(1);
      check(
        _rich('3${_space}120 / 3${_space}000 kcal').evaluate(),
      ).length.equals(1);

      await tester.tap(find.text("Aujourd'hui ›"));
      await tester.pumpAndSettle();
      check(find.text("Aujourd'hui").evaluate()).length.equals(1);
    });

    testWidgets('changes week when the band is swiped', (tester) async {
      await pumpFujin(tester, FakeBackends(mealNames: [breakfast]));

      await tester.fling(find.byType(PageView), const Offset(300, 0), 1000);
      await tester.pumpAndSettle();

      check(find.text('Septembre').evaluate()).length.equals(1);
      check(_ring(tester, '30').selected).isTrue();
    });

    testWidgets('hints that the band slides on the first visit only', (
      tester,
    ) async {
      await pumpFujin(
        tester,
        FakeBackends(mealNames: [breakfast]),
        preferences: await inMemoryPreferences(shown: const []),
      );
      check(find.text(_bandHint).evaluate()).length.equals(1);

      await tester.pump(const Duration(seconds: 4));
      check(find.text(_bandHint).evaluate()).isEmpty();

      await tester.pumpWidget(const SizedBox());
      await pumpFujin(
        tester,
        FakeBackends(mealNames: [breakfast]),
        preferences: await HintRepository.openPreferences(),
      );
      check(find.text(_bandHint).evaluate()).isEmpty();
    });

    testWidgets('drops the band hint at the first swipe', (tester) async {
      await pumpFujin(
        tester,
        FakeBackends(mealNames: [breakfast]),
        preferences: await inMemoryPreferences(shown: const []),
      );

      await tester.fling(find.byType(PageView), const Offset(300, 0), 1000);
      await tester.pumpAndSettle();

      check(find.text(_bandHint).evaluate()).isEmpty();
    });

    testWidgets('leaves a nutrient without goal in a dashed circle', (
      tester,
    ) async {
      await pumpFujin(
        tester,
        FakeBackends(
          mealNames: [breakfast],
          entries: [entry('E-1', nutrients: nutrients(kcal: 500, carbs: 60))],
        ),
        goals: const Goals(kilocalories: 3000, protein: 160, fat: 70),
      );

      check(_goalOf(tester, 'Protéines')).equals(160);
      check(_goalOf(tester, 'Lipides')).equals(70);
      check(_goalOf(tester, 'Glucides')).isNull();
      check(_goalOf(tester, 'Fibres')).isNull();
      check(find.text('/ 160').evaluate()).length.equals(1);
      check(find.text('60').evaluate()).length.equals(1);
    });

    testWidgets('opens the day detail with both apps side by side', (
      tester,
    ) async {
      await pumpFujin(
        tester,
        FakeBackends(
          mealNames: [breakfast],
          entries: [
            entry(
              'E-1',
              nutrients: nutrients(kcal: 300, protein: 20, carbs: 30, fat: 10),
            ),
          ],
        ),
        goals: _goals,
      );

      await tester.tap(find.text('MyFitnessPal'));
      await tester.pumpAndSettle();

      check(find.text('Détail du jour').evaluate()).length.equals(1);
      check(
        find
            .text(
              '1 aliment sur 1 n’est pas encore dans Ekklo.\n'
              "MyFitnessPal ne donne pas toujours les fibres, d'où le ≥.",
            )
            .evaluate(),
      ).length.equals(1);
      check(find.text('≥ 0 g').evaluate()).length.equals(1);
    });
  });

  testWidgets('shows plain dates and a way to set goals without goals', (
    tester,
  ) async {
    await pumpFujin(
      tester,
      FakeBackends(
        mealNames: [breakfast],
        entries: [
          entry(
            'E-1',
            nutrients: nutrients(
              kcal: 500,
              protein: 30,
              carbs: 60,
              fat: 10,
              fiber: 5,
            ),
          ),
          entry(
            'E-2',
            food: rice,
            nutrients: nutrients(kcal: 300, protein: 20, carbs: 40, fat: 5),
          ),
        ],
      ),
    );

    check(_ring(tester, '6').state).equals(DayGoalState.noGoal);
    check(find.byType(NutrientRing).evaluate()).isEmpty();
    check(find.text('P 50 · G 100 · L 15 · F ≥ 5').evaluate()).length.equals(1);

    await tester.tap(find.text('Définir mes objectifs ›'));
    await tester.pumpAndSettle();
    check(find.text('Tes objectifs').evaluate()).length.equals(1);
  });

  testWidgets('says each meal is empty on a day with nothing logged', (
    tester,
  ) async {
    await pumpFujin(
      tester,
      FakeBackends(mealNames: [breakfast, lunch]),
      goals: _goals,
    );

    check(find.text('Rien pour l’instant').evaluate()).length.equals(2);
    check(_rich('0 kcal · aucun aliment').evaluate()).length.equals(1);
    check(find.byType(FilledButton).evaluate()).isEmpty();
    check(_ring(tester, '7').progress).equals(0);
  });

  testWidgets('drops the send button once everything is in Ekklo', (
    tester,
  ) async {
    await pumpFujin(
      tester,
      FakeBackends(
        mealNames: [breakfast],
        entries: [entry('E-1')],
        ekkloMeals: [
          meal('meal-1', [item('I-1')]),
        ],
      ),
      links: [link('E-1', 'I-1')],
      goals: _goals,
    );

    check(find.byType(FilledButton).evaluate()).isEmpty();
    check(_rich('0 kcal · 1 aliment sur 1 ›').evaluate()).length.equals(1);
  });

  testWidgets('keeps MyFitnessPal readable when the Ekklo session expired', (
    tester,
  ) async {
    final backends = FakeBackends(
      mealNames: [breakfast],
      entries: [entry('E-1', nutrients: nutrients(kcal: 496))],
    );
    final store = InMemoryEkkloTokenStore();
    await store.write(FakeBackends.staleEkkloTokens);
    await pumpFujin(
      tester,
      backends,
      ekklo: backends.ekkloWith(store),
      goals: _goals,
    );

    check(find.text('Ta session Ekklo a expiré.').evaluate()).length.equals(1);
    check(find.text('Se reconnecter à Ekklo').evaluate()).length.equals(1);
    check(
      _rich('496 / 3${_space}000 kcal').evaluate(),
    ).length.equals(1);
    check(_button(tester, 'Envoyer vers Ekklo').onPressed).isNull();

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -400));
    await tester.pumpAndSettle();
    check(find.text('Ekklo indisponible').evaluate()).length.equals(1);
  });

  testWidgets('keeps Ekklo readable when the MyFitnessPal session expired', (
    tester,
  ) async {
    final backends = FakeBackends(
      mealNames: [breakfast],
      ekkloMeals: [
        meal('meal-1', [item('I-1'), item('I-2')]),
      ],
    );
    final store = InMemoryMfpSessionStore();
    await store.write(FakeBackends.refusedMfpSession);
    await pumpFujin(
      tester,
      backends,
      mfp: backends.mfpWith(store),
      goals: const Goals(kilocalories: 3000),
    );

    check(
      find.text('Ta session MyFitnessPal a expiré.').evaluate(),
    ).length.equals(1);
    check(
      find.text('Objectif · 3${_space}000 kcal').evaluate(),
    ).length.equals(1);
    check(_rich('0 kcal · 2 aliments ›').evaluate()).length.equals(1);
  });

  group('offline', () {
    testWidgets('keeps the last figures with their time and retries alone', (
      tester,
    ) async {
      final backends = FakeBackends(
        mealNames: [breakfast],
        entries: [entry('E-1', nutrients: nutrients(kcal: 496))],
      );
      await pumpFujin(tester, backends, goals: _goals);

      backends
        ..mfpReachable = false
        ..ekkloReachable = false;
      await _pullToRefresh(tester);

      check(find.text('Hors ligne').evaluate()).length.equals(1);
      check(
        find
            .text(
              'Les chiffres datent de 20:00. '
              'Fūjin réessaie dès que le réseau revient.',
            )
            .evaluate(),
      ).length.equals(1);
      check(find.text('496 kcal à 20:00').evaluate()).length.equals(1);

      backends
        ..mfpReachable = true
        ..ekkloReachable = true;
      await tester.pump(const Duration(seconds: 15));
      await tester.pumpAndSettle();
      check(find.text('Hors ligne').evaluate()).isEmpty();
    });

    testWidgets('says there is no connection on a first read offline', (
      tester,
    ) async {
      final backends = FakeBackends(mealNames: [breakfast]);
      final mfp = await backends.mfp();
      backends.mfpReachable = false;
      await pumpFujin(tester, backends, mfp: mfp);

      check(
        find.text('Pas de connexion internet.').evaluate(),
      ).length.equals(1);
      check(
        find.text('Fūjin réessaie dès que le réseau revient.').evaluate(),
      ).length.equals(1);
    });
  });
}
