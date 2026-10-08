import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_backends.dart';
import '../support/fixtures.dart';
import '../support/pump_fujin.dart';

Future<void> _pullToRefresh(WidgetTester tester) async {
  await tester.fling(
    find.byType(CustomScrollView),
    const Offset(0, 400),
    1000,
  );
  await tester.pumpAndSettle();
}

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
}
