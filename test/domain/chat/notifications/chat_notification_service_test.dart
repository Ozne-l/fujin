import 'dart:ui';

import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart'
    show addTearDown, group, setUp, test;
import 'package:fujin/data/chat/chat_owner_repository.dart';
import 'package:fujin/data/chat/chat_repository.dart';
import 'package:fujin/data/chat/foreground_stamp_repository.dart';
import 'package:fujin/data/database/cache_table.dart';
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/dev_chat/fake_chat.dart';
import 'package:fujin/data/notifications/chat_notification_text.dart';
import 'package:fujin/domain/chat/notifications/chat_check.dart';
import 'package:fujin/domain/chat/notifications/chat_notification_service.dart';
import 'package:fujin/domain/chat/notifications/notified_message.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';

import '../../../support/fake_backends.dart';
import '../../../support/fake_chat_notifications.dart';
import '../../../support/fixtures.dart';

const String _conversation = FakeChat.conversationId;
const _messaging = '/api/v1/messaging';

final AppLocalizations _french = lookupAppLocalizations(const Locale('fr'));

void main() {
  late FakeBackends backends;
  late FujinDatabase<CacheTable> cache;
  late FakeChatNotifications notifications;

  setUp(() {
    backends = FakeBackends();
    cache = FujinDatabase.cacheInMemory();
    addTearDown(cache.close);
    notifications = FakeChatNotifications();
  });

  Future<ChatCheck> runCheck() async => ChatNotificationService(
    ekklo: await backends.ekklo(),
    chat: ChatRepository(cache),
    owners: ChatOwnerRepository(cache),
    stamps: ForegroundStampRepository(cache),
    notifications: notifications,
    clock: () => now,
  ).check();

  void deliver(String id, String content, {required int minutesAgo}) =>
      backends.chat.deliver(
        FakeChat.message(
          id: id,
          createdAt: now.subtract(Duration(minutes: minutesAgo)),
          content: content,
        ),
      );

  List<String> shownTexts() => [
    for (final message
        in notifications.shown[_conversation]?.messages ??
            const <NotifiedMessage>[])
      ChatNotificationText.of(_french, message.content),
  ];

  List<String> messagingCalls() => [
    for (final request in backends.requests)
      if (request.url.path.startsWith(_messaging))
        '${request.method} ${request.url.path}',
  ];

  group('a background check', () {
    test("shows the coach's unread messages after reading only the "
        'conversations list', () async {
      deliver('m-1', 'Top séance 💪', minutesAgo: 20);
      deliver('m-2', 'Et le dîner ?', minutesAgo: 10);

      check(await runCheck()).equals(ChatCheck.notified);

      check(shownTexts()).deepEquals(['Top séance 💪', 'Et le dîner ?']);
      check(
        notifications.shown[_conversation]?.coachName,
      ).equals('Nora Lindqvist');
      check(
        messagingCalls(),
      ).deepEquals(['GET $_messaging/conversations']);
    });

    test('labels a media message by its type, as the list carries no '
        'URLs', () async {
      backends.chat.deliver(
        FakeChat.message(
          id: 'm-1',
          createdAt: now.subtract(const Duration(minutes: 5)),
          type: 'image',
          mediaUrls: ['global/photo.jpg'],
          content: 'Ton assiette idéale',
        ),
      );

      await runCheck();

      check(shownTexts()).deepEquals(['Photo · Ton assiette idéale']);
    });

    test('does not show the same messages twice, then shows them all '
        'again with a newer one', () async {
      deliver('m-1', 'Bravo', minutesAgo: 20);
      await runCheck();
      notifications.shown.clear();

      await runCheck();
      check(notifications.shown).isEmpty();

      deliver('m-2', 'Et demain ?', minutesAgo: 1);
      await runCheck();
      check(shownTexts()).deepEquals(['Bravo', 'Et demain ?']);
    });

    test('removes the notification once the conversation was read '
        'elsewhere', () async {
      deliver('m-1', 'Bravo', minutesAgo: 20);
      await runCheck();

      backends.chat.conversations.single['unread_count'] = 0;
      await runCheck();

      check(notifications.shown).isEmpty();
      check(notifications.cancelled).contains(_conversation);
    });

    test('skips its run within 2 minutes of the last return to Fūjin, '
        'without calling Ekklo', () async {
      deliver('m-1', 'Bravo', minutesAgo: 20);
      ForegroundStampRepository(
        cache,
      ).record(now.subtract(const Duration(minutes: 1, seconds: 59)));
      final callsBefore = messagingCalls().length;

      check(await runCheck()).equals(ChatCheck.recentlyInForeground);

      check(messagingCalls().length).equals(callsBefore);
      check(notifications.shown).isEmpty();
    });

    test('runs again 2 minutes after the last return to Fūjin', () async {
      deliver('m-1', 'Bravo', minutesAgo: 20);
      ForegroundStampRepository(
        cache,
      ).record(now.subtract(ChatNotificationService.foregroundGrace));

      check(await runCheck()).equals(ChatCheck.notified);

      check(shownTexts()).deepEquals(['Bravo']);
    });
  });
}
