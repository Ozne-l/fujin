import 'dart:async';
import 'dart:convert';

import 'package:ekklo_client/ekklo_client.dart';

typedef FakeChatJson = Map<String, Object?>;

typedef FakeChatReply = ({int status, Object? body});

final class FakeChat {
  FakeChat({
    required this.origin,
    FakeChatJson? owner,
    List<FakeChatJson>? conversations,
    List<FakeChatJson> messages = const [],
    this._clock = DateTime.now,
  }) : owner = owner ?? user(),
       conversations = conversations ?? [conversation()],
       messages = [...messages];

  static const ownerId = 'owner-1';
  static const coachId = 'coach-1';
  static const conversationId = 'conversation-1';
  static const ownerTokens = EkkloTokens(
    accessToken: 'fake-chat-access',
    refreshToken: 'fake-chat-refresh',
  );
  static const FakeChatJson coachPerson = {
    'id': coachId,
    'full_name': 'Nora Lindqvist',
    'first_name': 'Nora',
    'last_name': 'Lindqvist',
  };
  static const FakeChatJson customerPerson = {
    'id': ownerId,
    'full_name': 'Sam Okafor',
    'first_name': 'Sam',
    'last_name': 'Okafor',
  };
  static const uploadsPath = '/uploads/';
  static const mediaPath = '/media/';
  static const _messagingPrefix = '/api/v1/messaging';
  static const _uploadsPrefix = '/api/v1/uploads';
  static const _mePath = '/api/v1/users/me';
  static const _lastMessages = 3;
  static const _uploadValidity = Duration(hours: 1);

  final Uri origin;
  FakeChatJson owner;
  final List<FakeChatJson> conversations;
  final List<FakeChatJson> messages;
  final focused = <String>[];
  final DateTime Function() _clock;
  final _frames = StreamController<String>.broadcast();
  var _nextId = 0;

  Stream<String> get frames => _frames.stream;

  static bool serves(String path) =>
      path == _mePath ||
      path.startsWith(_messagingPrefix) ||
      path.startsWith(_uploadsPrefix);

  static FakeChatJson user({
    String id = ownerId,
    bool messaging = true,
    bool screenCaptureProtection = false,
    bool coachScreenCaptureProtection = false,
  }) => {
    'id': id,
    'settings': {'messaging': messaging},
    'screen_capture_protection': screenCaptureProtection,
    'coaches_settings': [
      {
        'coach_id': coachId,
        'screen_capture_protection': coachScreenCaptureProtection,
      },
    ],
  };

  static FakeChatJson conversation({
    String id = conversationId,
    bool canSend = true,
    int unreadCount = 0,
    FakeChatJson coach = coachPerson,
    FakeChatJson customer = customerPerson,
  }) => {
    'id': id,
    'can_send': canSend,
    'unread_count': unreadCount,
    'is_pinned': false,
    'coach': coach,
    'customer': customer,
  };

  static FakeChatJson message({
    required String id,
    required DateTime createdAt,
    String senderId = coachId,
    String conversationId = conversationId,
    String type = 'text',
    String content = '',
    List<String> mediaUrls = const [],
    FakeChatJson? replyTo,
    List<FakeChatJson> reactions = const [],
    FakeChatJson? contentRef,
    bool internal = false,
  }) => {
    'id': id,
    'conversation_id': conversationId,
    'sender_id': senderId,
    'message_type': type,
    'content': content,
    'media_urls': mediaUrls,
    'created_at': createdAt.toUtc().toIso8601String(),
    'internal': internal,
    'is_read': true,
    'reply_to': ?replyTo,
    if (reactions.isNotEmpty) 'reactions': reactions,
    'content_ref': ?contentRef,
  };

  static FakeChatJson reaction(
    String emoji, {
    int count = 1,
    bool mine = false,
  }) => {
    'emoji': emoji,
    'count': count,
    'mine': mine,
    'sample_user_ids': const <String>[],
  };

  FakeChatJson replyTo(String messageId) {
    final quoted = _message(messageId);
    return {
      'id': messageId,
      if (quoted?['sender_id'] case final String senderId) ...{
        'sender_id': senderId,
        'sender_name': _nameOf(senderId),
      },
      if (quoted?['content'] case final String content) 'content': content,
      if (quoted?['message_type'] case final String type) 'message_type': type,
      'deleted': quoted == null,
    };
  }

  FakeChatReply handle(String method, Uri url, Object? body) =>
      switch ((method, url.pathSegments)) {
        ('GET', ['api', 'v1', 'users', 'me']) => (status: 200, body: owner),
        ('GET', ['api', 'v1', 'messaging', 'conversations']) => (
          status: 200,
          body: {
            'conversations': [
              for (final conversation in conversations)
                _withLastMessages(conversation),
            ],
          },
        ),
        (
          'GET',
          ['api', 'v1', 'messaging', 'conversations', final id, 'messages'],
        ) =>
          _page(id, url.queryParameters),
        (
          'POST',
          ['api', 'v1', 'messaging', 'conversations', final id, 'messages'],
        ) =>
          _sendText(id, body),
        (
          'POST',
          ['api', 'v1', 'messaging', 'conversations', final id, 'direct-media'],
        ) =>
          _sendMedia(id, body),
        (
          'POST',
          [
            'api',
            'v1',
            'messaging',
            'conversations',
            final id,
            'voice-message',
          ],
        ) =>
          _sendVoice(id, body),
        (
          'POST',
          ['api', 'v1', 'messaging', 'conversations', final id, 'read'],
        ) =>
          _read(id),
        (
          'DELETE',
          [
            'api',
            'v1',
            'messaging',
            'conversations',
            _,
            'messages',
            final messageId,
          ],
        ) =>
          _deleteOwn(messageId),
        (
          'POST' || 'DELETE',
          [
            'api',
            'v1',
            'messaging',
            'conversations',
            _,
            'messages',
            final messageId,
            'reactions',
          ],
        ) =>
          _reactAsOwner(messageId, body, added: method == 'POST'),
        ('POST', ['api', 'v1', 'uploads', 'presigned-url']) => _presign(body),
        _ => (status: 404, body: null),
      };

  void receiveFrame(String text) {
    if (_decode(text) case {
      'event': 'focus_conversation',
      'data': {'conversation_id': final String id},
    }) {
      focused.add(id);
    }
  }

  void deliver(FakeChatJson message) {
    messages.add(message);
    if (message['sender_id'] != owner['id']) {
      _conversation(message['conversation_id'])?.update(
        'unread_count',
        (count) => (count as int? ?? 0) + 1,
        ifAbsent: () => 1,
      );
    }
    announce('new_message', message);
  }

  void edit(String messageId, String content) {
    final message = _message(messageId);
    if (message == null) return;
    message['content'] = content;
    announce('message_edited', message);
  }

  void delete(String messageId) {
    final message = _message(messageId);
    if (message == null) return;
    messages.remove(message);
    announce('message_deleted', {
      'conversation_id': message['conversation_id'],
      'message_id': messageId,
    });
  }

  FakeChatJson? react(
    String messageId,
    String emoji, {
    required String userId,
    required bool added,
  }) {
    final message = _message(messageId);
    if (message == null) return null;
    final byOwner = userId == owner['id'];
    final reactions = [
      for (final reaction
          in message['reactions'] as List<Object?>? ?? const <Object?>[])
        if (reaction case final FakeChatJson reaction) {...reaction},
    ];
    final existing = reactions
        .where((reaction) => reaction['emoji'] == emoji)
        .firstOrNull;
    final count = existing?['count'] as int? ?? 0;
    final mine = existing?['mine'] as bool? ?? false;
    final changes = !byOwner || mine != added;
    final newCount = switch ((changes, added)) {
      (false, _) => count,
      (true, true) => count + 1,
      (true, false) => count > 0 ? count - 1 : 0,
    };
    final newMine = byOwner ? added : mine;
    final updated = {...reaction(emoji, count: newCount, mine: newMine)};
    final next = switch ((existing, newCount)) {
      (_, 0) => [
        for (final reaction in reactions)
          if (reaction['emoji'] != emoji) reaction,
      ],
      (null, _) => [...reactions, updated],
      (_?, _) => [
        for (final reaction in reactions)
          if (reaction['emoji'] == emoji) updated else reaction,
      ],
    };
    if (next.isEmpty) {
      message.remove('reactions');
    } else {
      message['reactions'] = next;
    }
    announce(added ? 'reaction_added' : 'reaction_removed', {
      'conversation_id': message['conversation_id'],
      'message_id': messageId,
      'emoji': emoji,
      'new_count': newCount,
      'mine_now': added,
      'user_id': userId,
    });
    return {'emoji': emoji, 'count': newCount, 'mine': newMine};
  }

  void announce(String event, FakeChatJson data) {
    if (!_frames.isClosed) {
      _frames.add(jsonEncode({'event': event, 'data': data}));
    }
  }

  Future<void> close() => _frames.close();

  String nextId(String prefix) => '$prefix-${++_nextId}';

  FakeChatReply _page(String id, Map<String, String> query) {
    final ordered = [
      for (final message in messages)
        if (message['conversation_id'] == id) message,
    ]..sort((a, b) => _createdAt(a).compareTo(_createdAt(b)));
    final limit = int.tryParse(query['limit'] ?? '') ?? EkkloMessaging.pageSize;
    final before = switch (query['before_id']) {
      null => ordered.length,
      final beforeId => ordered.indexWhere((m) => m['id'] == beforeId),
    };
    final candidates = before < 0
        ? <FakeChatJson>[]
        : ordered.sublist(0, before);
    final page = candidates.sublist(
      candidates.length > limit ? candidates.length - limit : 0,
    );
    return (
      status: 200,
      body: {
        'messages': page,
        'has_more': candidates.length > limit,
        'total': page.length,
      },
    );
  }

  FakeChatReply _sendText(String id, Object? body) => switch (body) {
    {'content': final String content} => _created(
      id,
      status: 200,
      type: 'text',
      content: content,
      mediaUrls: const [],
      replyToId: body['reply_to_id'],
    ),
    _ => (status: 422, body: null),
  };

  FakeChatReply _sendMedia(String id, Object? body) => switch (body) {
    {'medias': final List<Object?> medias} => _created(
      id,
      status: 201,
      type: switch ({
        for (final media in medias)
          if (media case {'media_type': final String type}) type,
      }.toList()) {
        [final String only] => only,
        _ => 'mixed',
      },
      content: switch (body['caption']) {
        final String caption => caption,
        _ => '',
      },
      mediaUrls: [
        for (final media in medias)
          if (media case {'url': final String url}) url,
      ],
      replyToId: body['reply_to_id'],
    ),
    _ => (status: 422, body: null),
  };

  FakeChatReply _sendVoice(String id, Object? body) => switch (body) {
    {'url': final String url, 'duration': int()} => _created(
      id,
      status: 201,
      type: 'audio',
      content: '',
      mediaUrls: [url],
      replyToId: body['reply_to_id'],
    ),
    _ => (status: 422, body: null),
  };

  FakeChatReply _created(
    String conversationId, {
    required int status,
    required String type,
    required String content,
    required List<String> mediaUrls,
    required Object? replyToId,
  }) {
    if (_conversation(conversationId) == null) return (status: 404, body: null);
    final created = message(
      id: nextId('message'),
      createdAt: _clock(),
      senderId: '${owner['id']}',
      conversationId: conversationId,
      type: type,
      content: content,
      mediaUrls: mediaUrls,
      replyTo: switch (replyToId) {
        final String quoted => replyTo(quoted),
        _ => null,
      },
    );
    deliver(created);
    return (status: status, body: created);
  }

  FakeChatReply _read(String id) {
    final conversation = _conversation(id);
    if (conversation == null) return (status: 404, body: null);
    conversation['unread_count'] = 0;
    return (status: 200, body: null);
  }

  FakeChatReply _deleteOwn(String messageId) => switch (_message(messageId)) {
    null => (status: 404, body: null),
    {'message_type': 'text'} => _deleted(messageId),
    _ => (status: 500, body: null),
  };

  FakeChatReply _deleted(String messageId) {
    delete(messageId);
    return (status: 200, body: null);
  }

  FakeChatReply _reactAsOwner(
    String messageId,
    Object? body, {
    required bool added,
  }) => switch (body) {
    {'emoji': final String emoji} => switch (react(
      messageId,
      emoji,
      userId: '${owner['id']}',
      added: added,
    )) {
      null => (status: 404, body: null),
      final reaction => (status: 200, body: reaction),
    },
    _ => (status: 422, body: null),
  };

  FakeChatReply _presign(Object? body) => switch (body) {
    {'file_name': final String name} => _presigned(nextId('upload'), name),
    _ => (status: 422, body: null),
  };

  FakeChatReply _presigned(String id, String name) {
    final key = '$id-${Uri.encodeComponent(name)}';
    return (
      status: 200,
      body: {
        'upload_url': '${origin.resolve('$uploadsPath$key')}',
        'file_key': key,
        'public_url': '${origin.resolve('$mediaPath$key')}',
        'expires_at': _clock().add(_uploadValidity).toUtc().toIso8601String(),
      },
    );
  }

  FakeChatJson _withLastMessages(FakeChatJson conversation) {
    final newest = [
      for (final message in messages)
        if (message['conversation_id'] == conversation['id']) message,
    ]..sort((a, b) => _createdAt(b).compareTo(_createdAt(a)));
    return {
      ...conversation,
      if (newest.isNotEmpty) 'updated_at': newest.first['created_at'],
      'last_messages': [
        for (final message in newest.take(_lastMessages))
          {...message}..remove('media_urls'),
      ],
    };
  }

  FakeChatJson? _message(String id) =>
      messages.where((message) => message['id'] == id).firstOrNull;

  FakeChatJson? _conversation(Object? id) => conversations
      .where((conversation) => conversation['id'] == id)
      .firstOrNull;

  String? _nameOf(String senderId) => switch (conversations
      .map((conversation) => [conversation['coach'], conversation['customer']])
      .expand((people) => people)
      .whereType<FakeChatJson>()
      .where((person) => person['id'] == senderId)
      .firstOrNull) {
    {'full_name': final String name} => name,
    _ => null,
  };

  static DateTime _createdAt(FakeChatJson message) =>
      DateTime.parse('${message['created_at']}');

  static Object? _decode(String text) {
    try {
      return jsonDecode(text);
    } on FormatException {
      return null;
    }
  }
}
