import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fujin/app/fujin_app.dart';
import 'package:fujin/app/providers.dart';
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/memory/memory_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../support/fake_backends.dart';
import '../support/fixtures.dart';

Future<FakeBackends> _pumpJournal(
  WidgetTester tester,
  FakeBackends backends,
) async {
  final database = FujinDatabase.inMemory();
  addTearDown(database.close);
  final memoryRepository = MemoryRepository(database);
  memory.foods.forEach(memoryRepository.saveFood);
  memory.meals.forEach(memoryRepository.saveMeal);
  final mfp = await backends.mfp();
  final ekklo = await backends.ekklo();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(database),
        clockProvider.overrideWithValue(() => now),
        mfpClientProvider.overrideWithValue(mfp),
        ekkloClientProvider.overrideWithValue(ekklo),
      ],
      child: const FujinApp(),
    ),
  );
  await tester.pumpAndSettle();
  return backends;
}

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
    await _pumpJournal(
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
    final backends = await _pumpJournal(
      tester,
      FakeBackends(mealNames: [breakfast], entries: [entry('E-1')]),
    );
    check(find.text('Rien de nouveau').evaluate()).isEmpty();

    backends.entries = [entry('E-1'), entry('E-2')];
    await _pullToRefresh(tester);
    check(find.text('Rien de nouveau').evaluate()).isEmpty();

    await _pullToRefresh(tester);
    check(find.text('Rien de nouveau').evaluate()).length.equals(1);
  });
}
