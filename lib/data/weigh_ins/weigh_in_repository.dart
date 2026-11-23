import 'package:fujin/data/database/calendar_date_hook.dart';
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/database/fujin_id.dart';
import 'package:fujin/data/database/fujin_table.dart';
import 'package:fujin/data/weigh_ins/ekklo_weigh_in_link.dart';
import 'package:fujin/data/weigh_ins/logged_weigh_in.dart';
import 'package:fujin/data/weigh_ins/mfp_weigh_in_link.dart';
import 'package:fujin/data/weigh_ins/weigh_in.dart';

final class WeighInRepository {
  const WeighInRepository({required this._database, required this._clock});

  static const _id = 'id';
  static const _date = 'date';
  static const _tracked =
      'deleted_at IS NULL OR id IN '
      '(SELECT weigh_in_id FROM mfp_weigh_in_link WHERE deleted_at IS NULL)';

  final FujinDatabase<FujinTable> _database;
  final DateTime Function() _clock;

  LoggedWeighIn? find(String weighInId) =>
      switch (_logged('id = ?', [weighInId], order: _id)) {
        [final logged] => logged,
        _ => null,
      };

  List<LoggedWeighIn> pending() =>
      _logged(_tracked, const [], order: 'date, deleted_at IS NULL, id');

  List<LoggedWeighIn> listed() => _logged(
    _tracked,
    const [],
    order: 'date DESC, deleted_at IS NOT NULL, id DESC',
  );

  Set<String> days() => {
    for (final {_date: String date} in _database.select(
      'SELECT DISTINCT date FROM weigh_in',
    ))
      date,
  };

  WeighIn save({required DateTime date, required double kilograms}) =>
      _database.transaction(() {
        final now = _now();
        final weighIn = switch (_liveOn(date)) {
          final live? => live.copyWith(kilograms: kilograms, updatedAt: now),
          null => WeighIn(
            id: FujinId.at(now),
            date: date,
            kilograms: kilograms,
            updatedAt: now,
          ),
        };
        _database.upsert(FujinTable.weighIn, weighIn.toMap(), key: const [_id]);
        return weighIn;
      });

  void remove(String weighInId) => _database.transaction(
    () => _database.softDelete(
      FujinTable.weighIn,
      'id = ?',
      [weighInId],
      _now(),
    ),
  );

  void importLinked(List<({DateTime date, double kilograms})> weights) =>
      _database.transaction(() {
        final now = _now();
        for (final (:date, :kilograms) in weights) {
          final weighIn = WeighIn(
            id: FujinId.at(now),
            date: date,
            kilograms: kilograms,
            updatedAt: now,
          );
          _database.insert(FujinTable.weighIn, weighIn.toMap());
          _saveEkkloLink(weighIn, now);
        }
      });

  void linkEkklo(WeighIn written) =>
      _database.transaction(() => _saveEkkloLink(written, _now()));

  void linkMfp(
    WeighIn written, {
    required String measurementId,
  }) => _database.transaction(() {
    final now = _now();
    final link = MfpWeighInLink(
      id: _liveLinkId(FujinTable.mfpWeighInLink, written.id) ?? FujinId.at(now),
      weighInId: written.id,
      measurementId: measurementId,
      date: written.date,
      kilograms: written.kilograms,
      updatedAt: now,
    );
    _database.upsert(
      FujinTable.mfpWeighInLink,
      link.toMap(),
      key: const [_id],
    );
  });

  void unlinkMfp(String weighInId) => _database.transaction(
    () => _database.softDelete(
      FujinTable.mfpWeighInLink,
      'weigh_in_id = ?',
      [weighInId],
      _now(),
    ),
  );

  List<WeighIn> weighIns() => [
    for (final row in _database.select('SELECT * FROM weigh_in ORDER BY id'))
      WeighInMapper.fromMap(row),
  ];

  List<EkkloWeighInLink> ekkloLinks() => [
    for (final row in _database.select(
      'SELECT * FROM ekklo_weigh_in_link ORDER BY weigh_in_id, id',
    ))
      EkkloWeighInLinkMapper.fromMap(row),
  ];

  List<MfpWeighInLink> mfpLinks() => [
    for (final row in _database.select(
      'SELECT * FROM mfp_weigh_in_link ORDER BY weigh_in_id, id',
    ))
      MfpWeighInLinkMapper.fromMap(row),
  ];

  void replaceAll({
    required List<WeighIn> weighIns,
    required List<EkkloWeighInLink> ekkloLinks,
    required List<MfpWeighInLink> mfpLinks,
  }) => _database.transaction(() {
    _database.execute('DELETE FROM weigh_in');
    for (final weighIn in weighIns) {
      _database.insert(FujinTable.weighIn, weighIn.toMap());
    }
    for (final link in ekkloLinks) {
      _database.insert(FujinTable.ekkloWeighInLink, link.toMap());
    }
    for (final link in mfpLinks) {
      _database.insert(FujinTable.mfpWeighInLink, link.toMap());
    }
  });

  DateTime _now() => _clock().toUtc();

  WeighIn? _liveOn(DateTime date) => switch (_database.select(
    'SELECT * FROM weigh_in WHERE date = ? AND deleted_at IS NULL',
    [CalendarDateHook.format(date)],
  )) {
    [final row] => WeighInMapper.fromMap(row),
    _ => null,
  };

  String? _liveLinkId(FujinTable table, String weighInId) =>
      switch (_database.select(
        'SELECT id FROM ${table.sqlName} '
        'WHERE weigh_in_id = ? AND deleted_at IS NULL',
        [weighInId],
      )) {
        [{_id: final String id}] => id,
        _ => null,
      };

  void _saveEkkloLink(WeighIn written, DateTime now) {
    final link = EkkloWeighInLink(
      id:
          _liveLinkId(FujinTable.ekkloWeighInLink, written.id) ??
          FujinId.at(now),
      weighInId: written.id,
      date: written.date,
      kilograms: written.kilograms,
      updatedAt: now,
    );
    _database.upsert(
      FujinTable.ekkloWeighInLink,
      link.toMap(),
      key: const [_id],
    );
  }

  List<LoggedWeighIn> _logged(
    String where,
    List<Object?> parameters, {
    required String order,
  }) {
    final ekkloOf = {
      for (final link in _liveLinks(
        FujinTable.ekkloWeighInLink,
        EkkloWeighInLinkMapper.fromMap,
      ))
        link.weighInId: link,
    };
    final mfpOf = {
      for (final link in _liveLinks(
        FujinTable.mfpWeighInLink,
        MfpWeighInLinkMapper.fromMap,
      ))
        link.weighInId: link,
    };
    final weighIns = [
      for (final row in _database.select(
        'SELECT * FROM weigh_in WHERE $where ORDER BY $order',
        parameters,
      ))
        WeighInMapper.fromMap(row),
    ];
    return [
      for (final weighIn in weighIns)
        LoggedWeighIn(
          weighIn: weighIn,
          ekkloLink: ekkloOf[weighIn.id],
          mfpLink: mfpOf[weighIn.id],
        ),
    ];
  }

  List<L> _liveLinks<L>(
    FujinTable table,
    L Function(Map<String, Object?> row) decode,
  ) => [
    for (final row in _database.select(
      'SELECT * FROM ${table.sqlName} WHERE deleted_at IS NULL',
    ))
      decode(row),
  ];
}
