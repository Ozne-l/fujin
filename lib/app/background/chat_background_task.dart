import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fujin/app/app_environment.dart';
import 'package:fujin/app/background/chat_relay_task.dart';
import 'package:fujin/app/config.dart';
import 'package:fujin/data/chat/chat_owner_repository.dart';
import 'package:fujin/data/chat/chat_repository.dart';
import 'package:fujin/data/chat/foreground_stamp_repository.dart';
import 'package:fujin/data/database/cache_opening.dart';
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/dev_chat/fake_chat_server.dart';
import 'package:fujin/data/notifications/chat_notification_text.dart';
import 'package:fujin/data/notifications/chat_notifications.dart';
import 'package:fujin/data/notifications/local_chat_notifications.dart';
import 'package:fujin/data/sessions/secure_ekklo_token_store.dart';
import 'package:fujin/data/upload/workmanager_relay_scheduler.dart';
import 'package:fujin/domain/chat/notifications/chat_check.dart';
import 'package:fujin/domain/chat/notifications/chat_notification_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void dispatchChatBackgroundTask() => Workmanager().executeTask(
  (task, input) => switch (task) {
    WorkmanagerRelayScheduler.taskName => ChatRelayTask.run(input),
    _ => ChatBackgroundTask._run(),
  },
);

abstract final class ChatBackgroundTask {
  static Future<ChatCheck> check({
    required String cachePath,
    required EkkloClient ekklo,
    required ChatNotifications notifications,
    required DateTime Function() clock,
  }) async {
    switch (FujinDatabase.openCacheInBackground(cachePath)) {
      case CacheOutdated():
        return ChatCheck.outdatedCache;
      case CacheOpened(:final database):
        try {
          return await ChatNotificationService(
            ekklo: ekklo,
            chat: ChatRepository(database),
            owners: ChatOwnerRepository(database),
            stamps: ForegroundStampRepository(database),
            notifications: notifications,
            clock: clock,
          ).check();
        } finally {
          database.close();
        }
    }
  }

  static Future<bool> _run() async {
    final directory = await getApplicationSupportDirectory();
    final notifications = await LocalChatNotifications.forBackground(
      intl: ChatNotificationText.ofDevice(),
    );
    final ekklo = client();
    try {
      await check(
        cachePath: '${directory.path}/${FujinDatabase.cacheFileName}',
        ekklo: ekklo,
        notifications: notifications,
        clock: DateTime.now,
      );
      return true;
    } on EkkloException {
      return true;
    } finally {
      ekklo.close();
    }
  }

  static EkkloClient client() => switch (Config.environment) {
    AppEnvironment.production => EkkloClient(
      tokenStore: const SecureEkkloTokenStore(FlutterSecureStorage()),
      baseUri: Config.ekkloBaseUri,
    ),
    AppEnvironment.dev => FakeChatServer.client(),
  };
}
