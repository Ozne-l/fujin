import 'dart:io';

import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart' show addTearDown, test;
import 'package:fujin/app/background/chat_relay_task.dart';
import 'package:fujin/data/database/cache_opening.dart';
import 'package:fujin/data/database/cache_schema.dart';
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/upload/upload_folder.dart';
import 'package:fujin/domain/chat/upload/relay_outcome.dart';

import '../../support/fake_backends.dart';
import '../../support/fake_upload_notifications.dart';
import '../../support/fixtures.dart';

const int _otherVersion = cacheVersion + 1;

void main() {
  test('the relay skips a cache of another version, without calling Ekklo '
      'or changing the file', () async {
    final directory = Directory.systemTemp.createTempSync('fujin_relay_task_');
    addTearDown(() => directory.deleteSync(recursive: true));
    final path = '${directory.path}/${FujinDatabase.cacheFileName}';
    FujinDatabase.openCacheInApp(path)
      ..execute('PRAGMA user_version = $_otherVersion')
      ..close();
    final backends = FakeBackends();

    final outcome = await ChatRelayTask.relay(
      cachePath: path,
      messageId: 'm-1',
      ekklo: await backends.ekklo(),
      notifications: FakeUploadNotifications(),
      folder: UploadFolder(directory),
      clock: () => now,
    );

    check(outcome).equals(RelayOutcome.outdatedCache);
    check(outcome.finished).isTrue();
    check(backends.requests).isEmpty();
    check(FujinDatabase.openCacheInBackground(path)).isA<CacheOutdated>();
  });
}
