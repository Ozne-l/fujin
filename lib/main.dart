import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fujin/app/app_environment.dart';
import 'package:fujin/app/background/chat_background_task.dart';
import 'package:fujin/app/config.dart';
import 'package:fujin/app/fujin_app.dart';
import 'package:fujin/app/notifications/chat_notification_text.dart';
import 'package:fujin/app/notifications/device_localizations.dart';
import 'package:fujin/app/providers.dart';
import 'package:fujin/app/splash_app.dart';
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/dev_chat/fake_chat_server.dart';
import 'package:fujin/data/dev_chat/seeded_fake_chat.dart';
import 'package:fujin/data/notifications/local_chat_notifications.dart';
import 'package:fujin/data/preferences/fujin_preferences.dart';
import 'package:fujin/data/settings/settings_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progressive_blur/progressive_blur.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final environment = Config.environment;
  final preferences = await FujinPreferences.open();
  runApp(
    SplashApp(
      environment: environment,
      appearance: SettingsRepository(preferences).appearance(),
    ),
  );
  final directory = await getApplicationSupportDirectory();
  final database = FujinDatabase.open(
    '${directory.path}/${FujinDatabase.fileName}',
  );
  final cacheDirectory = await getApplicationCacheDirectory();
  switch (environment) {
    case AppEnvironment.production:
      break;
    case AppEnvironment.dev:
      await FakeChatServer.start(
        seededFakeChat(origin: FakeChatServer.baseUri, now: DateTime.now()),
        loadAsset: rootBundle.load,
      );
  }
  final userAgent = await InAppWebViewController.getDefaultUserAgent();
  final package = await PackageInfo.fromPlatform();
  await ProgressiveBlurWidget.precache();
  final chatNotifications = await LocalChatNotifications.forApp(
    copy: ChatNotificationText(deviceLocalizations()),
    backgroundDispatcher: dispatchChatBackgroundTask,
  );
  runApp(
    ProviderScope(
      overrides: [
        appEnvironmentProvider.overrideWithValue(environment),
        databaseProvider.overrideWithValue(database),
        chatCachePathProvider.overrideWithValue(
          FujinDatabase.cachePathIn(directory),
        ),
        appCacheDirectoryProvider.overrideWithValue(cacheDirectory),
        mfpUserAgentProvider.overrideWithValue(userAgent),
        appVersionProvider.overrideWithValue(package.version),
        preferencesProvider.overrideWithValue(preferences),
        chatNotificationsProvider.overrideWithValue(chatNotifications),
      ],
      child: const FujinApp(),
    ),
  );
}
