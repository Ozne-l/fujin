import 'dart:convert';

import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/data/database/cache_table.dart';
import 'package:fujin/data/database/fujin_database.dart';

final class ChatOwnerRepository {
  const ChatOwnerRepository(this._database);

  final FujinDatabase<CacheTable> _database;

  EkkloUser? read() => switch (_database.select(
    'SELECT json FROM chat_owner WHERE id = ?',
    const [_onlyRow],
  )) {
    [{_json: final String json}] => EkkloUserMapper.fromJson(json),
    _ => null,
  };

  void save(EkkloUser owner) => _database.upsert(
    CacheTable.owner,
    {_id: _onlyRow, _json: jsonEncode(owner.toMap())},
    key: const [_id],
  );

  static const _id = 'id';
  static const _json = 'json';
  static const _onlyRow = 1;
}
