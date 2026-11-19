import 'package:dart_mappable/dart_mappable.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/data/chat/cached_conversation.dart';
import 'package:fujin/data/chat/chat_owner_repository.dart';
import 'package:fujin/data/chat/chat_repository.dart';
import 'package:fujin/data/chat/foreground_stamp_repository.dart';
import 'package:fujin/data/notifications/chat_notifications.dart';
import 'package:fujin/domain/chat/notifications/chat_check.dart';
import 'package:fujin/domain/chat/notifications/chat_notices.dart';
import 'package:fujin/domain/chat/notifications/conversation_notice.dart';

final class ChatNotificationService {
  const ChatNotificationService({
    required this._ekklo,
    required this._chat,
    required this._owners,
    required this._stamps,
    required this._notifications,
    required this._clock,
  });

  static const foregroundGrace = Duration(minutes: 2);

  final EkkloClient _ekklo;
  final ChatRepository _chat;
  final ChatOwnerRepository _owners;
  final ForegroundStampRepository _stamps;
  final ChatNotifications _notifications;
  final DateTime Function() _clock;

  Future<ChatCheck> check() async {
    if (_stamps.last() case final at?
        when _clock().difference(at) < foregroundGrace) {
      return ChatCheck.recentlyInForeground;
    }
    final conversations = await _ekklo.messaging.conversations();
    final notices = chatNotices(
      conversations,
      previous: {
        for (final cached in _chat.conversations())
          cached.id: ?_decoded(cached),
      },
      ownerId: _owners.read()?.id,
    );
    for (final notice in notices) {
      await switch (notice) {
        ShowNotice(:final notification) => _notifications.show(notification),
        RemoveNotice(:final conversationId) => _notifications.cancel(
          conversationId,
        ),
      };
    }
    _chat.saveConversations([
      for (final conversation in conversations)
        CachedConversation(
          id: conversation.id,
          json: conversation.receivedJson,
        ),
    ]);
    return ChatCheck.notified;
  }

  static EkkloConversation? _decoded(CachedConversation cached) {
    try {
      return EkkloConversationMapper.fromMap(cached.json);
    } on MapperException {
      return null;
    }
  }
}
