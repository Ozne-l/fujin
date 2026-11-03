import 'package:fujin/data/database/calendar_date_hook.dart';
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/database/fujin_id.dart';
import 'package:fujin/data/database/fujin_table.dart';
import 'package:fujin/data/entries/day_changes.dart';
import 'package:fujin/data/entries/ekklo_link.dart';
import 'package:fujin/data/entries/entry.dart';
import 'package:fujin/data/entries/linked_item.dart';
import 'package:fujin/data/entries/logged_entry.dart';
import 'package:fujin/data/entries/mfp_link.dart';
import 'package:fujin/data/entries/mfp_write.dart';
import 'package:fujin/data/entries/stored_day.dart';
import 'package:fujin/data/entries/unattended_expectation.dart';
import 'package:fujin/data/foods/food_repository.dart';
import 'package:fujin/data/links/sent_link_repository.dart';
import 'package:fujin/data/meals/meal_repository.dart';
import 'package:fujin/data/unattended/unattended_item_repository.dart';

final class EntryRepository {
  const EntryRepository({
    required this._database,
    required this._foods,
    required this._meals,
    required this._links,
    required this._unattended,
    required this._clock,
  });

  final FujinDatabase _database;
  final FoodRepository _foods;
  final MealRepository _meals;
  final SentLinkRepository _links;
  final UnattendedItemRepository _unattended;
  final DateTime Function() _clock;

  StoredDay forDate(DateTime date) {
    final day = [CalendarDateHook.format(date)];
    return StoredDay(
      entries: _logged('entry.date = ? AND entry.deleted_at IS NULL', day),
      deleted: _logged(
        'entry.date = ? AND entry.deleted_at IS NOT NULL '
        'AND EXISTS (SELECT 1 FROM ekklo_link live '
        'WHERE live.entry_id = entry.id AND live.deleted_at IS NULL)',
        day,
      ),
      owed: _logged(
        'entry.id IN (SELECT entry_id FROM mfp_link '
        'WHERE deleted_at IS NULL AND date = ?) '
        'AND (entry.deleted_at IS NOT NULL OR entry.date <> ?)',
        [...day, ...day],
      ),
    );
  }

  List<MfpWrite> pendingMfp() => [
    for (final logged in _logged('entry.id IN ($_pendingIds)', const []))
      MfpWrite.of(logged) ??
          (throw StateError('Entry ${logged.entry.id} is not pending')),
  ];

  LoggedEntry? findAny(String entryId) =>
      switch (_logged('entry.id = ?', [entryId])) {
        [final logged] => logged,
        _ => null,
      };

  Set<String> heldMfpEntryIds(DateTime date) => {
    for (final {_mfpEntryId: String id} in _database.select(
      'SELECT mfp_entry_id FROM mfp_link WHERE deleted_at IS NULL AND date = ?',
      [CalendarDateHook.format(date)],
    ))
      id,
  };

  LoggedEntry? find(String entryId) => switch (_logged(
    'entry.id = ? AND entry.deleted_at IS NULL',
    [entryId],
  )) {
    [final logged] => logged,
    _ => null,
  };

  void store(DayChanges changes) => _database.transaction(() {
    final now = _now();
    final foods = {
      for (final food in changes.foods)
        food.id: _foods.copiedMfpFood(
          food.mfpFoodId,
          id: food.id,
          name: food.name,
          brand: food.brand,
        ),
    };
    final meals = {
      for (final meal in changes.meals)
        meal.id: _meals.mfpMeal(meal.mfpMealName, id: meal.id),
    };
    Entry resolvedEntry(Entry entry) => entry.copyWith(
      foodId: foods[entry.foodId] ?? entry.foodId,
      mealId: meals[entry.mealId] ?? entry.mealId,
      updatedAt: now,
    );
    EkkloLink resolvedLink(EkkloLink link) => link.copyWith(
      item: switch (link.item) {
        final item? => item.copyWith(
          foodId: foods[item.foodId] ?? item.foodId,
          mealId: meals[item.mealId] ?? item.mealId,
        ),
        null => null,
      },
      updatedAt: now,
    );
    for (final id in changes.droppedEkkloLinkIds) {
      _database.softDelete(FujinTable.ekkloLink, 'id = ?', [id], now);
    }
    for (final id in changes.deletedMfpLinkIds) {
      _database.softDelete(FujinTable.mfpLink, 'id = ?', [id], now);
    }
    for (final id in changes.deletedEntryIds) {
      _database.softDelete(FujinTable.entry, 'id = ?', [id], now);
    }
    for (final entry in changes.addedEntries) {
      _database.insert(FujinTable.entry, resolvedEntry(entry).toMap());
    }
    for (final entry in changes.changedEntries) {
      _saveEntry(resolvedEntry(entry));
    }
    for (final link in changes.changedMfpLinks) {
      _saveMfpLink(link.copyWith(updatedAt: now));
    }
    for (final link in changes.addedMfpLinks) {
      _database.insert(
        FujinTable.mfpLink,
        link.copyWith(updatedAt: now).toMap(),
      );
    }
    for (final link in changes.changedEkkloLinks) {
      _saveEkkloLink(resolvedLink(link));
    }
    for (final link in changes.addedEkkloLinks) {
      _database.insert(FujinTable.ekkloLink, resolvedLink(link).toMap());
    }
    if (changes.forgetsWaiting) {
      _links.forgetDate(changes.date);
      _unattended.forgetDate(changes.date);
    }
  });

  void saveEntry(Entry entry) => _database.transaction(
    () => _saveEntry(entry.copyWith(updatedAt: _now())),
  );

  void saveLink(MfpLink link, {Entry? entry}) => _database.transaction(() {
    final now = _now();
    if (entry case final entry?) {
      _saveEntry(entry.copyWith(updatedAt: now));
    }
    if (_mfpLinkHolding(link.mfpEntryId) case final copy?
        when copy.entryId != link.entryId) {
      _takeOver(copy.entryId, by: link.entryId, now: now);
    }
    final written = link.copyWith(updatedAt: now);
    _saveMfpLink(switch (_mfpLinkOf(link.entryId)) {
      final current? => written.copyWith(id: current.id),
      null => written,
    });
  });

  void unlinkMfp(String entryId) => _database.transaction(
    () => _database.softDelete(
      FujinTable.mfpLink,
      'entry_id = ?',
      [entryId],
      _now(),
    ),
  );

  void remove(String entryId) => _database.transaction(() {
    final now = _now();
    _database
      ..softDelete(FujinTable.entry, 'id = ?', [entryId], now)
      ..softDelete(
        FujinTable.ekkloLink,
        'entry_id = ? AND ekklo_item_id IS NULL',
        [entryId],
        now,
      );
  });

  void linkItem(
    String entryId, {
    required String ekkloMealId,
    required String ekkloItemId,
    Entry? sent,
  }) => _database.transaction(() {
    final now = _now();
    final item = LinkedItem.of(
      sent ?? _entryRow(entryId),
      ekkloMealId: ekkloMealId,
      ekkloItemId: ekkloItemId,
      sentAt: now,
    );
    _saveEkkloLink(switch (_ekkloLinkOf(entryId)) {
      final link? => link.copyWith(item: item, updatedAt: now),
      null => EkkloLink(
        id: FujinId.at(now),
        entryId: entryId,
        item: item,
        updatedAt: now,
      ),
    });
  });

  void refreshLink(String entryId, {Entry? sent}) => _database.transaction(() {
    if (_ekkloLinkOf(entryId) case EkkloLink(item: final item?) && final link) {
      _saveEkkloLink(
        link.copyWith(
          item: item.refreshedFrom(sent ?? _entryRow(entryId)),
          updatedAt: _now(),
        ),
      );
    }
  });

  void unlinkItem(String entryId) => _database.transaction(() {
    final now = _now();
    switch (_ekkloLinkOf(entryId)) {
      case EkkloLink(unattended: _?) && final link:
        _saveEkkloLink(link.copyWith(item: null, updatedAt: now));
      case final link?:
        _database.softDelete(FujinTable.ekkloLink, 'id = ?', [link.id], now);
      case null:
        return;
    }
  });

  void expect(Map<String, UnattendedExpectation> expectations) =>
      _database.transaction(() {
        final now = _now();
        for (final MapEntry(key: entryId, value: unattended)
            in expectations.entries) {
          _saveEkkloLink(switch (_ekkloLinkOf(entryId)) {
            final link? => link.copyWith(
              unattended: unattended,
              updatedAt: now,
            ),
            null => EkkloLink(
              id: FujinId.at(now),
              entryId: entryId,
              unattended: unattended,
              updatedAt: now,
            ),
          });
        }
      });

  void forgetExpectations(Iterable<String> entryIds) =>
      _database.transaction(() {
        final now = _now();
        for (final entryId in entryIds) {
          switch (_ekkloLinkOf(entryId)) {
            case EkkloLink(item: null) && final link:
              _database.softDelete(FujinTable.ekkloLink, 'id = ?', [
                link.id,
              ], now);
            case EkkloLink(unattended: _?) && final link:
              _saveEkkloLink(link.copyWith(unattended: null, updatedAt: now));
            case EkkloLink() || null:
              break;
          }
        }
      });

  List<Entry> entries() => [
    for (final row in _database.select('SELECT * FROM entry ORDER BY id'))
      EntryMapper.fromMap(row),
  ];

  List<MfpLink> mfpLinks() => [
    for (final row in _database.select(
      'SELECT * FROM mfp_link ORDER BY entry_id, id',
    ))
      MfpLinkMapper.fromMap(row),
  ];

  List<EkkloLink> ekkloLinks() => [
    for (final row in _database.select(
      'SELECT * FROM ekklo_link ORDER BY entry_id, id',
    ))
      EkkloLinkMapper.fromMap(row),
  ];

  void restore({
    required List<Entry> entries,
    required List<MfpLink> mfpLinks,
    required List<EkkloLink> ekkloLinks,
  }) => _database.transaction(() {
    for (final entry in entries) {
      _database.insert(FujinTable.entry, entry.toMap());
    }
    for (final link in mfpLinks) {
      _database.insert(FujinTable.mfpLink, link.toMap());
    }
    for (final link in ekkloLinks) {
      _database.insert(FujinTable.ekkloLink, link.toMap());
    }
  });

  DateTime _now() => _clock().toUtc();

  List<LoggedEntry> _logged(String where, List<Object?> parameters) {
    final mfpLinks = {
      for (final row in _database.select(
        'SELECT link.* FROM mfp_link link '
        'JOIN entry ON entry.id = link.entry_id '
        'WHERE link.deleted_at IS NULL AND $where',
        parameters,
      ))
        row[_entryId]: MfpLinkMapper.fromMap(row),
    };
    final ekkloLinks = {
      for (final row in _database.select(
        'SELECT link.* FROM ekklo_link link '
        'JOIN entry ON entry.id = link.entry_id '
        'WHERE link.deleted_at IS NULL AND $where',
        parameters,
      ))
        row[_entryId]: EkkloLinkMapper.fromMap(row),
    };
    return [
      for (final row in _database.select(
        'SELECT entry.*, food.name AS food_name, food.brand AS brand, '
        'mfp.external_id AS mfp_food_id, '
        'coalesce(mapping.name, meal.name) AS meal_name '
        'FROM entry '
        'JOIN food ON food.id = entry.food_id '
        'JOIN meal ON meal.id = entry.meal_id '
        'LEFT JOIN food_reference mfp ON mfp.food_id = food.id '
        "AND mfp.kind = 'mfp' AND mfp.deleted_at IS NULL "
        'LEFT JOIN meal_mapping mapping ON mapping.meal_id = meal.id '
        "AND mapping.connector = 'mfp' AND mapping.deleted_at IS NULL "
        'WHERE $where '
        'ORDER BY meal.position, entry.id',
        parameters,
      ))
        LoggedEntryMapper.fromMap({...row, _entry: row}).copyWith(
          mfpLink: mfpLinks[row[_id]],
          ekkloLink: ekkloLinks[row[_id]],
        ),
    ];
  }

  Entry _entryRow(String entryId) => switch (_database.select(
    'SELECT * FROM entry WHERE id = ?',
    [entryId],
  )) {
    [final row] => EntryMapper.fromMap(row),
    _ => throw StateError('No entry $entryId'),
  };

  MfpLink? _mfpLinkOf(String entryId) => switch (_database.select(
    'SELECT * FROM mfp_link WHERE entry_id = ? AND deleted_at IS NULL',
    [entryId],
  )) {
    [final row] => MfpLinkMapper.fromMap(row),
    _ => null,
  };

  MfpLink? _mfpLinkHolding(String mfpEntryId) => switch (_database.select(
    'SELECT * FROM mfp_link WHERE mfp_entry_id = ? AND deleted_at IS NULL',
    [mfpEntryId],
  )) {
    [final row] => MfpLinkMapper.fromMap(row),
    _ => null,
  };

  EkkloLink? _ekkloLinkOf(String entryId) => switch (_database.select(
    'SELECT * FROM ekklo_link WHERE entry_id = ? AND deleted_at IS NULL',
    [entryId],
  )) {
    [final row] => EkkloLinkMapper.fromMap(row),
    _ => null,
  };

  void _takeOver(
    String copyId, {
    required String by,
    required DateTime now,
  }) {
    _database
      ..softDelete(FujinTable.entry, 'id = ?', [copyId], now)
      ..softDelete(FujinTable.mfpLink, 'entry_id = ?', [copyId], now);
    switch ((_ekkloLinkOf(copyId), _ekkloLinkOf(by))) {
      case (null, _):
        return;
      case (final copied?, null):
        _saveEkkloLink(copied.copyWith(entryId: by, updatedAt: now));
      case (final copied?, final own?)
          when copied.item != null && own.item == null:
        _database.softDelete(FujinTable.ekkloLink, 'id = ?', [own.id], now);
        _saveEkkloLink(
          copied.copyWith(
            entryId: by,
            unattended: own.unattended,
            updatedAt: now,
          ),
        );
      case (final copied?, _):
        _database.softDelete(FujinTable.ekkloLink, 'id = ?', [copied.id], now);
    }
  }

  void _saveEntry(Entry entry) =>
      _database.upsert(FujinTable.entry, entry.toMap(), key: const [_id]);

  void _saveMfpLink(MfpLink link) =>
      _database.upsert(FujinTable.mfpLink, link.toMap(), key: const [_id]);

  void _saveEkkloLink(EkkloLink link) =>
      _database.upsert(FujinTable.ekkloLink, link.toMap(), key: const [_id]);

  static const _pendingIds =
      'SELECT entry.id FROM entry '
      'JOIN meal ON meal.id = entry.meal_id '
      'LEFT JOIN meal_mapping mapping ON mapping.meal_id = meal.id '
      "AND mapping.connector = 'mfp' AND mapping.deleted_at IS NULL "
      'LEFT JOIN food_reference mfp ON mfp.food_id = entry.food_id '
      "AND mfp.kind = 'mfp' AND mfp.deleted_at IS NULL "
      'LEFT JOIN mfp_link link ON link.entry_id = entry.id '
      'AND link.deleted_at IS NULL '
      'WHERE (entry.deleted_at IS NULL AND link.id IS NULL) '
      'OR (entry.deleted_at IS NOT NULL AND link.id IS NOT NULL) '
      'OR (entry.deleted_at IS NULL AND link.id IS NOT NULL AND ( '
      'link.date <> entry.date '
      'OR link.meal_name <> coalesce(mapping.name, meal.name) '
      'OR link.food_id IS NOT mfp.external_id '
      'OR link.servings <> entry.servings '
      'OR link.serving_value <> entry.serving_value '
      'OR link.serving_unit <> entry.serving_unit))';
  static const _id = 'id';
  static const _mfpEntryId = 'mfp_entry_id';
  static const _entryId = 'entry_id';
  static const _entry = 'entry';
}
