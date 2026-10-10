import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_backends.dart';
import '../support/fixtures.dart';
import '../support/pump_fujin.dart';

Future<void> _tap(WidgetTester tester, String text) async {
  final target = find.text(text).last;
  await tester.ensureVisible(target);
  await tester.pumpAndSettle();
  await tester.tap(target);
  await tester.pumpAndSettle();
}

int _count(String text) => find.text(text).evaluate().length;

Future<void> _back(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.chevron_left));
  await tester.pumpAndSettle();
}

Future<void> _openMemory(WidgetTester tester, FakeBackends backends) async {
  await pumpFujin(tester, backends, units: memory.units);
  await _tap(tester, 'Mémoire');
}

void main() {
  setUp(() {
    final view =
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    addTearDown(view.reset);
    view
      ..physicalSize = const Size(800, 1800)
      ..devicePixelRatio = 1;
  });

  testWidgets('lists the remembered foods and finds one by name', (
    tester,
  ) async {
    await _openMemory(tester, FakeBackends(mealNames: [breakfast]));

    check(_count('Aliments (2)')).equals(1);
    check(_count('→ $riceInEkklo')).equals(1);
    check(_count('1 cup = 180 g')).equals(1);

    await tester.enterText(find.byType(TextField), 'OATS');
    await tester.pumpAndSettle();
    check(_count(oats)).equals(1);
    check(_count(rice)).equals(0);
  });

  testWidgets('shows the Ekklo values of a remembered food and saves its '
      'unit weight', (tester) async {
    await _openMemory(
      tester,
      FakeBackends(
        mealNames: [breakfast],
        ekkloFoods: [ekkloFood(riceInEkklo, calories: 130)],
      ),
    );

    await _tap(tester, rice);
    check(_count('130 kcal · pour 100 g')).equals(1);

    await tester.enterText(find.byType(TextField), '200');
    await tester.pumpAndSettle();
    await _back(tester);
    check(_count('1 cup = 200 g')).equals(1);
  });

  testWidgets('forgets a food so the next send asks again', (tester) async {
    await _openMemory(tester, FakeBackends(mealNames: [breakfast]));

    await _tap(tester, rice);
    await _tap(tester, 'Oublier cet aliment');

    check(_count('Aliments (1)')).equals(1);
    check(_count(rice)).equals(0);
  });

  testWidgets('remembers the Ekklo food chosen with Changer', (tester) async {
    final basmati = ekkloFood('ekklo-basmati', name: 'Riz basmati');
    await _openMemory(
      tester,
      FakeBackends(
        mealNames: [breakfast],
        ekkloFoods: [ekkloFood(riceInEkklo), basmati],
        ekkloSearches: {
          'basmati': [basmati],
        },
      ),
    );

    await _tap(tester, rice);
    await _tap(tester, 'Changer ›');
    await tester.enterText(find.byType(TextField).last, 'basmati');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    await _tap(tester, 'Riz basmati');
    await _tap(tester, 'Associer et mémoriser');
    await _back(tester);

    check(_count('→ Riz basmati')).equals(1);
    check(_count('→ $riceInEkklo')).equals(0);
  });

  testWidgets('maps a MyFitnessPal meal to a meal seen in Ekklo', (
    tester,
  ) async {
    await _openMemory(
      tester,
      FakeBackends(
        mealNames: [breakfast],
        ekkloMeals: [
          meal('meal-1', [item('I-1')], name: 'Collation'),
        ],
      ),
    );

    await _tap(tester, 'Repas (2)');
    await _tap(tester, petitDejeuner);
    await _tap(tester, 'Collation');

    check(_count('Collation')).equals(1);
    check(_count(petitDejeuner)).equals(0);
  });
}
