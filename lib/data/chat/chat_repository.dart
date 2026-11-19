import 'dart:convert';

import 'package:fujin/data/chat/cached_conversation.dart';
import 'package:fujin/data/chat/cached_message.dart';
import 'package:fujin/data/database/cache_table.dart';
import 'package:fujin/data/database/epoch_microseconds_hook.dart';
import 'package:fujin/data/database/fujin_database.dart';

final class ChatRepository {
  const ChatRepository(this._database);

  final FujinDatabase<CacheTable> _database;

  List<CachedConversation> conversations() => [
    for (final row in _database.select(
      'SELECT * FROM chat_conversation ORDER BY id',
    ))
      CachedConversationMapper.fromMap(row),
  ];

  void saveConversations(Iterable<CachedConversation> conversations) =>
      _database.transaction(() {
        for (final conversation in conversations) {
          _database.upsert(
            CacheTable.conversation,
            conversation.toMap(),
            key: const [_id],
          );
        }
      });

  void replaceConversations(List<CachedConversation> conversations) =>
      _database.transaction(() {
        _database.execute(
          'DELETE FROM chat_conversation WHERE id NOT IN '
          '(SELECT value FROM json_each(?))',
          [
            jsonEncode([
              for (final conversation in conversations) conversation.id,
            ]),
          ],
        );
        saveConversations(conversations);
      });

  void saveMessages(Iterable<CachedMessage> messages) =>
      _database.transaction(() {
        for (final message in messages) {
          _database.upsert(
            CacheTable.message,
            message.toMap(),
            key: const [_id],
          );
        }
      });

  void replaceNewestPage(String conversationId, List<CachedMessage> page) =>
      _database.transaction(() {
        switch (page) {
          case []:
            _database.execute(
              'DELETE FROM chat_message WHERE conversation_id = ?',
              [conversationId],
            );
          case [final oldest, ...]:
            _database.execute(
              'DELETE FROM chat_message '
              'WHERE conversation_id = ? AND created_at >= ?',
              [conversationId, EpochMicrosecondsHook.format(oldest.createdAt)],
            );
        }
        saveMessages(page);
      });

  void removeMessage(String id) =>
      _database.execute('DELETE FROM chat_message WHERE id = ?', [id]);

  CachedMessage? message(String id) => switch (_database.select(
    'SELECT * FROM chat_message WHERE id = ?',
    [id],
  )) {
    [final row] => CachedMessageMapper.fromMap(row),
    _ => null,
  };

  CachedMessage? oldestMessage(String conversationId) =>
      switch (_database.select(
        'SELECT * FROM chat_message WHERE conversation_id = ? '
        'ORDER BY created_at, id LIMIT 1',
        [conversationId],
      )) {
        [final row] => CachedMessageMapper.fromMap(row),
        _ => null,
      };

  bool holdsAny(Iterable<String> ids) => switch (ids.toList()) {
    [] => false,
    final ids =>
      _database
          .select(
            'SELECT 1 FROM chat_message '
            'WHERE id IN (${List.filled(ids.length, '?').join(', ')}) LIMIT 1',
            ids,
          )
          .isNotEmpty,
  };

  List<CachedMessage> messages(
    String conversationId, {
    required int limit,
    String? before,
  }) => [
    for (final row in switch (before) {
      null => _database.select(
        'SELECT * FROM ( '
        'SELECT * FROM chat_message WHERE conversation_id = ? '
        'ORDER BY created_at DESC, id DESC LIMIT ? '
        ') ORDER BY created_at, id',
        [conversationId, limit],
      ),
      final before => _database.select(
        'SELECT * FROM ( '
        'SELECT * FROM chat_message WHERE conversation_id = ? '
        'AND (created_at, id) < '
        '(SELECT created_at, id FROM chat_message WHERE id = ?) '
        'ORDER BY created_at DESC, id DESC LIMIT ? '
        ') ORDER BY created_at, id',
        [conversationId, before, limit],
      ),
    })
      CachedMessageMapper.fromMap(row),
  ];

  static const _id = 'id';
}
