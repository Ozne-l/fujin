import 'dart:io';

import 'package:fujin/data/database/cache_opening.dart';
import 'package:fujin/data/database/cache_schema.dart';
import 'package:fujin/data/database/cache_table.dart';
import 'package:fujin/data/database/database_table.dart';
import 'package:fujin/data/database/fujin_id.dart';
import 'package:fujin/data/database/fujin_table.dart';
import 'package:fujin/data/database/schema.dart';
import 'package:sqlite3/sqlite3.dart';

final class FujinDatabase<T extends DatabaseTable> {
  FujinDatabase._(this._db);

  static FujinDatabase<FujinTable> open(String path) =>
      _journal(sqlite3.open(path));

  static FujinDatabase<FujinTable> inMemory() =>
      _journal(sqlite3.openInMemory());

  static FujinDatabase<CacheTable> openCacheInApp(String path) {
    final database = _cache(sqlite3.open(path));
    if (database.schemaVersion == cacheVersion) return database;
    database.close();
    deleteCache(path);
    return _cache(sqlite3.open(path));
  }

  static CacheOpening openCacheInBackground(String path) {
    final database = _cache(sqlite3.open(path));
    if (database.schemaVersion == cacheVersion) return CacheOpened(database);
    database.close();
    return const CacheOutdated();
  }

  static FujinDatabase<CacheTable> cacheInMemory() =>
      _cache(sqlite3.openInMemory());

  static void deleteCache(String path) {
    for (final file in [
      File(path),
      File('$path$_walSuffix'),
      File('$path$_sharedMemorySuffix'),
    ]) {
      if (file.existsSync()) file.deleteSync();
    }
  }

  static const fileName = 'fujin.db';
  static const busyTimeout = Duration(seconds: 5);
  static const _cacheFileName = 'fujin-cache.db';
  static const _walSuffix = '-wal';
  static const _sharedMemorySuffix = '-shm';
  static const _absent = 0;
  static const _lockRetryPause = Duration(milliseconds: 10);

  static String cachePathIn(Directory directory) =>
      '${directory.path}/$_cacheFileName';

  final Database _db;
  final Map<T, List<String>> _tableColumns = {};

  int get schemaVersion => _db.userVersion;

  ResultSet select(String sql, [List<Object?> parameters = const []]) =>
      _waitingForLock(() => _db.select(sql, parameters));

  void execute(String sql, [List<Object?> parameters = const []]) =>
      _waitingForLock(() => _db.execute(sql, parameters));

  void insert(T table, Map<String, Object?> row) {
    final columns = _columnsFor(table, row);
    execute(
      'INSERT INTO ${table.sqlName} (${columns.join(', ')}) '
      'VALUES (${_placeholders(columns.length)})',
      [for (final column in columns) row[column]],
    );
  }

  void upsert(
    T table,
    Map<String, Object?> row, {
    required List<String> key,
  }) {
    final columns = _columnsFor(table, row);
    final updated = [
      for (final column in columns)
        if (!key.contains(column)) '$column = excluded.$column',
    ];
    final conflict = switch (updated) {
      [] => 'DO NOTHING',
      _ => 'DO UPDATE SET ${updated.join(', ')}',
    };
    execute(
      'INSERT INTO ${table.sqlName} (${columns.join(', ')}) '
      'VALUES (${_placeholders(columns.length)}) '
      'ON CONFLICT (${key.join(', ')}) $conflict',
      [for (final column in columns) row[column]],
    );
  }

  void softDelete(
    T table,
    String where,
    List<Object?> parameters,
    DateTime now,
  ) {
    final at = now.toIso8601String();
    execute(
      'UPDATE ${table.sqlName} SET deleted_at = ?, updated_at = ? '
      'WHERE deleted_at IS NULL AND $where',
      [at, at, ...parameters],
    );
  }

  R transaction<R>(R Function() body) {
    if (!_db.autocommit) return body();
    execute('BEGIN IMMEDIATE');
    try {
      final result = body();
      _db.execute('COMMIT');
      return result;
    } on Object {
      _db.execute('ROLLBACK');
      rethrow;
    }
  }

  void close() => _db.close();

  R _waitingForLock<R>(R Function() statement) {
    final waited = Stopwatch()..start();
    while (true) {
      try {
        return statement();
      } on SqliteException catch (error) {
        if (!_mayRetry(error, waited.elapsed)) rethrow;
        sleep(_lockRetryPause);
      }
    }
  }

  bool _mayRetry(SqliteException error, Duration waited) =>
      error.resultCode == SqlError.SQLITE_BUSY &&
      _db.autocommit &&
      waited < busyTimeout;

  static FujinDatabase<FujinTable> _journal(Database db) {
    final database = FujinDatabase<FujinTable>._(
      _connected(db)
        ..execute('PRAGMA journal_mode = DELETE')
        ..createFunction(
          functionName: FujinId.sqlFunction,
          function: (_) => FujinId.at(DateTime.timestamp()),
          argumentCount: const AllowedArgumentCount(0),
        ),
    );
    for (final (index, script) in schemaMigrations.indexed.skip(
      db.userVersion,
    )) {
      database.transaction(() {
        db
          ..execute(script)
          ..userVersion = index + 1;
      });
    }
    return database;
  }

  static FujinDatabase<CacheTable> _cache(Database db) {
    final database =
        FujinDatabase<CacheTable>._(
          _connected(db)..execute('PRAGMA journal_mode = WAL'),
        )..transaction(() {
          if (db.userVersion != _absent) return;
          db
            ..execute(cacheSchema)
            ..userVersion = cacheVersion;
        });
    return database;
  }

  static Database _connected(Database db) => db
    ..execute('PRAGMA busy_timeout = ${busyTimeout.inMilliseconds}')
    ..execute('PRAGMA foreign_keys = ON');

  List<String> _columnsFor(T table, Map<String, Object?> row) => {
    ...row.keys,
    ..._tableColumns.putIfAbsent(
      table,
      () => [
        for (final {'name': String name} in _db.select(
          'SELECT name FROM pragma_table_info(?)',
          [table.sqlName],
        ))
          name,
      ],
    ),
  }.toList();

  static String _placeholders(int count) => List.filled(count, '?').join(', ');
}
