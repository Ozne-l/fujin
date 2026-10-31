import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fujin/app/app_environment.dart';
import 'package:fujin/app/config.dart';
import 'package:fujin/data/accessibility/reduce_transparency_setting.dart';
import 'package:fujin/data/backup/backup_files.dart';
import 'package:fujin/data/backup/backup_repository.dart';
import 'package:fujin/data/backup/picker_backup_files.dart';
import 'package:fujin/data/connectors/connector_domain.dart';
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/entries/entry_repository.dart';
import 'package:fujin/data/foods/food_repository.dart';
import 'package:fujin/data/goals/goals_repository.dart';
import 'package:fujin/data/hints/hint_repository.dart';
import 'package:fujin/data/http/read_only_http_client.dart';
import 'package:fujin/data/links/sent_link_repository.dart';
import 'package:fujin/data/meals/meal_repository.dart';
import 'package:fujin/data/memory/memory_repository.dart';
import 'package:fujin/data/recents/recent_food_repository.dart';
import 'package:fujin/data/sessions/secure_ekklo_token_store.dart';
import 'package:fujin/data/sessions/secure_mfp_session_store.dart';
import 'package:fujin/data/settings/settings_repository.dart';
import 'package:fujin/data/unattended/unattended_item_repository.dart';
import 'package:fujin/domain/accounts/accounts_service.dart';
import 'package:fujin/domain/adding/add_food_service.dart';
import 'package:fujin/domain/adding/entry_writer.dart';
import 'package:fujin/domain/backup/backup_service.dart';
import 'package:fujin/domain/editing/edit_entry_service.dart';
import 'package:fujin/domain/editing/remove_entry_service.dart';
import 'package:fujin/domain/journal/journal_service.dart';
import 'package:fujin/domain/memory/memory_service.dart';
import 'package:fujin/domain/sending/send_service.dart';
import 'package:fujin/domain/writing/background_writer.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:myfitnesspal_client/myfitnesspal_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

final connectivityProvider = Provider<Stream<bool>>(
  (ref) => Connectivity().onConnectivityChanged.map(
    (results) => results.any((result) => result != ConnectivityResult.none),
  ),
);

final databaseProvider = Provider<FujinDatabase>(
  (ref) => throw StateError('databaseProvider is overridden in bootstrap'),
);

final appEnvironmentProvider = Provider<AppEnvironment>(
  (ref) =>
      throw StateError('appEnvironmentProvider is overridden in bootstrap'),
);

final preferencesProvider = Provider<SharedPreferencesWithCache>(
  (ref) => throw StateError('preferencesProvider is overridden in bootstrap'),
);

final appVersionProvider = Provider<String>(
  (ref) => throw StateError('appVersionProvider is overridden in bootstrap'),
);

final clearWebCookiesProvider = Provider<Future<void> Function()>(
  (ref) => () async {
    await CookieManager.instance().deleteAllCookies();
  },
);

final reduceTransparencyProvider = StreamProvider<bool>(
  (ref) => ReduceTransparencySetting.watch(),
);

final backupFilesProvider = Provider<BackupFiles>(
  (ref) => const PickerBackupFiles(),
);

final httpClientProvider = Provider<http.Client>((ref) {
  final client = switch (ref.watch(appEnvironmentProvider)) {
    AppEnvironment.production => http.Client(),
    AppEnvironment.dev => ReadOnlyHttpClient(
      http.Client(),
      ekkloBaseUri: Config.ekkloBaseUri,
      mfpSyncUri: Config.mfpSyncUri,
    ),
  };
  ref.onDispose(client.close);
  return client;
});

final secureStorageProvider = Provider<FlutterSecureStorage>(
  (ref) => const FlutterSecureStorage(),
);

final mfpUserAgentProvider = Provider<String>(
  (ref) => MyFitnessPalClient.defaultUserAgent,
);

final mfpClientProvider = Provider<MyFitnessPalClient>((ref) {
  final client = MyFitnessPalClient(
    sessionStore: SecureMfpSessionStore(ref.watch(secureStorageProvider)),
    httpClient: ref.watch(httpClientProvider),
    webUri: Config.mfpWebUri,
    apiUri: Config.mfpApiUri,
    syncUri: Config.mfpSyncUri,
    userAgent: ref.watch(mfpUserAgentProvider),
    clock: ref.watch(clockProvider),
  );
  ref.onDispose(client.close);
  return client;
});

final ekkloClientProvider = Provider<EkkloClient>((ref) {
  final client = EkkloClient(
    tokenStore: SecureEkkloTokenStore(ref.watch(secureStorageProvider)),
    httpClient: ref.watch(httpClientProvider),
    baseUri: Config.ekkloBaseUri,
    clock: ref.watch(clockProvider),
  );
  ref.onDispose(client.close);
  return client;
});

final sentLinkRepositoryProvider = Provider<SentLinkRepository>(
  (ref) => SentLinkRepository(ref.watch(databaseProvider)),
);

final foodRepositoryProvider = Provider<FoodRepository>(
  (ref) =>
      FoodRepository(ref.watch(databaseProvider), ref.watch(clockProvider)),
);

final mealRepositoryProvider = Provider<MealRepository>(
  (ref) =>
      MealRepository(ref.watch(databaseProvider), ref.watch(clockProvider)),
);

final memoryRepositoryProvider = Provider<MemoryRepository>(
  (ref) => MemoryRepository(
    database: ref.watch(databaseProvider),
    foods: ref.watch(foodRepositoryProvider),
    meals: ref.watch(mealRepositoryProvider),
  ),
);

final goalsRepositoryProvider = Provider<GoalsRepository>(
  (ref) =>
      GoalsRepository(ref.watch(databaseProvider), ref.watch(clockProvider)),
);

final unattendedItemRepositoryProvider = Provider<UnattendedItemRepository>(
  (ref) => UnattendedItemRepository(ref.watch(databaseProvider)),
);

final recentFoodRepositoryProvider = Provider<RecentFoodRepository>(
  (ref) => RecentFoodRepository(
    ref.watch(databaseProvider),
    ref.watch(foodRepositoryProvider),
  ),
);

final hintRepositoryProvider = Provider<HintRepository>(
  (ref) => HintRepository(ref.watch(preferencesProvider)),
);

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(ref.watch(preferencesProvider)),
);

final entryRepositoryProvider = Provider<EntryRepository>(
  (ref) =>
      EntryRepository(ref.watch(databaseProvider), ref.watch(clockProvider)),
);

final backupRepositoryProvider = Provider<BackupRepository>(
  (ref) => BackupRepository(
    database: ref.watch(databaseProvider),
    foods: ref.watch(foodRepositoryProvider),
    meals: ref.watch(mealRepositoryProvider),
    entries: ref.watch(entryRepositoryProvider),
    memory: ref.watch(memoryRepositoryProvider),
    recents: ref.watch(recentFoodRepositoryProvider),
    links: ref.watch(sentLinkRepositoryProvider),
    goals: ref.watch(goalsRepositoryProvider),
  ),
);

final accountsServiceProvider = Provider<AccountsService>(
  (ref) => AccountsService(
    mfp: ref.watch(mfpClientProvider),
    ekklo: ref.watch(ekkloClientProvider),
    clearWebCookies: ref.watch(clearWebCookiesProvider),
  ),
);

final backupServiceProvider = Provider<BackupService>(
  (ref) => BackupService(
    backups: ref.watch(backupRepositoryProvider),
    files: ref.watch(backupFilesProvider),
    clock: ref.watch(clockProvider),
  ),
);

final journalServiceProvider = Provider<JournalService>(
  (ref) => JournalService(
    mfp: ref.watch(mfpClientProvider),
    ekklo: ref.watch(ekkloClientProvider),
    entries: ref.watch(entryRepositoryProvider),
    links: ref.watch(sentLinkRepositoryProvider),
    unattended: ref.watch(unattendedItemRepositoryProvider),
    memory: ref.watch(memoryRepositoryProvider),
    foods: ref.watch(foodRepositoryProvider),
    meals: ref.watch(mealRepositoryProvider),
    database: ref.watch(databaseProvider),
    clock: ref.watch(clockProvider),
    roles: () =>
        ref.read(settingsRepositoryProvider).roles(ConnectorDomain.food),
  ),
);

final memoryServiceProvider = Provider<MemoryService>(
  (ref) => MemoryService(
    memory: ref.watch(memoryRepositoryProvider),
    ekklo: ref.watch(ekkloClientProvider),
  ),
);

final sendServiceProvider = Provider<SendService>(
  (ref) => SendService(
    journal: ref.watch(journalServiceProvider),
    ekklo: ref.watch(ekkloClientProvider),
    memory: ref.watch(memoryRepositoryProvider),
    entries: ref.watch(entryRepositoryProvider),
    database: ref.watch(databaseProvider),
    clock: ref.watch(clockProvider),
  ),
);

final entryWriterProvider = Provider<EntryWriter>(
  (ref) => EntryWriter(
    database: ref.watch(databaseProvider),
    foods: ref.watch(foodRepositoryProvider),
    meals: ref.watch(mealRepositoryProvider),
    entries: ref.watch(entryRepositoryProvider),
    clock: ref.watch(clockProvider),
  ),
);

final backgroundWriterProvider = Provider<BackgroundWriter>(
  (ref) => BackgroundWriter(
    mfp: ref.watch(mfpClientProvider),
    sending: ref.watch(sendServiceProvider),
    memory: ref.watch(memoryRepositoryProvider),
    entries: ref.watch(entryRepositoryProvider),
    writer: ref.watch(entryWriterProvider),
  ),
);

final addFoodServiceProvider = Provider<AddFoodService>(
  (ref) => AddFoodService(
    mfp: ref.watch(mfpClientProvider),
    sending: ref.watch(sendServiceProvider),
    memory: ref.watch(memoryRepositoryProvider),
    foods: ref.watch(foodRepositoryProvider),
    recents: ref.watch(recentFoodRepositoryProvider),
    writer: ref.watch(entryWriterProvider),
    background: ref.watch(backgroundWriterProvider),
    clock: ref.watch(clockProvider),
  ),
);

final removeEntryServiceProvider = Provider<RemoveEntryService>(
  (ref) => RemoveEntryService(
    entries: ref.watch(entryRepositoryProvider),
    background: ref.watch(backgroundWriterProvider),
  ),
);

final editEntryServiceProvider = Provider<EditEntryService>(
  (ref) => EditEntryService(
    mfp: ref.watch(mfpClientProvider),
    sending: ref.watch(sendServiceProvider),
    memory: ref.watch(memoryRepositoryProvider),
    foods: ref.watch(foodRepositoryProvider),
    entries: ref.watch(entryRepositoryProvider),
    writer: ref.watch(entryWriterProvider),
    background: ref.watch(backgroundWriterProvider),
  ),
);
