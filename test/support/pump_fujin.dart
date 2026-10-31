import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart' show WidgetTester, addTearDown;
import 'package:fujin/app/app_environment.dart';
import 'package:fujin/app/fujin_app.dart';
import 'package:fujin/app/providers.dart';
import 'package:fujin/data/backup/backup_files.dart';
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/database/fujin_id.dart';
import 'package:fujin/data/goals/goals.dart';
import 'package:fujin/data/http/read_only_http_client.dart';
import 'package:fujin/data/memory/barcode_link.dart';
import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/data/memory/remembered_unit.dart';
import 'package:fujin/pages/scanner/scan_camera.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fake_backends.dart';
import 'fake_backup_files.dart';
import 'fake_scan_camera.dart';
import 'fixtures.dart';
import 'in_memory_preferences.dart';
import 'repositories.dart';
import 'sent_food.dart';

const appVersion = '0.1.0';
const _beforeTheReads = Duration(hours: 1);

Future<void> pumpFujin(
  WidgetTester tester,
  FakeBackends backends, {
  MyFitnessPalClient? mfp,
  EkkloClient? ekklo,
  List<SentFood> sent = const [],
  List<OwnCopy> ownCopies = const [],
  List<RememberedUnit> units = const [],
  Goals? goals,
  BackupFiles? backupFiles,
  Future<void> Function()? clearWebCookies,
  SharedPreferencesWithCache? preferences,
  FakeScanCamera? camera,
  List<BarcodeLink> barcodeLinks = const [],
  bool reduceTransparency = false,
  AppEnvironment environment = AppEnvironment.production,
  Stream<bool> connectivity = const Stream.empty(),
}) async {
  tester.platformDispatcher.localesTestValue = const [Locale('fr')];
  addTearDown(tester.platformDispatcher.clearLocalesTestValue);
  final database = FujinDatabase.inMemory();
  addTearDown(database.close);
  final memoryRepository = memoryOf(database);
  final descriptions = {
    for (final entry in backends.entries.reversed)
      entry.food.id: entry.food.description,
  };
  for (final match in memory.matches) {
    memoryRepository.saveFood(
      match.copyWith(
        mfpDescription: descriptions[match.mfpFoodId] ?? match.mfpDescription,
      ),
    );
  }
  memory.meals.forEach(memoryRepository.saveMeal);
  ownCopies.forEach(memoryRepository.saveFood);
  units.forEach(memoryRepository.saveUnit);
  barcodeLinks.forEach(memoryRepository.saveBarcodeLink);
  final sentIds = FujinId.source(() => now.subtract(_beforeTheReads));
  for (final food in sent) {
    food.store(database, entryId: sentIds());
  }
  goalsOf(database).replace(goals);
  final httpClient = switch (environment) {
    AppEnvironment.production => backends.httpClient,
    AppEnvironment.dev => ReadOnlyHttpClient(
      backends.httpClient,
      ekkloBaseUri: ekkloUri,
      mfpSyncUri: mfpSyncUri,
    ),
  };
  final signedInMfp = mfp ?? await backends.mfp(client: httpClient);
  final signedInEkklo = ekklo ?? await backends.ekklo(client: httpClient);
  final storedPreferences = preferences ?? await inMemoryPreferences();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appEnvironmentProvider.overrideWithValue(environment),
        databaseProvider.overrideWithValue(database),
        clockProvider.overrideWithValue(() => now),
        connectivityProvider.overrideWithValue(connectivity),
        mfpClientProvider.overrideWithValue(signedInMfp),
        ekkloClientProvider.overrideWithValue(signedInEkklo),
        appVersionProvider.overrideWithValue(appVersion),
        backupFilesProvider.overrideWithValue(
          backupFiles ?? FakeBackupFiles(),
        ),
        clearWebCookiesProvider.overrideWithValue(
          clearWebCookies ?? () async {},
        ),
        preferencesProvider.overrideWithValue(storedPreferences),
        scanCameraProvider.overrideWithValue(
          (camera ?? FakeScanCamera()).build,
        ),
        reduceTransparencyProvider.overrideWith(
          (ref) => Stream.value(reduceTransparency),
        ),
      ],
      child: const FujinApp(),
    ),
  );
  await tester.pumpAndSettle();
}
