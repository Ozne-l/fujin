import 'package:fujin/data/database/fujin_id.dart';
import 'package:fujin/data/database/fujin_table.dart';
import 'package:fujin/data/database/schema.dart';
import 'package:sqlite3/sqlite3.dart';

final class FujinDatabase {
  FujinDatabase._(this._db) {
    _db
      ..execute('PRAGMA journal_mode = DELETE')
      ..execute('PRAGMA foreign_keys = ON')
      ..createFunction(
        functionName: FujinId.sqlFunction,
        function: (_) => FujinId.at(DateTime.timestamp()),
        argumentCount: const AllowedArgumentCount(0),
      );
    _migrate();
  }

  factory FujinDatabase.open(String path) =>
      FujinDatabase._(sqlite3.open(path));

  factory FujinDatabase.inMemory() => FujinDatabase._(sqlite3.openInMemory());

  static const fileName = 'fujin.db';

  final Database _db;
  final Map<FujinTable, List<String>> _tableColumns = {};

  int get schemaVersion => _db.userVersion;

  ResultSet select(String sql, [List<Object?> parameters = const []]) =>
      _db.select(sql, parameters);

  void execute(String sql, [List<Object?> parameters = const []]) =>
      _db.execute(sql, parameters);

  void insert(FujinTable table, Map<String, Object?> row) {
    final columns = _columnsFor(table, row);
    _db.execute(
      'INSERT INTO ${table.sqlName} (${columns.join(', ')}) '
      'VALUES (${_placeholders(columns.length)})',
      [for (final column in columns) row[column]],
    );
  }

  void upsert(
    FujinTable table,
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
    _db.execute(
      'INSERT INTO ${table.sqlName} (${columns.join(', ')}) '
      'VALUES (${_placeholders(columns.length)}) '
      'ON CONFLICT (${key.join(', ')}) $conflict',
      [for (final column in columns) row[column]],
    );
  }

  void softDelete(
    FujinTable table,
    String where,
    List<Object?> parameters,
    DateTime now,
  ) {
    final at = now.toIso8601String();
    _db.execute(
      'UPDATE ${table.sqlName} SET deleted_at = ?, updated_at = ? '
      'WHERE deleted_at IS NULL AND $where',
      [at, at, ...parameters],
    );
  }

  T transaction<T>(T Function() body) {
    if (!_db.autocommit) return body();
    _db.execute('BEGIN IMMEDIATE');
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

  void _migrate() {
    for (final (index, script) in schemaMigrations.indexed.skip(
      _db.userVersion,
    )) {
      transaction(() {
        _db
          ..execute(script)
          ..userVersion = index + 1;
      });
    }
  }

  List<String> _columnsFor(FujinTable table, Map<String, Object?> row) => {
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
