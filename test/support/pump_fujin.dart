import 'dart:io';

import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart' show WidgetTester, addTearDown;
import 'package:fujin/app/app_environment.dart';
import 'package:fujin/app/fujin_app.dart';
import 'package:fujin/app/providers.dart';
import 'package:fujin/data/backup/backup_files.dart';
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/database/fujin_id.dart';
import 'package:fujin/data/goals/goal_period.dart';
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
import 'fake_chat_notifications.dart';
import 'fake_media_picker.dart';
import 'fake_media_processor.dart';
import 'fake_media_uploader.dart';
import 'fake_relay_scheduler.dart';
import 'fake_scan_camera.dart';
import 'fake_upload_notifications.dart';
import 'fake_video_player.dart';
import 'fake_voice_recorder.dart';
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
  List<GoalPeriod> goalPeriods = const [],
  DateTime Function()? clock,
  BackupFiles? backupFiles,
  Future<void> Function()? clearWebCookies,
  SharedPreferencesWithCache? preferences,
  FakeScanCamera? camera,
  List<BarcodeLink> barcodeLinks = const [],
  bool reduceTransparency = false,
  AppEnvironment environment = AppEnvironment.production,
  Stream<bool> connectivity = const Stream.empty(),
  FakeChatNotifications? chatNotifications,
  FakeMediaProcessor? mediaProcessor,
  FakeMediaPicker? mediaPicker,
  FakeVideoPlayer? fileVideo,
  FakeVideoPlayer? urlVideo,
  FakeVoiceRecorder? voiceRecorder,
  FakeMediaUploader? mediaUploader,
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
  goalsOf(database).replaceAll([
    if (goals case final goals?) GoalPeriod(startsOn: day, goals: goals),
    ...goalPeriods,
  ]);
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
  final chatClient = switch (environment) {
    AppEnvironment.production => signedInEkklo,
    AppEnvironment.dev => await backends.ekklo(),
  };
  final cacheDirectory = Directory.systemTemp.createTempSync('fujin-cache');
  addTearDown(() => cacheDirectory.deleteSync(recursive: true));
  final storedPreferences = preferences ?? await inMemoryPreferences();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appEnvironmentProvider.overrideWithValue(environment),
        databaseProvider.overrideWithValue(database),
        clockProvider.overrideWithValue(clock ?? () => now),
        connectivityProvider.overrideWith((ref) => connectivity),
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
        chatNotificationsProvider.overrideWithValue(
          chatNotifications ?? FakeChatNotifications(),
        ),
        chatCachePathProvider.overrideWithValue(null),
        appCacheDirectoryProvider.overrideWithValue(cacheDirectory),
        chatClientProvider.overrideWithValue(chatClient),
        httpClientProvider.overrideWithValue(httpClient),
        appForegroundProvider.overrideWith((ref) => Stream.value(true)),
        mediaProcessorProvider.overrideWithValue(
          mediaProcessor ?? FakeMediaProcessor(),
        ),
        mediaPickerProvider.overrideWithValue(mediaPicker ?? FakeMediaPicker()),
        fileVideoProvider.overrideWithValue(
          (file) => (fileVideo ?? FakeVideoPlayer()).build(file.uri),
        ),
        urlVideoProvider.overrideWithValue(
          (urlVideo ?? FakeVideoPlayer()).build,
        ),
        voiceRecorderProvider.overrideWithValue(
          voiceRecorder ?? FakeVoiceRecorder(),
        ),
        mediaUploaderProvider.overrideWithValue(
          mediaUploader ?? FakeMediaUploader(),
        ),
        relaySchedulerProvider.overrideWithValue(
          FakeRelayScheduler(),
        ),
        uploadNotificationsProvider.overrideWithValue(
          FakeUploadNotifications(),
        ),
      ],
      child: const FujinApp(),
    ),
  );
  await tester.pumpAndSettle();
}
