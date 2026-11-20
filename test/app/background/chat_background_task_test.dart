import 'dart:io';

import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart' show addTearDown, group, test;
import 'package:fujin/app/background/chat_background_task.dart';
import 'package:fujin/data/chat/foreground_stamp_repository.dart';
import 'package:fujin/data/database/cache_opening.dart';
import 'package:fujin/data/database/cache_schema.dart';
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/dev_chat/fake_chat.dart';
import 'package:fujin/domain/chat/notifications/chat_check.dart';

import '../../support/fake_backends.dart';
import '../../support/fake_chat_notifications.dart';
import '../../support/fixtures.dart';

const int _otherVersion = cacheVersion + 1;

String _cachePath() {
  final directory = Directory.systemTemp.createTempSync('fujin_cache_');
  addTearDown(() => directory.deleteSync(recursive: true));
  return FujinDatabase.cachePathIn(directory);
}

void main() {
  group('the background check', () {
    test('skips its run on a cache of another version, without calling '
        'Ekklo or changing the file', () async {
      final path = _cachePath();
      FujinDatabase.openCacheInApp(path)
        ..execute('PRAGMA user_version = $_otherVersion')
        ..close();
      final backends = FakeBackends();
      backends.chat.deliver(
        FakeChat.message(id: 'm-1', createdAt: now, content: 'Bravo'),
      );
      final notifications = FakeChatNotifications();

      final outcome = await ChatBackgroundTask.check(
        cachePath: path,
        ekklo: await backends.ekklo(),
        notifications: notifications,
        clock: () => now,
      );

      check(outcome).equals(ChatCheck.outdatedCache);
      check(backends.requests).isEmpty();
      check(notifications.shown).isEmpty();
      check(FujinDatabase.openCacheInBackground(path)).isA<CacheOutdated>();
    });

    test('skips its run when the app, on its own connection to the cache '
        'file, recorded a return to the foreground a minute ago', () async {
      final path = _cachePath();
      final app = FujinDatabase.openCacheInApp(path);
      addTearDown(app.close);
      ForegroundStampRepository(app).record(now);
      final backends = FakeBackends();

      final outcome = await ChatBackgroundTask.check(
        cachePath: path,
        ekklo: await backends.ekklo(),
        notifications: FakeChatNotifications(),
        clock: () => now.add(const Duration(minutes: 1)),
      );

      check(outcome).equals(ChatCheck.recentlyInForeground);
      check(backends.requests).isEmpty();
    });
  });
}
