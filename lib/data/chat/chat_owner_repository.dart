import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/data/chat/cached_owner.dart';
import 'package:fujin/data/database/cache_table.dart';
import 'package:fujin/data/database/fujin_database.dart';

final class ChatOwnerRepository {
  const ChatOwnerRepository(this._database);

  final FujinDatabase<CacheTable> _database;

  EkkloUser? read() => switch (_database.select(
    'SELECT * FROM chat_owner WHERE id = ?',
    const [CachedOwner.onlyRow],
  )) {
    [final row] => EkkloUserMapper.fromMap(CachedOwnerMapper.fromMap(row).json),
    _ => null,
  };

  void save(EkkloUser owner) => _database.upsert(
    CacheTable.owner,
    CachedOwner(json: owner.toMap()).toMap(),
    key: const [_id],
  );

  static const _id = 'id';
}
