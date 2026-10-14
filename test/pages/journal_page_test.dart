import 'dart:async';
import 'dart:io' show HttpStatus;

import 'package:checks/checks.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fujin/app/providers.dart';
import 'package:fujin/data/goals/goals.dart';
import 'package:fujin/data/links/sent_link_repository.dart';
import 'package:fujin/data/preferences/fujin_preferences.dart';
import 'package:fujin/domain/goals/day_goal_state.dart';
import 'package:fujin/pages/adding/add_search_notifier.dart';
import 'package:fujin/pages/common/gold_volute.dart';
import 'package:fujin/pages/common/souffle_refresh.dart';
import 'package:fujin/pages/journal/widgets/day_ring.dart';
import 'package:fujin/pages/journal/widgets/journal_header.dart';
import 'package:fujin/pages/journal/widgets/nutrient_ring.dart';
import 'package:fujin/pages/journal/widgets/week_band.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

import '../support/fake_backends.dart';
import '../support/fixtures.dart';
import '../support/in_memory_preferences.dart';
import '../support/pump_fujin.dart';

const _space = '\u202f';
const _souffleStep = Duration(milliseconds: 500);
const _dragFrame = Duration(milliseconds: 16);

final Finder _souffleDisc = find.descendant(
  of: find.descendant(
    of: find.byType(SouffleRefresh),
    matching: find.byType(Positioned),
  ),
  matching: find.byType(GoldVolute),
);

double _souffleOpacity(WidgetTester tester) => tester
    .widgetList<Opacity>(
      find.ancestor(of: _souffleDisc, matching: find.byType(Opacity)),
    )
    .fold(1, (opacity, layer) => opacity * layer.opacity);

Matrix4 _souffleTurn(WidgetTester tester) => tester
    .widget<Transform>(
      find.ancestor(of: _souffleDisc, matching: find.byType(Transform)).first,
    )
    .transform;

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

Future<void> _pull(WidgetTester tester) =>
    tester.fling(find.byType(CustomScrollView), const Offset(0, 400), 1000);

Future<void> _pullToRefresh(WidgetTester tester) async {
  await _pull(tester);
  await tester.pumpAndSettle();
}

const _mondayDate = '2026-10-05';
const _pastHalfPage = 0.6;
const _mfpNotResponding = 'MyFitnessPal ne répond pas.';

int _diaryReads(FakeBackends backends, String date) => backends.requests
    .where(
      (request) =>
          request.url.path == '/v2/diary' &&
          request.url.queryParameters['entry_date'] == date,
    )
    .length;

Future<void> _swipeWeekBack(WidgetTester tester) async {
  await tester.fling(find.byType(PageView), const Offset(300, 0), 1000);
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

void _tallView(
  WidgetTester tester, {
  Size size = const Size(800, 1800),
  double pixelRatio = 1,
}) {
  addTearDown(tester.view.reset);
  tester.view
    ..physicalSize = size
    ..devicePixelRatio = pixelRatio;
}

Future<void> _tap(WidgetTester tester, Finder target) async {
  await tester.ensureVisible(target);
  await tester.pumpAndSettle();
  await tester.tap(target);
  await tester.pumpAndSettle();
}

final MfpFood _basmati = mfpFood(
  rice,
  description: 'Riz basmati',
  brand: 'Taureau Ailé',
  nutrients: nutrients(kcal: 350, protein: 8.5, carbs: 77, fat: 0.9),
);

FakeBackends _basmatiBackends() => FakeBackends(
  mealNames: [breakfast, lunch],
  mfpFoods: [_basmati],
  mfpSearches: {
    'riz basmati': [_basmati],
  },
);

Future<void> _addBasmatiToLunch(WidgetTester tester) async {
  await _tap(tester, find.text('Ajouter un aliment').last);
  await tester.enterText(find.byType(TextField), 'riz basmati');
  await tester.pump(AddSearchNotifier.typingPause);
  await tester.pumpAndSettle();
  await _tap(tester, find.text('Riz basmati').first);
  await _tap(tester, find.text('Ajouter à MFP et Ekklo'));
}

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

  testWidgets('shows the Souffle disc while a pull refreshes', (tester) async {
    final backends = FakeBackends(
      mealNames: [breakfast],
      entries: [entry('E-1')],
    );
    await pumpFujin(tester, backends);
    check(_souffleDisc.evaluate()).isEmpty();

    final gate = Completer<void>();
    backends.diaryGate = gate;
    await _pull(tester);
    await tester.pump(_souffleStep);
    await tester.pump(_souffleStep);
    check(_souffleDisc.evaluate()).length.equals(1);
    check(find.byType(CircularProgressIndicator).evaluate()).isEmpty();

    gate.complete();
    await tester.pumpAndSettle();
    check(_souffleDisc.evaluate()).isEmpty();
  });

  testWidgets('spins the Souffle disc until the refresh ends', (tester) async {
    final backends = FakeBackends(
      mealNames: [breakfast],
      entries: [entry('E-1')],
    );
    await pumpFujin(tester, backends);

    final gate = Completer<void>();
    backends.diaryGate = gate;
    await _pull(tester);
    await tester.pump(_souffleStep);
    await tester.pump(_souffleStep);
    final turn = _souffleTurn(tester);
    await tester.pump(_souffleStep);
    check(_souffleTurn(tester)).not((later) => later.equals(turn));

    gate.complete();
    await tester.pumpAndSettle();
  });

  testWidgets('keeps a food sent since the last read in Ekklo through the '
      'pull that reads it again', (tester) async {
    final backends = FakeBackends(
      mealNames: [breakfast],
      entries: [entry('E-1', food: skyr)],
    );
    await pumpFujin(tester, backends, goals: _goals);
    final links = SentLinkRepository(
      ProviderScope.containerOf(
        tester.element(find.byType(JournalHeader)),
      ).read(databaseProvider),
    )..add(link('E-1', 'I-1', food: skyr));
    final diaryGate = Completer<void>();
    final mealsGate = Completer<void>();
    backends
      ..ekkloMeals = [
        meal('meal-1', [item('I-1')]),
      ]
      ..diaryGate = diaryGate
      ..mealsGate = mealsGate;
    await _pull(tester);
    await tester.pump(_souffleStep);
    await tester.pump(_souffleStep);
    check(links.forDate(day)).length.equals(1);

    diaryGate.complete();
    mealsGate.complete();
    await tester.pumpAndSettle();
    check(links.forDate(day)).length.equals(1);
    check(find.byType(FilledButton).evaluate()).isEmpty();
  });

  testWidgets(
    'brings the Souffle disc down with an Android pull and rests it above '
    'the week band',
    (tester) async {
      _tallView(tester, size: const Size(1080, 2400), pixelRatio: 2);
      final backends = FakeBackends(
        mealNames: [breakfast],
        entries: [entry('E-1')],
      );
      await pumpFujin(tester, backends);
      final gate = Completer<void>();
      backends.diaryGate = gate;
      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(JournalHeader)),
      );
      final tops = <double>[];
      for (var step = 0; step < 4; step++) {
        for (var frame = 0; frame < 4; frame++) {
          await gesture.moveBy(const Offset(0, 10));
          await tester.pump(_dragFrame);
        }
        tops.add(tester.getRect(_souffleDisc).top);
        check(_souffleOpacity(tester)).isGreaterThan(0);
      }
      for (final (index, top) in tops.indexed.skip(1)) {
        check(top).isGreaterThan(tops[index - 1]);
      }

      for (var frame = 0; frame < 20; frame++) {
        await gesture.moveBy(const Offset(0, 15));
        await tester.pump(_dragFrame);
      }
      await gesture.up();
      await tester.pump(_souffleStep);
      await tester.pump(_souffleStep);

      final rest = tester.getRect(_souffleDisc);
      check(_souffleOpacity(tester)).equals(1);
      check(rest.bottom).isLessOrEqual(
        tester.getRect(find.byType(WeekBand)).top,
      );

      gate.complete();
      await tester.pump(_souffleStep);
      await tester.pump(_souffleStep);
      await tester.pump(_souffleStep);
    },
    variant: TargetPlatformVariant.only(TargetPlatform.android),
  );

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

    testWidgets('shows a day of the shown week at once, then its new read', (
      tester,
    ) async {
      final backends = FakeBackends(
        mealNames: [breakfast],
        entries: [
          entry('E-1', date: _yesterday, nutrients: nutrients(kcal: 3120)),
        ],
      );
      await pumpFujin(tester, backends, goals: _goals);
      final gate = Completer<void>();
      backends
        ..diaryGate = gate
        ..entries = [
          ...backends.entries,
          entry('E-2', date: _yesterday, nutrients: nutrients(kcal: 100)),
        ];

      await tester.tap(find.text('6'));
      await tester.pump();
      check(
        _rich('3${_space}120 / 3${_space}000 kcal').evaluate(),
      ).length.equals(1);

      gate.complete();
      await tester.pumpAndSettle();
      check(
        _rich('3${_space}220 / 3${_space}000 kcal').evaluate(),
      ).length.equals(1);
    });

    testWidgets('rings the days of the previous week before it is swiped to', (
      tester,
    ) async {
      await pumpFujin(
        tester,
        FakeBackends(
          mealNames: [breakfast],
          entries: [
            entry(
              'E-1',
              date: DateTime.utc(2026, 10, 4),
              nutrients: nutrients(kcal: 3120),
            ),
          ],
        ),
        goals: _goals,
      );

      check(_ring(tester, '4').state).equals(DayGoalState.exceeded);
    });

    testWidgets('never reads a week a slow swipe only crosses', (
      tester,
    ) async {
      final backends = FakeBackends(mealNames: [breakfast]);
      await pumpFujin(tester, backends);
      final page = tester.getSize(find.byType(PageView)).width * 7 / 8;
      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(PageView)),
      );
      for (var moved = 0.0; moved < page * 4.2; moved += 20) {
        await gesture.moveBy(const Offset(20, 0));
        await tester.pump(_dragFrame);
      }
      await gesture.up();
      await tester.pumpAndSettle();

      final readDates = {
        for (final request in backends.requests)
          if (request.url.path == '/v2/diary')
            ?request.url.queryParameters['entry_date'],
      };
      check(_ring(tester, '9').selected).isTrue();
      check(readDates).contains('2026-09-09');
      check(
        readDates.where(
          (date) =>
              date.compareTo('2026-09-21') >= 0 &&
              date.compareTo('2026-09-28') < 0,
        ),
      ).isEmpty();
    });

    testWidgets('keeps a week left behind for five minutes, then reads it '
        'again', (tester) async {
      final backends = FakeBackends(mealNames: [breakfast]);
      await pumpFujin(tester, backends, goals: _goals);
      final mondayReads = _diaryReads(backends, _mondayDate);

      await _swipeWeekBack(tester);
      await _swipeWeekBack(tester);
      await tester.pump(const Duration(minutes: 4));
      await _tap(tester, find.text("Aujourd'hui ›"));
      check(_diaryReads(backends, _mondayDate)).equals(mondayReads);

      await _swipeWeekBack(tester);
      await _swipeWeekBack(tester);
      await tester.pump(const Duration(minutes: 6));
      await _tap(tester, find.text("Aujourd'hui ›"));
      check(_diaryReads(backends, _mondayDate)).equals(mondayReads + 1);
    });

    testWidgets('keeps the week held after five minutes on another tab', (
      tester,
    ) async {
      final backends = FakeBackends(mealNames: [breakfast]);
      await pumpFujin(tester, backends, goals: _goals);
      final mondayReads = _diaryReads(backends, _mondayDate);

      await _tap(tester, find.text('Mémoire'));
      await tester.pump(const Duration(minutes: 6));
      await _tap(tester, find.text('Journal'));
      await _swipeWeekBack(tester);
      await _swipeWeekBack(tester);
      await _tap(tester, find.text("Aujourd'hui ›"));
      check(_diaryReads(backends, _mondayDate)).equals(mondayReads);
    });

    testWidgets('shows a day whose last read failed at once with its '
        'problem, then its new read', (tester) async {
      final backends = FakeBackends(
        mealNames: [breakfast],
        entries: [
          entry('E-1', date: _yesterday, nutrients: nutrients(kcal: 3120)),
        ],
      )..mfpDiaryStatus = HttpStatus.serviceUnavailable;
      await pumpFujin(tester, backends, goals: _goals);
      final gate = Completer<void>();
      backends
        ..mfpDiaryStatus = null
        ..diaryGate = gate;

      await tester.tap(find.text('6'));
      await tester.pump();
      check(find.text(_mfpNotResponding).evaluate()).length.equals(1);
      check(
        find.text("Lecture de MyFitnessPal\net d'Ekklo…").evaluate(),
      ).isEmpty();

      gate.complete();
      await tester.pumpAndSettle();
      check(find.text(_mfpNotResponding).evaluate()).isEmpty();
      check(
        _rich('3${_space}120 / 3${_space}000 kcal').evaluate(),
      ).length.equals(1);
    });

    testWidgets('selects no week while a finger holds a band caught '
        'mid-fling', (tester) async {
      await pumpFujin(tester, FakeBackends(mealNames: [breakfast]));
      final band = find.byType(PageView);
      final controller = tester.widget<PageView>(band).controller;
      await tester.fling(band, const Offset(300, 0), 1000);
      while ((controller?.page ?? 0) < _pastHalfPage) {
        await tester.pump(_dragFrame);
      }

      final finger = await tester.startGesture(tester.getCenter(band));
      await tester.pump();
      check(_ring(tester, '7').selected).isTrue();

      await finger.up();
      await tester.pumpAndSettle();
      check(_ring(tester, '30').selected).isTrue();
    });

    testWidgets('changes week when the band is swiped', (tester) async {
      await pumpFujin(tester, FakeBackends(mealNames: [breakfast]));

      await tester.fling(find.byType(PageView), const Offset(300, 0), 1000);
      await tester.pumpAndSettle();

      check(find.text('Septembre').evaluate()).length.equals(1);
      check(_ring(tester, '30').selected).isTrue();
    });

    testWidgets('turns back to this week at once when the phone asks for '
        'less motion', (tester) async {
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(disableAnimations: true);
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );
      await pumpFujin(tester, FakeBackends(mealNames: [breakfast]));
      await _swipeWeekBack(tester);

      await tester.tap(find.text("Aujourd'hui ›"));
      await tester.pump();

      check(
        tester.widget<PageView>(find.byType(PageView)).controller?.page,
      ).equals(0);
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
        preferences: await FujinPreferences.open(),
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
    _tallView(tester);
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

  testWidgets('folds a meal all in Ekklo and unfolds it on touch', (
    tester,
  ) async {
    _tallView(tester);
    await pumpFujin(
      tester,
      FakeBackends(
        mealNames: [breakfast, lunch],
        entries: [
          entry('E-1', description: 'Flocons d’avoine'),
          entry('E-2', description: 'Pain', meal: lunch, food: rice),
          entry('E-3', meal: lunch, food: rice),
        ],
        ekkloMeals: [
          meal('meal-1', [item('I-1')]),
        ],
      ),
    );

    check(find.text('1/1 · Flocons d’avoine').evaluate()).length.equals(1);
    check(find.text('0/2 dans Ekklo').evaluate()).length.equals(1);
    check(find.text('À envoyer').evaluate()).length.equals(2);
    check(find.text('Ajouter un aliment').evaluate()).length.equals(2);

    await _tap(tester, find.text(breakfast));

    check(find.text('1/1 dans Ekklo').evaluate()).length.equals(1);
    check(find.text('Flocons d’avoine').evaluate()).length.equals(1);
  });

  testWidgets('shows only the new status of an entry that reached Ekklo '
      'after a pull', (tester) async {
    _tallView(tester);
    final backends = FakeBackends(
      mealNames: [breakfast],
      entries: [
        entry('E-1'),
        entry('E-2', food: rice),
      ],
    );
    await pumpFujin(tester, backends);
    check(find.text('À envoyer').evaluate()).length.equals(2);

    backends.ekkloMeals = [
      meal('meal-1', [item('I-1')]),
    ];
    await tester.drag(find.byType(CustomScrollView), const Offset(0, 1500));
    await tester.pumpAndSettle();

    check(find.text('À envoyer').evaluate()).length.equals(1);
    check(find.text('Dans Ekklo').evaluate()).length.equals(1);
  });

  testWidgets('folds a meal to send by touch and folds it again once it is '
      'all in Ekklo, whatever was touched before', (tester) async {
    final backends = FakeBackends(
      mealNames: [breakfast],
      entries: [entry('E-1', description: 'Flocons d’avoine')],
    );
    await pumpFujin(tester, backends);
    check(find.text('Flocons d’avoine').evaluate()).length.equals(1);

    await _tap(tester, find.text(breakfast));
    check(find.text('Flocons d’avoine').evaluate()).isEmpty();

    await _tap(tester, find.text(breakfast));
    check(find.text('Flocons d’avoine').evaluate()).length.equals(1);

    backends.ekkloMeals = [
      meal('meal-1', [item('I-1')]),
    ];
    await tester.drag(find.byType(CustomScrollView), const Offset(0, 1500));
    await tester.pumpAndSettle();
    await _pullToRefresh(tester);
    check(find.text('1/1 · Flocons d’avoine').evaluate()).length.equals(1);
    check(find.text('Flocons d’avoine').evaluate()).isEmpty();
  });

  testWidgets('keeps the MyFitnessPal foods readable, without statuses, when '
      'the Ekklo session expired', (
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
    check(find.text(oats).evaluate()).length.equals(1);
    check(find.text('À envoyer').evaluate()).isEmpty();
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
    testWidgets('keeps the last figures and foods with their time and '
        'retries alone', (
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
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -400));
      await tester.pumpAndSettle();
      check(find.text(oats).evaluate()).length.equals(1);
      check(find.text('À envoyer').evaluate()).isEmpty();

      backends
        ..mfpReachable = true
        ..ekkloReachable = true;
      await tester.pump(const Duration(seconds: 15));
      await tester.pumpAndSettle();
      check(find.text('Hors ligne').evaluate()).isEmpty();
    });

    testWidgets('rings the whole week again at the first pull back online', (
      tester,
    ) async {
      final backends = FakeBackends(
        mealNames: [breakfast],
        entries: [
          entry('E-1', date: _monday, nutrients: nutrients(kcal: 3120)),
        ],
      );
      final mfp = await backends.mfp();
      backends.mfpReachable = false;
      await pumpFujin(tester, backends, mfp: mfp, goals: _goals);
      check(_ring(tester, '5').state).equals(DayGoalState.noGoal);

      backends.mfpReachable = true;
      await _pullToRefresh(tester);
      check(_ring(tester, '5').state).equals(DayGoalState.exceeded);
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

  group('adding a food', () {
    testWidgets('writes the food in the meal and day it was opened from, '
        'then says so with a way to undo it', (tester) async {
      _tallView(tester);
      final backends = _basmatiBackends();
      await pumpFujin(tester, backends);

      await _addBasmatiToLunch(tester);

      check(backends.entries.single)
        ..has((entry) => entry.mealName, 'meal').equals(lunch)
        ..has((entry) => entry.date, 'date').equals(day);
      check(backends.ekkloItems).length.equals(1);
      check(find.text('Riz basmati ajouté').evaluate()).length.equals(1);
      check(
        find.text('MyFitnessPal et Ekklo · $lunch').evaluate(),
      ).length.equals(1);
      check(find.text('Annuler').evaluate()).length.equals(1);
      check(find.text('1/1 · Riz basmati').evaluate()).length.equals(1);
    });

    testWidgets('removes the food from both apps on Annuler', (tester) async {
      _tallView(tester);
      final backends = _basmatiBackends();
      await pumpFujin(tester, backends);
      await _addBasmatiToLunch(tester);

      await _tap(tester, find.text('Annuler'));

      check(backends.entries).isEmpty();
      check(backends.ekkloItems).isEmpty();
      check(find.text('Ajout annulé').evaluate()).length.equals(1);
      check(
        find.text('Supprimé de MyFitnessPal et d’Ekklo').evaluate(),
      ).length.equals(1);
      check(find.text('Rien pour l’instant').evaluate()).length.equals(2);
    });

    testWidgets('rings the day of an undone food without it after moving to '
        'another week', (tester) async {
      _tallView(tester);
      final backends = _basmatiBackends();
      await pumpFujin(tester, backends, goals: _goals);
      await _tap(tester, find.text('4'));
      await _addBasmatiToLunch(tester);
      await _tap(tester, find.text("Aujourd'hui ›"));
      check(_ring(tester, '4').state).equals(DayGoalState.missed);

      await _tap(tester, find.text('Annuler'));

      check(backends.entries).isEmpty();
      check(_ring(tester, '4').state).equals(DayGoalState.nothingLogged);
    });

    testWidgets('says the food is still in MyFitnessPal when only Ekklo '
        'let go of it, and finishes the undo on Réessayer', (tester) async {
      _tallView(tester);
      final backends = _basmatiBackends();
      await pumpFujin(tester, backends);
      await _addBasmatiToLunch(tester);

      backends.mfpWritesFail = true;
      await _tap(tester, find.text('Annuler'));

      check(backends.ekkloItems).isEmpty();
      check(backends.entries).length.equals(1);
      check(find.text('Encore dans MyFitnessPal').evaluate()).length.equals(1);
      check(
        find.text("Riz basmati retiré d'Ekklo seulement").evaluate(),
      ).length.equals(1);
      check(find.text('0/1 dans Ekklo').evaluate()).length.equals(1);

      backends.mfpWritesFail = false;
      await _tap(tester, find.text('Réessayer'));

      check(backends.entries).isEmpty();
      check(find.text('Ajout annulé').evaluate()).length.equals(1);
    });

    testWidgets('says the food went to MyFitnessPal only when Ekklo refused '
        'it', (tester) async {
      _tallView(tester);
      final backends = _basmatiBackends();
      backends.failingMeals.add(dejeuner);
      await pumpFujin(tester, backends);

      await _addBasmatiToLunch(tester);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      check(backends.entries).length.equals(1);
      check(backends.ekkloItems).isEmpty();
      check(
        find.text('MyFitnessPal seulement · $lunch').evaluate(),
      ).length.equals(1);
    });

    testWidgets('says the add was not undone and why when nothing could be '
        'removed', (tester) async {
      _tallView(tester);
      final backends = _basmatiBackends();
      await pumpFujin(tester, backends);
      await _addBasmatiToLunch(tester);

      backends.ekkloReachable = false;
      await _tap(tester, find.text('Annuler'));

      check(backends.entries).length.equals(1);
      check(backends.ekkloItems).length.equals(1);
      check(find.text('Ajout non annulé').evaluate()).length.equals(1);
      check(
        find
            .descendant(
              of: find.byType(SnackBar),
              matching: find.text('Pas de connexion internet.'),
            )
            .evaluate(),
      ).length.equals(1);
    });
  });
}
