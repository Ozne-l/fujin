import 'dart:async';
import 'dart:math';

import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/data/chat/cached_conversation.dart';
import 'package:fujin/data/chat/cached_message.dart';
import 'package:fujin/data/chat/chat_owner_repository.dart';
import 'package:fujin/data/chat/chat_repository.dart';
import 'package:fujin/data/chat/foreground_stamp_repository.dart';
import 'package:fujin/domain/chat/chat_change.dart';
import 'package:fujin/domain/chat/chat_link.dart';
import 'package:fujin/domain/chat/chat_state.dart';
import 'package:fujin/domain/chat/conversation_state.dart';
import 'package:fujin/domain/chat/pending_text.dart';
import 'package:fujin/domain/chat/pending_text_state.dart';
import 'package:fujin/domain/chat/reduce_chat_event.dart';
import 'package:fujin/domain/chat/sent_text.dart';
import 'package:fujin/domain/chat/toggle_reaction.dart';
import 'package:fujin/domain/chat/with_reaction.dart';

final class ChatService {
  ChatService({
    required this._messaging,
    required this._signedIn,
    required this._chats,
    required this._owners,
    required this._stamps,
    required this._clock,
    this._timer = Timer.new,
  });

  static const int pageSize = EkkloMessaging.pageSize;
  static const maxBackoff = Duration(seconds: 30);
  static const pendingPrefix = 'pending-';
  static const _unreadKey = 'unread_count';

  final EkkloMessaging _messaging;
  final Future<bool> Function() _signedIn;
  final ChatRepository _chats;
  final ChatOwnerRepository _owners;
  final ForegroundStampRepository _stamps;
  final DateTime Function() _clock;
  final Timer Function(Duration, void Function()) _timer;

  final _watchers = <StreamController<ChatState>>{};
  final _opened = <String, _Opened>{};
  final _pending = <String, List<PendingText>>{};
  final _deleting = <String>{};
  final _reading = <String>{};
  int _pendingCount = 0;
  EkkloUser? _owner;
  List<EkkloConversation> _conversations = const [];
  ChatLink _link = ChatLink.connecting;
  bool _decided = false;
  bool _foreground = false;
  bool _online = true;
  bool _disposed = false;
  EkkloMessagingSocket? _socket;
  Future<void>? _loop;
  Completer<void> _wake = Completer();

  ChatState get state => switch ((_owner, _decided)) {
    (null, false) => const ChatUnknown(),
    (null, true) => const ChatAbsent(),
    (final owner?, _) when !owner.settings.messaging => const ChatAbsent(),
    (final owner?, _) => ChatPresent(
      owner: owner,
      conversations: _conversations,
      link: _link,
    ),
  };

  Stream<ChatState> get states {
    late final StreamController<ChatState> controller;
    controller = StreamController(
      onListen: () {
        _watchers.add(controller);
        controller.add(state);
      },
      onCancel: () => _watchers.remove(controller),
    );
    return controller.stream;
  }

  void start() {
    _owner = _owners.read();
    _decided = _owner != null;
    _conversations = [
      for (final cached in _chats.conversations())
        EkkloConversationMapper.fromMap(cached.json),
    ];
    _emitChat();
    unawaited(refresh());
  }

  Future<void> refresh() async {
    if (_disposed) return;
    final signedIn = await _signedIn();
    if (_disposed) return;
    if (!signedIn) return _expire();
    if (_link == ChatLink.expired) _link = ChatLink.connecting;
    try {
      final owner = await _messaging.me();
      if (_disposed) return;
      _owners.save(owner);
      _owner = owner;
      _decided = true;
      if (_link == ChatLink.offline && _online) _link = ChatLink.connecting;
    } on EkkloAuthException {
      if (!_disposed) _expire();
      return;
    } on EkkloException {
      if (_disposed) return;
      _link = ChatLink.offline;
    }
    _emitAll();
    _ensureLoop();
  }

  void setForeground({required bool foreground}) {
    if (_foreground == foreground) return;
    _foreground = foreground;
    switch (foreground) {
      case true:
        _stamps.record(_clock());
        _readOpened();
        unawaited(refresh());
      case false:
        unawaited(_socket?.close());
        _wakeUp();
    }
  }

  void setOnline({required bool online}) {
    if (_online == online) return;
    _online = online;
    switch ((online, _link)) {
      case (_, ChatLink.expired):
        return;
      case (true, _):
        _link = ChatLink.connecting;
        _emitAll();
        switch (_owner) {
          case null:
            unawaited(refresh());
          case _:
            _ensureLoop();
        }
        _wakeUp();
      case (false, _):
        _link = ChatLink.offline;
        _emitAll();
        unawaited(_socket?.close());
        _wakeUp();
    }
  }

  Stream<ConversationState> watch(String conversationId) {
    late final StreamController<ConversationState> controller;
    controller = StreamController(
      onListen: () => _open(conversationId, controller),
      onCancel: () => _close(conversationId, controller),
    );
    return controller.stream;
  }

  EkkloMessage? message(String messageId) =>
      _decoded(_chats.message(messageId));

  Future<void> loadOlder(String conversationId) async {
    final opened = _opened[conversationId];
    if (opened == null || opened.loadingOlder) return;
    if (_hasCachedBeyond(conversationId, opened.limit + pageSize) ||
        opened.historyComplete) {
      opened.limit += pageSize;
      return _emitConversation(conversationId);
    }
    opened.loadingOlder = true;
    _emitConversation(conversationId);
    try {
      await opened.walk;
      if (_disposed) return;
      if (!_hasCachedBeyond(conversationId, opened.limit + pageSize) &&
          !opened.historyComplete) {
        await _fetchOlder(conversationId, opened);
      }
      opened.limit += pageSize;
    } on EkkloAuthException {
      _expire();
    } on EkkloException {
      return;
    } finally {
      opened.loadingOlder = false;
      if (!_disposed) _emitConversation(conversationId);
    }
  }

  Future<void> sendText(
    String conversationId,
    String content, {
    EkkloMessage? replyTo,
  }) async {
    final ownerId = _owner?.id;
    if (ownerId == null || _disposed) return;
    final pending = PendingText(
      message: EkkloMessage(
        id: '$pendingPrefix${++_pendingCount}',
        conversationId: conversationId,
        senderId: ownerId,
        type: EkkloMessageType.text,
        createdAt: _clock(),
        content: content,
        replyTo: switch (replyTo) {
          null => null,
          final quoted => EkkloReplyTo(
            id: quoted.id,
            senderId: quoted.senderId,
            content: quoted.content,
            type: quoted.type,
          ),
        },
      ),
      state: PendingTextState.sending,
      after: _chats.messages(conversationId, limit: 1).firstOrNull?.id,
    );
    _putPending(pending);
    await _post(pending);
  }

  Future<void> retryText(String conversationId, String pendingId) async {
    final ownerId = _owner?.id;
    final pending = _pending[conversationId]
        ?.where((pending) => pending.id == pendingId)
        .firstOrNull;
    if (ownerId == null ||
        pending == null ||
        pending.state != PendingTextState.failed) {
      return;
    }
    final sending = pending.copyWith(state: PendingTextState.sending);
    _putPending(sending);
    try {
      final page = await _messaging.messages(conversationId);
      if (_disposed) return;
      _chats.replaceNewestPage(conversationId, _cachedPage(page));
      if (sentText(sending, page.messages, ownerId: ownerId) != null) {
        _dropPending(sending);
        return _emitConversation(conversationId);
      }
    } on EkkloAuthException {
      _expire();
      return _putPending(pending);
    } on EkkloException {
      return _putPending(pending);
    }
    await _post(sending);
  }

  Future<void> react(String messageId, String emoji) async {
    final before = message(messageId);
    if (before == null) return;
    final mine = _isMine(before, emoji);
    accept(toggleReaction(before, emoji));
    try {
      final reaction = await switch (mine) {
        true => _messaging.removeReaction(
          before.conversationId,
          messageId,
          emoji,
        ),
        false => _messaging.addReaction(
          before.conversationId,
          messageId,
          emoji,
        ),
      };
      if (_disposed) return;
      if (message(messageId) case final current?) {
        accept(withReaction(current, reaction));
      }
    } on EkkloException catch (error) {
      if (_disposed) rethrow;
      if (message(messageId) case final current?
          when _isMine(current, emoji) != mine) {
        accept(toggleReaction(current, emoji));
      }
      if (error is EkkloAuthException) _expire();
      rethrow;
    }
  }

  void accept(EkkloMessage message) {
    if (_disposed) return;
    _chats.saveMessages([_cached(message)]);
    _emitConversation(message.conversationId);
  }

  Future<void> deleteMessage(String conversationId, String messageId) async {
    if (!_deleting.add(messageId)) return;
    _emitConversation(conversationId);
    try {
      await _messaging.deleteMessage(conversationId, messageId);
      if (!_disposed) _chats.removeMessage(messageId);
    } on EkkloAuthException {
      if (!_disposed) _expire();
      rethrow;
    } finally {
      _deleting.remove(messageId);
      if (!_disposed) _emitConversation(conversationId);
    }
  }

  void dispose() {
    _disposed = true;
    unawaited(_socket?.close());
    _wakeUp();
    for (final controller in [
      ..._watchers,
      for (final opened in _opened.values) ...opened.watchers,
    ]) {
      unawaited(controller.close());
    }
    _watchers.clear();
    _opened.clear();
  }

  bool get _connectable =>
      !_disposed &&
      _foreground &&
      _online &&
      _link != ChatLink.expired &&
      state is ChatPresent;

  void _ensureLoop() {
    if (_loop != null || !_connectable) return;
    _loop = _run().whenComplete(() {
      _loop = null;
      _ensureLoop();
    });
  }

  Future<void> _run() async {
    var attempt = 0;
    while (_connectable) {
      final EkkloMessagingSocket socket;
      try {
        socket = await _messaging.connectSocket();
      } on EkkloAuthException {
        return _expire();
      } on EkkloException {
        _setLink(ChatLink.offline);
        attempt++;
        await _backOff(attempt);
        continue;
      }
      if (!_connectable) {
        await socket.close();
        return;
      }
      _socket = socket;
      _stamps.record(_clock());
      _opened.keys.forEach(socket.focusConversation);
      _setLink(ChatLink.online);
      try {
        await _resync();
        attempt = 0;
      } on EkkloAuthException {
        await socket.close();
        return _expire();
      } on EkkloException {
        _socket = null;
        await socket.close();
        _setLink(ChatLink.offline);
        attempt++;
        await _backOff(attempt);
        continue;
      }
      final events = socket.events.listen(_apply);
      await socket.closed;
      await events.cancel();
      _socket = null;
      if (_link == ChatLink.online) _setLink(ChatLink.connecting);
    }
  }

  Future<void> _backOff(int attempt) async {
    if (!_connectable) return;
    final seconds = min(maxBackoff.inSeconds, pow(2, attempt).toInt());
    final elapsed = Completer<void>();
    final timer = _timer(Duration(seconds: seconds), elapsed.complete);
    await Future.any([elapsed.future, _wake.future]);
    timer.cancel();
  }

  void _wakeUp() {
    if (!_wake.isCompleted) _wake.complete();
    _wake = Completer();
  }

  Future<void> _resync() async {
    await _rereadConversations();
    for (final conversationId in [..._opened.keys]) {
      await _syncNewest(conversationId);
    }
  }

  Future<void> _rereadConversations() async {
    final conversations = await _messaging.conversations();
    if (_disposed) return;
    _chats.replaceConversations([
      for (final conversation in conversations)
        CachedConversation(
          id: conversation.id,
          json: conversation.receivedJson,
        ),
    ]);
    _conversations = conversations;
    _emitAll();
    _readOpened();
  }

  Future<void> _syncNewest(String conversationId) {
    final opened = _opened[conversationId];
    if (opened == null) return Future.value();
    return opened.walk ??= _walk(conversationId, opened).whenComplete(() {
      opened
        ..walk = null
        ..loadingNewest = false;
      if (!_disposed) _emitConversation(conversationId);
    });
  }

  Future<void> _walk(String conversationId, _Opened opened) async {
    var page = await _messaging.messages(conversationId);
    if (_disposed) return;
    var overlaps = _chats.holdsAny(page.messages.map((m) => m.id));
    _chats.replaceNewestPage(conversationId, _cachedPage(page));
    opened.loadingNewest = false;
    _emitConversation(conversationId);
    while (!overlaps && page.hasMore) {
      final oldest = page.messages.firstOrNull;
      if (oldest == null || !_opened.containsKey(conversationId)) return;
      page = await _messaging.messages(conversationId, beforeId: oldest.id);
      if (_disposed) return;
      overlaps = _chats.holdsAny(page.messages.map((m) => m.id));
      _chats.saveMessages(_cachedPage(page));
      _emitConversation(conversationId);
    }
    if (!page.hasMore) opened.historyComplete = true;
  }

  Future<void> _fetchOlder(String conversationId, _Opened opened) async {
    final oldest = _chats.oldestMessage(conversationId);
    if (oldest == null) return;
    final page = await _messaging.messages(
      conversationId,
      beforeId: oldest.id,
    );
    if (_disposed) return;
    _chats.saveMessages(_cachedPage(page));
    if (!page.hasMore) opened.historyComplete = true;
  }

  bool _hasCachedBeyond(String conversationId, int count) =>
      _chats.messages(conversationId, limit: count + 1).length > count;

  void _apply(EkkloMessagingEvent event) {
    final owner = _owner;
    if (owner == null || _disposed) return;
    final current = switch (event) {
      EkkloReactionEvent(:final messageId) => message(messageId),
      _ => null,
    };
    switch (reduceChatEvent(event, current: current, ownerId: owner.id)) {
      case MessageSaved(:final message):
        _chats.saveMessages([_cached(message)]);
        _emitConversation(message.conversationId);
      case MessageRemoved(:final conversationId, :final messageId):
        _chats.removeMessage(messageId);
        _emitConversation(conversationId);
      case NothingChanged():
        break;
    }
    if (event case EkkloNewMessage(
      :final message,
    ) when message.senderId != owner.id) {
      unawaited(_rereadQuietly());
    }
  }

  Future<void> _rereadQuietly() async {
    try {
      await _rereadConversations();
    } on EkkloAuthException {
      _expire();
    } on EkkloException {
      return;
    }
  }

  void _open(String conversationId, StreamController<ConversationState> to) {
    final opened = _opened.putIfAbsent(conversationId, _Opened.new);
    final first = opened.watchers.isEmpty;
    opened.watchers.add(to);
    if (first) {
      opened.loadingNewest = _chats.messages(conversationId, limit: 1).isEmpty;
      if (_socket case final socket?) {
        socket.focusConversation(conversationId);
        unawaited(_syncQuietly(conversationId));
      }
    }
    to.add(_settledState(conversationId, opened));
    if (first) _readOpened();
  }

  Future<void> _syncQuietly(String conversationId) async {
    try {
      await _syncNewest(conversationId);
    } on EkkloAuthException {
      _expire();
    } on EkkloException {
      return;
    }
  }

  void _close(String conversationId, StreamController<ConversationState> to) {
    final opened = _opened[conversationId];
    if (opened == null) return;
    opened.watchers.remove(to);
    if (opened.watchers.isEmpty) _opened.remove(conversationId);
  }

  Future<void> _post(PendingText pending) async {
    final text = pending.message;
    try {
      final sent = await _messaging.sendText(
        text.conversationId,
        text.content,
        replyToId: text.replyTo?.id,
      );
      if (_disposed) return;
      _dropPending(pending);
      accept(sent);
    } on EkkloAuthException {
      if (_disposed) return;
      _expire();
      _putPending(pending.copyWith(state: PendingTextState.failed));
    } on EkkloException {
      if (_disposed) return;
      _putPending(pending.copyWith(state: PendingTextState.failed));
    }
  }

  void _putPending(PendingText pending) {
    final conversationId = pending.message.conversationId;
    final texts = _pending[conversationId] ?? const [];
    _pending[conversationId] = switch (texts.any((t) => t.id == pending.id)) {
      true => [
        for (final text in texts)
          if (text.id == pending.id) pending else text,
      ],
      false => [...texts, pending],
    };
    _emitConversation(conversationId);
  }

  void _dropPending(PendingText pending) {
    final conversationId = pending.message.conversationId;
    final rest = [
      for (final text in _pending[conversationId] ?? const <PendingText>[])
        if (text.id != pending.id) text,
    ];
    switch (rest) {
      case []:
        _pending.remove(conversationId);
      case _:
        _pending[conversationId] = rest;
    }
  }

  static bool _isMine(EkkloMessage message, String emoji) => message.reactions
      .any((reaction) => reaction.emoji == emoji && reaction.mine);

  void _readOpened() {
    if (!_foreground || _disposed || _link == ChatLink.expired) return;
    for (final conversationId in _opened.keys) {
      final unread = _conversations
          .where((conversation) => conversation.id == conversationId)
          .firstOrNull
          ?.unreadCount;
      if ((unread ?? 0) > 0 && _reading.add(conversationId)) {
        unawaited(_markRead(conversationId));
      }
    }
  }

  Future<void> _markRead(String conversationId) async {
    try {
      await _messaging.markRead(conversationId);
      if (_disposed) return;
      _conversations = [
        for (final conversation in _conversations)
          if (conversation.id == conversationId)
            conversation.copyWith(
              unreadCount: 0,
              receivedJson: {...conversation.receivedJson, _unreadKey: 0},
            )
          else
            conversation,
      ];
      _chats.replaceConversations([
        for (final conversation in _conversations)
          CachedConversation(
            id: conversation.id,
            json: conversation.receivedJson,
          ),
      ]);
      _emitAll();
    } on EkkloAuthException {
      if (!_disposed) _expire();
    } on EkkloException {
      return;
    } finally {
      _reading.remove(conversationId);
    }
  }

  void _expire() {
    _link = ChatLink.expired;
    _decided = true;
    unawaited(_socket?.close());
    _wakeUp();
    _emitAll();
  }

  void _setLink(ChatLink link) {
    if (_link == link || _link == ChatLink.expired) return;
    _link = link;
    _emitAll();
  }

  void _emitAll() {
    _emitChat();
    [..._opened.keys].forEach(_emitConversation);
  }

  void _emitChat() {
    final current = state;
    for (final controller in _watchers) {
      controller.add(current);
    }
  }

  void _emitConversation(String conversationId) {
    final opened = _opened[conversationId];
    if (opened == null) return;
    final current = _settledState(conversationId, opened);
    for (final controller in opened.watchers) {
      controller.add(current);
    }
  }

  ConversationState _settledState(String conversationId, _Opened opened) {
    final built = _conversationState(conversationId, opened);
    final ownerId = _owner?.id;
    if (ownerId == null) return built;
    final arrived = [
      for (final text in built.pendingTexts)
        if (text.state == PendingTextState.failed &&
            sentText(text, built.messages, ownerId: ownerId) != null)
          text,
    ]..forEach(_dropPending);
    return switch (arrived) {
      [] => built,
      _ => built.copyWith(pendingTexts: [...?_pending[conversationId]]),
    };
  }

  ConversationState _conversationState(String conversationId, _Opened opened) {
    final rows = _chats.messages(conversationId, limit: opened.limit + 1);
    final beyond = rows.length > opened.limit;
    final present = switch (state) {
      final ChatPresent present => present,
      ChatUnknown() || ChatAbsent() => null,
    };
    return ConversationState(
      conversationId: conversationId,
      ownerId: _owner?.id,
      conversation: present?.conversation(conversationId),
      messages: [
        for (final row in beyond ? rows.skip(1) : rows)
          if (_decoded(row) case final message? when !message.internal) message,
      ],
      link: _link,
      loadingNewest:
          opened.loadingNewest &&
          (_link == ChatLink.connecting || _link == ChatLink.online),
      loadingOlder: opened.loadingOlder,
      hasOlder: beyond || (!opened.historyComplete && rows.isNotEmpty),
      protectsCapture: present?.protectsCapture(conversationId) ?? false,
      pendingTexts: [...?_pending[conversationId]],
      deleting: {..._deleting},
    );
  }

  static EkkloMessage? _decoded(CachedMessage? cached) => switch (cached) {
    null => null,
    final cached => EkkloMessageMapper.fromMap(cached.json),
  };

  static List<CachedMessage> _cachedPage(EkkloMessagePage page) => [
    for (final message in page.messages) _cached(message),
  ];

  static CachedMessage _cached(EkkloMessage message) => CachedMessage(
    id: message.id,
    conversationId: message.conversationId,
    createdAt: message.createdAt,
    json: message.receivedJson,
  );
}

final class _Opened {
  final watchers = <StreamController<ConversationState>>{};
  int limit = ChatService.pageSize;
  bool loadingNewest = false;
  bool loadingOlder = false;
  bool historyComplete = false;
  Future<void>? walk;
}
