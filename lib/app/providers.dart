import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fujin/app/app_environment.dart';
import 'package:fujin/app/config.dart';
import 'package:fujin/app/file_video.dart';
import 'package:fujin/app/notifications/device_localizations.dart';
import 'package:fujin/app/notifications/upload_notification_text.dart';
import 'package:fujin/app/url_video.dart';
import 'package:fujin/data/accessibility/reduce_transparency_setting.dart';
import 'package:fujin/data/backup/backup_files.dart';
import 'package:fujin/data/backup/backup_repository.dart';
import 'package:fujin/data/backup/picker_backup_files.dart';
import 'package:fujin/data/chat/chat_owner_repository.dart';
import 'package:fujin/data/chat/chat_repository.dart';
import 'package:fujin/data/chat/foreground_stamp_repository.dart';
import 'package:fujin/data/chat/message_in_progress_repository.dart';
import 'package:fujin/data/chat_media/chat_media_cache.dart';
import 'package:fujin/data/connectors/connector_domain.dart';
import 'package:fujin/data/database/cache_table.dart';
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/database/fujin_table.dart';
import 'package:fujin/data/dev_chat/fake_chat_server.dart';
import 'package:fujin/data/entries/entry_repository.dart';
import 'package:fujin/data/foods/food_repository.dart';
import 'package:fujin/data/goals/goals_repository.dart';
import 'package:fujin/data/hints/hint_repository.dart';
import 'package:fujin/data/http/blocked_web_socket.dart';
import 'package:fujin/data/http/read_only_http_client.dart';
import 'package:fujin/data/links/sent_link_repository.dart';
import 'package:fujin/data/meals/meal_repository.dart';
import 'package:fujin/data/media/channel_media_processor.dart';
import 'package:fujin/data/media/image_media_picker.dart';
import 'package:fujin/data/media/media_picker.dart';
import 'package:fujin/data/media/media_processor.dart';
import 'package:fujin/data/memory/memory_repository.dart';
import 'package:fujin/data/notifications/chat_notifications.dart';
import 'package:fujin/data/recents/recent_food_repository.dart';
import 'package:fujin/data/sessions/secure_ekklo_token_store.dart';
import 'package:fujin/data/sessions/secure_mfp_session_store.dart';
import 'package:fujin/data/settings/settings_repository.dart';
import 'package:fujin/data/unattended/unattended_item_repository.dart';
import 'package:fujin/data/upload/background_media_uploader.dart';
import 'package:fujin/data/upload/local_upload_notifications.dart';
import 'package:fujin/data/upload/media_uploader.dart';
import 'package:fujin/data/upload/relay_scheduler.dart';
import 'package:fujin/data/upload/upload_folder.dart';
import 'package:fujin/data/upload/upload_notifications.dart';
import 'package:fujin/data/upload/workmanager_relay_scheduler.dart';
import 'package:fujin/data/voice/record_voice_recorder.dart';
import 'package:fujin/data/voice/voice_recorder.dart';
import 'package:fujin/domain/accounts/accounts_service.dart';
import 'package:fujin/domain/adding/add_food_service.dart';
import 'package:fujin/domain/adding/entry_writer.dart';
import 'package:fujin/domain/adding/food_completion_service.dart';
import 'package:fujin/domain/backup/backup_service.dart';
import 'package:fujin/domain/chat/chat_service.dart';
import 'package:fujin/domain/chat/chat_state.dart';
import 'package:fujin/domain/chat/conversation_state.dart';
import 'package:fujin/domain/chat/upload/chat_upload_service.dart';
import 'package:fujin/domain/editing/edit_entry_service.dart';
import 'package:fujin/domain/journal/fresh_read_service.dart';
import 'package:fujin/domain/journal/journal_service.dart';
import 'package:fujin/domain/memory/memory_service.dart';
import 'package:fujin/domain/sending/send_service.dart';
import 'package:fujin/domain/writing/background_writer.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart';
import 'package:http/http.dart' as http;
import 'package:myfitnesspal_client/myfitnesspal_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

final connectivityProvider = StreamProvider<bool>(
  (ref) => Connectivity().onConnectivityChanged.map(
    (results) => results.any((result) => result != ConnectivityResult.none),
  ),
);

final databaseProvider = Provider<FujinDatabase<FujinTable>>(
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
    webSocketConnector: switch (ref.watch(appEnvironmentProvider)) {
      AppEnvironment.production => null,
      AppEnvironment.dev => blockedWebSocket,
    },
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
  (ref) => EntryRepository(
    database: ref.watch(databaseProvider),
    foods: ref.watch(foodRepositoryProvider),
    meals: ref.watch(mealRepositoryProvider),
    links: ref.watch(sentLinkRepositoryProvider),
    unattended: ref.watch(unattendedItemRepositoryProvider),
    clock: ref.watch(clockProvider),
  ),
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
    forgetChat: ref.watch(forgetChatProvider),
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
    readOnly: ref.watch(appEnvironmentProvider).readOnly,
    journal: ref.watch(journalServiceProvider),
  ),
);

final foodCompletionServiceProvider = Provider<FoodCompletionService>(
  (ref) => FoodCompletionService(
    mfp: ref.watch(mfpClientProvider),
    foods: ref.watch(foodRepositoryProvider),
  ),
);

final freshReadServiceProvider = Provider<FreshReadService>(
  (ref) => FreshReadService(
    journal: ref.watch(journalServiceProvider),
    completion: ref.watch(foodCompletionServiceProvider),
    writer: ref.watch(backgroundWriterProvider),
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

final editEntryServiceProvider = Provider<EditEntryService>(
  (ref) => EditEntryService(
    mfp: ref.watch(mfpClientProvider),
    sending: ref.watch(sendServiceProvider),
    foods: ref.watch(foodRepositoryProvider),
    entries: ref.watch(entryRepositoryProvider),
    writer: ref.watch(entryWriterProvider),
    background: ref.watch(backgroundWriterProvider),
  ),
);

final chatNotificationsProvider = Provider<ChatNotifications>(
  (ref) =>
      throw StateError('chatNotificationsProvider is overridden in bootstrap'),
);

final mediaPickerProvider = Provider<MediaPicker>(
  (ref) => ImageMediaPicker(),
);

final appForegroundProvider = StreamProvider<bool>((ref) {
  bool inForeground(AppLifecycleState? state) => switch (state) {
    null || AppLifecycleState.resumed || AppLifecycleState.inactive => true,
    AppLifecycleState.hidden ||
    AppLifecycleState.paused ||
    AppLifecycleState.detached => false,
  };
  final foreground = StreamController<bool>();
  final listener = AppLifecycleListener(
    onStateChange: (state) => foreground.add(inForeground(state)),
  );
  ref.onDispose(() {
    listener.dispose();
    unawaited(foreground.close());
  });
  foreground.add(inForeground(WidgetsBinding.instance.lifecycleState));
  return foreground.stream;
});

final appCacheDirectoryProvider = Provider<Directory>(
  (ref) =>
      throw StateError('appCacheDirectoryProvider is overridden in bootstrap'),
);

final chatCachePathProvider = Provider<String?>(
  (ref) => throw StateError('chatCachePathProvider is overridden in bootstrap'),
);

final chatCacheProvider = Provider<FujinDatabase<CacheTable>>((ref) {
  final database = switch (ref.watch(chatCachePathProvider)) {
    null => FujinDatabase.cacheInMemory(),
    final path => FujinDatabase.openCacheInApp(path),
  };
  ref.onDispose(database.close);
  return database;
});

final chatRepositoryProvider = Provider<ChatRepository>(
  (ref) => ChatRepository(ref.watch(chatCacheProvider)),
);

final chatOwnerRepositoryProvider = Provider<ChatOwnerRepository>(
  (ref) => ChatOwnerRepository(ref.watch(chatCacheProvider)),
);

final foregroundStampRepositoryProvider = Provider<ForegroundStampRepository>(
  (ref) => ForegroundStampRepository(ref.watch(chatCacheProvider)),
);

final messageInProgressRepositoryProvider =
    Provider<MessageInProgressRepository>(
      (ref) => MessageInProgressRepository(ref.watch(chatCacheProvider)),
    );

final chatClientProvider = Provider<EkkloClient>((ref) {
  switch (ref.watch(appEnvironmentProvider)) {
    case AppEnvironment.production:
      return ref.watch(ekkloClientProvider);
    case AppEnvironment.dev:
      final client = FakeChatServer.client();
      ref.onDispose(client.close);
      return client;
  }
});

final mediaProcessorProvider = Provider<MediaProcessor>(
  (ref) => ChannelMediaProcessor(),
);

final chatMediaCacheProvider = Provider<ChatMediaCache>(
  (ref) => ChatMediaCache(
    directory: Directory(
      '${ref.watch(appCacheDirectoryProvider).path}/'
      '${ChatMediaCache.folderName}',
    ),
    http: ref.watch(httpClientProvider),
    media: ref.watch(mediaProcessorProvider),
  ),
);

final chatServiceProvider = Provider<ChatService>((ref) {
  final ekklo = ref.watch(ekkloClientProvider);
  final service = ChatService(
    messaging: ref.watch(chatClientProvider).messaging,
    signedIn: () => ekklo.isSignedIn,
    chats: ref.watch(chatRepositoryProvider),
    owners: ref.watch(chatOwnerRepositoryProvider),
    stamps: ref.watch(foregroundStampRepositoryProvider),
    clock: ref.watch(clockProvider),
  )..start();
  ref
    ..onDispose(service.dispose)
    ..listen(appForegroundProvider, (_, next) {
      if (next.value case final foreground?) {
        service.setForeground(foreground: foreground);
      }
    }, fireImmediately: true)
    ..listen(connectivityProvider, (_, next) {
      if (next.value case final online?) service.setOnline(online: online);
    }, fireImmediately: true);
  return service;
});

final chatProvider = StreamProvider<ChatState>(
  (ref) => ref.watch(chatServiceProvider).states,
);

final StreamProviderFamily<ConversationState, String> conversationProvider =
    StreamProvider.autoDispose.family<ConversationState, String>(
      (ref, conversationId) =>
          ref.watch(chatServiceProvider).watch(conversationId),
    );

final forgetChatProvider = Provider<Future<void> Function()>(
  (ref) => () async {
    await ref.read(chatMediaCacheProvider).deleteAll();
    ref
      ..invalidate(chatServiceProvider)
      ..invalidate(chatCacheProvider);
    if (ref.read(chatCachePathProvider) case final path?) {
      FujinDatabase.deleteCache(path);
    }
  },
);

final voiceRecorderProvider = Provider<VoiceRecorder>((ref) {
  final recorder = RecordVoiceRecorder();
  ref.onDispose(() => unawaited(recorder.dispose()));
  return recorder;
});

final mediaUploaderProvider = Provider<MediaUploader>((ref) {
  final uploader = BackgroundMediaUploader(
    cachePath: ref.watch(chatCachePathProvider),
    copy: UploadNotificationText(deviceLocalizations()),
  );
  ref.onDispose(() => unawaited(uploader.close()));
  return uploader;
});

final relaySchedulerProvider = Provider<RelayScheduler>(
  (ref) => const WorkmanagerRelayScheduler(),
);

final uploadNotificationsProvider = Provider<UploadNotifications>(
  (ref) =>
      LocalUploadNotifications(UploadNotificationText(deviceLocalizations())),
);

final chatUploadServiceProvider = Provider<ChatUploadService>((ref) {
  final service = ChatUploadService(
    messaging: ref.watch(chatClientProvider).messaging,
    messages: ref.watch(messageInProgressRepositoryProvider),
    chats: ref.watch(chatRepositoryProvider),
    processor: ref.watch(mediaProcessorProvider),
    uploader: ref.watch(mediaUploaderProvider),
    relay: ref.watch(relaySchedulerProvider),
    notifications: ref.watch(uploadNotificationsProvider),
    folder: UploadFolder(ref.watch(appCacheDirectoryProvider)),
    cachePath: ref.watch(chatCachePathProvider),
    accept: (message, {required postedFrom}) =>
        ref.read(chatServiceProvider).accept(message, postedFrom: postedFrom),
    clock: ref.watch(clockProvider),
  );
  unawaited(service.start());
  ref
    ..onDispose(service.dispose)
    ..listen(appForegroundProvider, (_, next) {
      if (next.value case final foreground?) {
        service.setForeground(foreground: foreground);
      }
    })
    ..listen(connectivityProvider, (_, next) {
      if (next.value case final online?) service.setOnline(online: online);
    }, fireImmediately: true);
  return service;
});

final fileVideoProvider = Provider<FileVideo>(
  (ref) => VideoPlayerController.file,
);

final urlVideoProvider = Provider<UrlVideo>(
  (ref) => VideoPlayerController.networkUrl,
);
