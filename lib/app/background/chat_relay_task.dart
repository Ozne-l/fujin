import 'dart:io';

import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/app/background/chat_background_task.dart';
import 'package:fujin/data/chat/message_in_progress_repository.dart';
import 'package:fujin/data/database/cache_opening.dart';
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/notifications/chat_notification_text.dart';
import 'package:fujin/data/notifications/local_chat_notifications.dart';
import 'package:fujin/data/upload/local_upload_notifications.dart';
import 'package:fujin/data/upload/upload_folder.dart';
import 'package:fujin/data/upload/upload_notifications.dart';
import 'package:fujin/data/upload/workmanager_relay_scheduler.dart';
import 'package:fujin/domain/chat/upload/chat_relay.dart';
import 'package:fujin/domain/chat/upload/relay_outcome.dart';
import 'package:path_provider/path_provider.dart';

abstract final class ChatRelayTask {
  static Future<RelayOutcome> relay({
    required String cachePath,
    required String messageId,
    required EkkloClient ekklo,
    required UploadNotifications notifications,
    required UploadFolder folder,
    required DateTime Function() clock,
  }) async {
    switch (FujinDatabase.openCacheInBackground(cachePath)) {
      case CacheOutdated():
        return RelayOutcome.outdatedCache;
      case CacheOpened(:final database):
        try {
          return await ChatRelay(
            messaging: ekklo.messaging,
            messages: MessageInProgressRepository(database),
            notifications: notifications,
            folder: folder,
            cachePath: cachePath,
            clock: clock,
          ).relay(messageId);
        } finally {
          database.close();
        }
    }
  }

  static Future<bool> run(Map<String, dynamic>? input) async {
    final messageId = switch (input?[WorkmanagerRelayScheduler.messageKey]) {
      final String id => id,
      _ => null,
    };
    if (messageId == null) return true;
    final support = await getApplicationSupportDirectory();
    final cache = await getApplicationCacheDirectory();
    final intl = ChatNotificationText.ofDevice();
    await LocalChatNotifications.forBackground(intl: intl);
    final ekklo = ChatBackgroundTask.client();
    try {
      final outcome = await relay(
        cachePath:
            '${support.path}${Platform.pathSeparator}'
            '${FujinDatabase.cacheFileName}',
        messageId: messageId,
        ekklo: ekklo,
        notifications: LocalUploadNotifications(intl),
        folder: UploadFolder(cache),
        clock: DateTime.now,
      );
      return outcome.finished;
    } finally {
      ekklo.close();
    }
  }
}
