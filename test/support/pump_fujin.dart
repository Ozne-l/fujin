import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart' show WidgetTester, addTearDown;
import 'package:fujin/app/fujin_app.dart';
import 'package:fujin/app/providers.dart';
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/memory/memory_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

import 'fake_backends.dart';
import 'fixtures.dart';

Future<void> pumpFujin(
  WidgetTester tester,
  FakeBackends backends, {
  MyFitnessPalClient? mfp,
  EkkloClient? ekklo,
}) async {
  tester.platformDispatcher.localesTestValue = const [Locale('fr')];
  addTearDown(tester.platformDispatcher.clearLocalesTestValue);
  final database = FujinDatabase.inMemory();
  addTearDown(database.close);
  final memoryRepository = MemoryRepository(database);
  memory.foods.forEach(memoryRepository.saveFood);
  memory.meals.forEach(memoryRepository.saveMeal);
  final signedInMfp = mfp ?? await backends.mfp();
  final signedInEkklo = ekklo ?? await backends.ekklo();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(database),
        clockProvider.overrideWithValue(() => now),
        mfpClientProvider.overrideWithValue(signedInMfp),
        ekkloClientProvider.overrideWithValue(signedInEkklo),
      ],
      child: const FujinApp(),
    ),
  );
  await tester.pumpAndSettle();
}
