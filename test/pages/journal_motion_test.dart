import 'dart:async';

import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/data/goals/goals.dart';
import 'package:fujin/pages/common/arrival_highlight.dart';
import 'package:fujin/pages/common/pressable.dart';

import '../support/fake_backends.dart';
import '../support/fixtures.dart';
import '../support/logged_journal.dart';
import '../support/pump_fujin.dart';

const _space = '\u202f';
const _goals = Goals(
  kilocalories: 3000,
  protein: 160,
  carbohydrates: 400,
  fat: 70,
);
const _today = '1${_space}898 / 3${_space}000 kcal';
const _yesterday = '3${_space}120 / 3${_space}000 kcal';
const _todayFood = 'Flocons d’avoine';
const _yesterdayFood = 'Pomme';
const _saveBoth = 'Enregistrer dans MFP et Ekklo';
const _other = 'Autre';

FakeBackends _twoDays() => FakeBackends(
  mealNames: [breakfast],
  entries: [
    entry('E-1', description: _todayFood, nutrients: nutrients(kcal: 1898)),
    entry(
      'E-2',
      food: 'mfp-apple',
      description: _yesterdayFood,
      date: DateTime.utc(2026, 10, 6),
      nutrients: nutrients(kcal: 3120),
    ),
  ],
);

bool _shows(String text) =>
    find.text(text, findRichText: true).evaluate().isNotEmpty;

void _reduceMotion(WidgetTester tester) {
  tester.platformDispatcher.accessibilityFeaturesTestValue =
      const FakeAccessibilityFeatures(disableAnimations: true);
  addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
}

Finder _glowOf(String row) => find.descendant(
  of: find.ancestor(of: find.text(row), matching: find.byType(Pressable)),
  matching: find.byType(ArrivalHighlight),
);

Future<void> _editBasmati(WidgetTester tester) async {
  await tester.tap(find.text(LoggedJournal.basmati));
  await tester.pumpAndSettle();
  await tester.enterText(find.widgetWithText(TextField, _other), '2');
  await tester.pumpAndSettle();
  final save = find.text(_saveBoth);
  await tester.ensureVisible(save);
  await tester.pumpAndSettle();
  await tester.tap(save);
  await tester.pump();
}

void main() {
  testWidgets('shows the kilocalories of a first read at once, then rolls '
      'them to the next day shown', (tester) async {
    final gate = Completer<void>();
    final backends = _twoDays()..diaryGate = gate;
    await pumpFujin(tester, backends, goals: _goals, settle: false);

    gate.complete();
    await tester.pump();
    await tester.pump();
    check(_shows(_today)).isTrue();

    await tester.tap(find.text('6'));
    await tester.pump();
    await tester.pump(FujinMotion.spatialSlow.duration ~/ 2);
    check(_shows(_today)).isFalse();
    check(_shows(_yesterday)).isFalse();

    await tester.pumpAndSettle();
    check(_shows(_yesterday)).isTrue();
    check(find.text(_yesterdayFood).evaluate()).length.equals(1);
    check(find.text(_todayFood).evaluate()).isEmpty();
  });

  testWidgets('slides the meals of the day before in while the summary stays', (
    tester,
  ) async {
    await pumpFujin(tester, _twoDays(), goals: _goals);
    final summary = tester.getTopLeft(find.text(_today, findRichText: true));

    await tester.tap(find.text('6'));
    await tester.pump();
    await tester.pump(FujinMotion.spatial.duration ~/ 2);
    check(find.text(_todayFood).evaluate()).length.equals(1);
    check(
      tester.getTopLeft(find.text(_yesterdayFood)).dx,
    ).isLessThan(tester.getTopLeft(find.text(_todayFood)).dx);

    await tester.pumpAndSettle();
    check(
      tester.getTopLeft(find.text(_yesterday, findRichText: true)),
    ).equals(summary);
  });

  testWidgets('lands the day before at once with reduced motion', (
    tester,
  ) async {
    _reduceMotion(tester);
    await pumpFujin(tester, _twoDays(), goals: _goals);

    await tester.tap(find.text('6'));
    await tester.pump();
    await tester.pump();

    check(_shows(_yesterday)).isTrue();
    check(find.text(_yesterdayFood).evaluate()).length.equals(1);
    check(find.text(_todayFood).evaluate()).isEmpty();
  });

  testWidgets('fades the reading card into the day once both apps answer', (
    tester,
  ) async {
    final gate = Completer<void>();
    final backends = _twoDays()..diaryGate = gate;
    await pumpFujin(tester, backends, goals: _goals, settle: false);

    gate.complete();
    await tester.pump();
    await tester.pump();
    check(_shows(_today)).isTrue();
    check(
      find.text('Lecture de MyFitnessPal\net d’Ekklo…').evaluate(),
    ).length.equals(1);

    await tester.pumpAndSettle();
    check(
      find.text('Lecture de MyFitnessPal\net d’Ekklo…').evaluate(),
    ).isEmpty();
  });

  testWidgets('swaps the reading card for the day at once with reduced '
      'motion', (tester) async {
    _reduceMotion(tester);
    final gate = Completer<void>();
    final backends = _twoDays()..diaryGate = gate;
    await pumpFujin(tester, backends, goals: _goals, settle: false);

    gate.complete();
    await tester.pump();
    await tester.pump();

    check(_shows(_today)).isTrue();
    check(
      find.text('Lecture de MyFitnessPal\net d’Ekklo…').evaluate(),
    ).isEmpty();
  });

  testWidgets('lights only the edited row back on the Journal, and none on '
      'opening', (tester) async {
    await LoggedJournal.pump(tester, LoggedJournal.backends());
    check(find.byType(ArrivalHighlight).evaluate()).isEmpty();

    await _editBasmati(tester);
    await tester.pumpAndSettle();

    check(_glowOf(LoggedJournal.basmati).evaluate()).length.equals(1);
    check(find.byType(ArrivalHighlight).evaluate()).length.equals(1);
  });
}
