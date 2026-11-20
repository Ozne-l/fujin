import 'package:fujin/data/chat/file_in_progress.dart';
import 'package:fujin/data/chat/message_in_progress.dart';
import 'package:fujin/data/database/cache_table.dart';
import 'package:fujin/data/database/fujin_database.dart';

final class MessageInProgressRepository {
  const MessageInProgressRepository(this._database);

  final FujinDatabase<CacheTable> _database;

  void start(MessageInProgress message, Iterable<FileInProgress> files) =>
      _database.transaction(() {
        _database.insert(CacheTable.messageInProgress, _rowOf(message));
        for (final file in files) {
          _database.insert(CacheTable.fileInProgress, file.toMap());
        }
      });

  void save(MessageInProgress message) => _database.upsert(
    CacheTable.messageInProgress,
    _rowOf(message),
    key: const [_id],
  );

  void saveFile(FileInProgress file) => _database.upsert(
    CacheTable.fileInProgress,
    file.toMap(),
    key: const [_id],
  );

  void completeFile(
    String fileId, {
    required String publicUrl,
    required DateTime at,
  }) => _database.execute(
    'UPDATE chat_file_in_progress SET completed_at = ? '
    'WHERE id = ? AND public_url = ? AND completed_at IS NULL',
    [at.toUtc().toIso8601String(), fileId, publicUrl],
  );

  MessageInProgress? message(String id) => switch (_database.select(
    'SELECT * FROM chat_message_in_progress WHERE id = ?',
    [id],
  )) {
    [final row] => MessageInProgressMapper.fromMap(row),
    _ => null,
  };

  List<MessageInProgress> inConversation(String conversationId) => [
    for (final row in _database.select(
      'SELECT * FROM chat_message_in_progress WHERE conversation_id = ? '
      'ORDER BY started_at, id',
      [conversationId],
    ))
      MessageInProgressMapper.fromMap(row),
  ];

  List<MessageInProgress> all() => [
    for (final row in _database.select(
      'SELECT * FROM chat_message_in_progress ORDER BY started_at, id',
    ))
      MessageInProgressMapper.fromMap(row),
  ];

  List<FileInProgress> files(String messageId) => [
    for (final row in _database.select(
      'SELECT * FROM chat_file_in_progress WHERE message_id = ? '
      'ORDER BY position',
      [messageId],
    ))
      FileInProgressMapper.fromMap(row),
  ];

  void delete(String id) => _database.execute(
    'DELETE FROM chat_message_in_progress WHERE id = ?',
    [id],
  );

  static Map<String, Object?> _rowOf(MessageInProgress message) =>
      message.copyWith(startedAt: message.startedAt.toUtc()).toMap();

  static const _id = 'id';
}
