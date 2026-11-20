import 'dart:io';
import 'dart:isolate';

import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart' show addTearDown, group, test;
import 'package:fujin/data/chat/cached_conversation.dart';
import 'package:fujin/data/chat/chat_repository.dart';
import 'package:fujin/data/database/cache_opening.dart';
import 'package:fujin/data/database/cache_schema.dart';
import 'package:fujin/data/database/cache_table.dart';
import 'package:fujin/data/database/fujin_database.dart';

const int _otherVersion = cacheVersion + 1;
const _held = 'held';
const _holdFor = Duration(milliseconds: 300);
const _walSuffix = '-wal';
const _sharedMemorySuffix = '-shm';

CachedConversation _conversation(String id) =>
    CachedConversation(id: id, json: {'id': id});

String _cachePath() {
  final directory = Directory.systemTemp.createTempSync('fujin_cache_');
  addTearDown(() => directory.deleteSync(recursive: true));
  return FujinDatabase.cachePathIn(directory);
}

FujinDatabase<CacheTable> _outdatedCache(String path) {
  final database = FujinDatabase.openCacheInApp(path);
  ChatRepository(database).saveConversations([_conversation('c-old')]);
  return database..execute('PRAGMA user_version = $_otherVersion');
}

Object? _pragma(FujinDatabase<CacheTable> database, String name) =>
    database.select('PRAGMA $name').single.columnAt(0);

void _holdWriteLock((String, SendPort) message) {
  final (path, port) = message;
  switch (FujinDatabase.openCacheInBackground(path)) {
    case CacheOpened(:final database):
      database.transaction(() {
        ChatRepository(database).saveConversations([_conversation('c-held')]);
        port.send(_held);
        sleep(_holdFor);
      });
      database.close();
    case CacheOutdated():
      port.send(null);
  }
}

void main() {
  group('the cache file', () {
    test('is created with its tables at the cache version, in WAL, with a '
        'busy timeout of 5 s', () {
      final database = FujinDatabase.openCacheInApp(_cachePath());
      addTearDown(database.close);

      check(database.schemaVersion).equals(cacheVersion);
      check(_pragma(database, 'journal_mode')).equals('wal');
      check(
        _pragma(database, 'busy_timeout'),
      ).equals(FujinDatabase.busyTimeout.inMilliseconds);
      check(_pragma(database, 'foreign_keys')).equals(1);
      check(
        [
          for (final row in database.select(
            "SELECT name FROM sqlite_master WHERE type = 'table' ORDER BY name",
          ))
            row.columnAt(0),
        ],
      ).unorderedEquals([for (final table in CacheTable.values) table.sqlName]);
    });

    test('keeps its rows when opened again at the same version', () {
      final path = _cachePath();
      final first = FujinDatabase.openCacheInApp(path);
      ChatRepository(first).saveConversations([_conversation('c-1')]);
      first.close();

      final reopened = FujinDatabase.openCacheInApp(path);
      addTearDown(reopened.close);

      check(
        ChatRepository(reopened).conversations(),
      ).deepEquals([_conversation('c-1')]);
    });

    test('is created empty again by the app when its version differs', () {
      final path = _cachePath();
      _outdatedCache(path).close();

      final recreated = FujinDatabase.openCacheInApp(path);
      addTearDown(recreated.close);

      check(recreated.schemaVersion).equals(cacheVersion);
      check(ChatRepository(recreated).conversations()).isEmpty();
    });

    test('is left as it is by a background opener when its version '
        'differs', () {
      final path = _cachePath();
      _outdatedCache(path).close();

      check(FujinDatabase.openCacheInBackground(path)).isA<CacheOutdated>();
      check(FujinDatabase.openCacheInBackground(path)).isA<CacheOutdated>();
    });

    test('is created by a background opener that finds none', () {
      final opening = FujinDatabase.openCacheInBackground(_cachePath());
      if (opening case CacheOpened(:final database)) {
        addTearDown(database.close);
      }

      check(opening)
          .isA<CacheOpened>()
          .has((opened) => opened.database.schemaVersion, 'version')
          .equals(cacheVersion);
    });

    test('lets a second connection write while another isolate holds a write '
        'transaction', () async {
      final path = _cachePath();
      final database = FujinDatabase.openCacheInApp(path);
      addTearDown(database.close);
      final port = ReceivePort();
      addTearDown(port.close);
      final messages = port.asBroadcastStream();

      await Isolate.spawn(_holdWriteLock, (path, port.sendPort));
      check(await messages.first).equals(_held);
      ChatRepository(database).saveConversations([_conversation('c-app')]);

      check(
        ChatRepository(database).conversations(),
      ).deepEquals([_conversation('c-app'), _conversation('c-held')]);
    });

    test('is deleted with its -wal and -shm files', () {
      final path = _cachePath();
      final database = FujinDatabase.openCacheInApp(path);
      addTearDown(database.close);
      ChatRepository(database).saveConversations([_conversation('c-1')]);
      final files = [
        File(path),
        File('$path$_walSuffix'),
        File('$path$_sharedMemorySuffix'),
      ];
      check(files.every((file) => file.existsSync())).isTrue();

      FujinDatabase.deleteCache(path);

      check(files.any((file) => file.existsSync())).isFalse();
    });
  });
}
