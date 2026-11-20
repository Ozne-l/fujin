import 'dart:async';

import 'package:checks/checks.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter_test/flutter_test.dart' show addTearDown, group, test;
import 'package:fujin/data/chat/chat_owner_repository.dart';
import 'package:fujin/data/chat/chat_repository.dart';
import 'package:fujin/data/chat/foreground_stamp_repository.dart';
import 'package:fujin/data/database/cache_table.dart';
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/dev_chat/fake_chat.dart';
import 'package:fujin/domain/chat/chat_link.dart';
import 'package:fujin/domain/chat/chat_service.dart';
import 'package:fujin/domain/chat/chat_state.dart';
import 'package:fujin/domain/chat/conversation_state.dart';
import 'package:fujin/domain/chat/pending_text_state.dart';

import '../../support/fake_backends.dart';
import '../../support/until.dart';

final _start = DateTime.utc(2026, 11, 18, 8);

final class _FakeTimer implements Timer {
  _FakeTimer(this.duration, this._fire);

  final Duration duration;
  final void Function() _fire;
  bool _active = true;

  void fire() {
    if (!_active) return;
    _active = false;
    _fire();
  }

  @override
  void cancel() => _active = false;

  @override
  bool get isActive => _active;

  @override
  int get tick => 0;
}

final class _Chat {
  _Chat(this.backends, {this.cache, this._client});

  final FakeBackends backends;
  FujinDatabase<CacheTable>? cache;
  final EkkloClient? _client;
  final timers = <_FakeTimer>[];
  late final FujinDatabase<CacheTable> database;
  late final ChatService service;
  late final EkkloClient client;
  final _chatStates = <ChatState>[];

  DateTime? get stamp => ForegroundStampRepository(database).last();

  Iterable<String> get calls => backends.requests.map(
    (request) => '${request.method} ${request.url.path}',
  );

  int get messagePageReads => calls
      .where(
        (call) =>
            call ==
            'GET /api/v1/messaging/conversations/'
                '${FakeChat.conversationId}/messages',
      )
      .length;

  Future<_Chat> started({bool foreground = true}) async {
    database = cache ?? FujinDatabase.cacheInMemory();
    addTearDown(database.close);
    client = _client ?? await backends.ekklo();
    service = ChatService(
      messaging: client.messaging,
      signedIn: () => client.isSignedIn,
      chats: ChatRepository(database),
      owners: ChatOwnerRepository(database),
      stamps: ForegroundStampRepository(database),
      clock: () => _start,
      timer: (duration, fire) {
        final timer = _FakeTimer(duration, fire);
        timers.add(timer);
        return timer;
      },
    );
    addTearDown(service.dispose);
    service.states.listen(_chatStates.add);
    service.start();
    if (foreground) service.setForeground(foreground: true);
    return this;
  }

  Future<ChatState> chatWhere(bool Function(ChatState state) test) =>
      until(() => _chatStates.lastOrNull, test);

  Future<void> connected() =>
      until<int>(() => backends.socketConnections, (count) => count > 0);
}

final class _Watched {
  _Watched(ChatService service, String conversationId) {
    final subscription = service.watch(conversationId).listen(states.add);
    addTearDown(subscription.cancel);
  }

  final states = <ConversationState>[];

  Future<ConversationState> where(bool Function(ConversationState) test) =>
      until(() => states.lastOrNull, test);
}

FakeChatJson _text(String id, int minute, {String? senderId}) =>
    FakeChat.message(
      id: id,
      createdAt: _start.add(Duration(minutes: minute)),
      senderId: senderId ?? FakeChat.coachId,
      content: 'Message $id',
    );

List<FakeChatJson> _history(int count) => [
  for (var index = 0; index < count; index++) _text('m-$index', index),
];

Iterable<String> _ids(ConversationState state) =>
    state.messages.map((message) => message.id);

bool _ready(ConversationState state) =>
    !state.loadingNewest && state.link == ChatLink.online;

const _conversationsPath = '/api/v1/messaging/conversations';
const _conversations = 'GET $_conversationsPath';
const _conversationPath = '$_conversationsPath/${FakeChat.conversationId}';
const _postText = 'POST $_conversationPath/messages';
const _pageRead = 'GET $_conversationPath/messages';
const _markRead = 'POST $_conversationPath/read';

String _reactions(String messageId) =>
    '$_conversationPath/messages/$messageId/reactions';

Future<(_Chat, _Watched)> _opened(FakeBackends backends) async {
  final chat = await _Chat(backends).started();
  final watched = _Watched(chat.service, FakeChat.conversationId);
  await watched.where(_ready);
  return (chat, watched);
}

int _count(_Chat chat, String call) =>
    chat.calls.where((made) => made == call).length;

void main() {
  group('availability', () {
    test('is present with the unread count of every conversation', () async {
      final backends = FakeBackends(
        chat: FakeChat(
          origin: chatMediaUri,
          conversations: [
            FakeChat.conversation(unreadCount: 2),
            FakeChat.conversation(id: 'conversation-2', unreadCount: 3),
          ],
        ),
      );
      final chat = await _Chat(backends).started();

      final present = await chat.chatWhere(
        (state) => state is ChatPresent && state.conversations.length == 2,
      );

      check(present).isA<ChatPresent>()
        ..has((state) => state.unreadCount, 'unreadCount').equals(5)
        ..has((state) => state.owner.id, 'owner').equals(FakeChat.ownerId);
    });

    test('is absent when messaging is off for the account', () async {
      final backends = FakeBackends(
        chat: FakeChat(
          origin: chatMediaUri,
          owner: FakeChat.user(messaging: false),
        ),
      );
      final chat = await _Chat(backends).started();

      await chat.chatWhere((state) => state is ChatAbsent);

      check(backends.socketConnections).equals(0);
    });

    test('is absent when Ekklo is signed out and nothing is cached', () async {
      final backends = FakeBackends();
      final chat = await _Chat(
        backends,
        client: backends.ekkloWith(InMemoryEkkloTokenStore()),
      ).started();

      await chat.chatWhere((state) => state is ChatAbsent);

      check(chat.calls).isEmpty();
    });

    test('protects screen capture when the coach asks for it', () async {
      final backends = FakeBackends(
        chat: FakeChat(
          origin: chatMediaUri,
          owner: FakeChat.user(coachScreenCaptureProtection: true),
        ),
      );
      final chat = await _Chat(backends).started();

      final present = await chat.chatWhere((state) => state is ChatPresent);

      check(
            present,
          )
          .isA<ChatPresent>()
          .has(
            (state) => state.protectsCapture(FakeChat.conversationId),
            'protectsCapture',
          )
          .isTrue();
    });
  });

  group('a session that expires', () {
    test('keeps the cached conversation readable', () async {
      final cache = FujinDatabase.cacheInMemory();
      final backends = FakeBackends(
        chat: FakeChat(origin: chatMediaUri, messages: _history(3)),
      );
      final first = await _Chat(backends, cache: cache).started();
      final watched = _Watched(first.service, FakeChat.conversationId);
      await watched.where((state) => state.messages.length == 3);
      first.service.dispose();

      final store = InMemoryEkkloTokenStore();
      await store.write(FakeBackends.staleEkkloTokens);
      final again = _Chat(
        backends,
        cache: cache,
        client: backends.ekkloWith(store),
      );
      await again.started();
      final reopened = _Watched(again.service, FakeChat.conversationId);

      final expired = await again.chatWhere(
        (state) => state is ChatPresent && state.link == ChatLink.expired,
      );
      check(expired).isA<ChatPresent>();
      final state = await reopened.where(
        (state) => state.link == ChatLink.expired,
      );
      check(_ids(state)).deepEquals(['m-0', 'm-1', 'm-2']);
    });
  });

  group('offline', () {
    test(
      'shows the cache and comes back online when the network does',
      () async {
        final cache = FujinDatabase.cacheInMemory();
        final backends = FakeBackends(
          chat: FakeChat(origin: chatMediaUri, messages: _history(2)),
        );
        final first = await _Chat(backends, cache: cache).started();
        await _Watched(
          first.service,
          FakeChat.conversationId,
        ).where((state) => state.messages.length == 2);
        first.service.dispose();
        backends.ekkloReachable = false;

        final again = await _Chat(backends, cache: cache).started();
        final watched = _Watched(again.service, FakeChat.conversationId);
        final offline = await watched.where(
          (state) => state.link == ChatLink.offline,
        );
        check(_ids(offline)).deepEquals(['m-0', 'm-1']);
        check(offline.loadingNewest).isFalse();

        backends
          ..ekkloReachable = true
          ..chat.messages.add(_text('m-2', 2));
        again.service.setOnline(online: false);
        again.service.setOnline(online: true);

        final online = await watched.where(
          (state) =>
              state.link == ChatLink.online && state.messages.length == 3,
        );
        check(_ids(online)).deepEquals(['m-0', 'm-1', 'm-2']);
      },
    );

    test('retries the socket after 2, 4, 8, 16 then 30 seconds', () async {
      final backends = FakeBackends();
      final chat = await _Chat(backends).started();
      await chat.chatWhere((state) => state is ChatPresent);
      backends
        ..ekkloReachable = false
        ..dropSockets();

      for (var round = 0; round < 6; round++) {
        await until(() => chat.timers.length, (count) => count > round);
        chat.timers[round].fire();
      }
      await until(() => chat.timers.length, (count) => count > 6);

      check(
        chat.timers.map((timer) => timer.duration.inSeconds),
      ).deepEquals([2, 4, 8, 16, 30, 30, 30]);
    });

    test('backs off when the conversations cannot be read again after the '
        'socket connects', () async {
      final backends = FakeBackends();
      final chat = await _Chat(backends).started();
      await chat.chatWhere((state) => state is ChatPresent);
      final connections = backends.socketConnections;
      backends
        ..refusedChatCalls.add(_conversations)
        ..dropSockets();

      await until(() => chat.timers.length, (count) => count > 0);
      chat.timers.single.fire();
      await until(() => chat.timers.length, (count) => count > 1);

      check(
        chat.timers.map((timer) => timer.duration.inSeconds),
      ).deepEquals([2, 4]);
      check(backends.socketConnections).equals(connections + 2);
    });
  });

  group('a conversation', () {
    test('shows the newest page first, then older pages on demand', () async {
      final backends = FakeBackends(
        chat: FakeChat(origin: chatMediaUri, messages: _history(120)),
      );
      final chat = await _Chat(backends).started();
      final watched = _Watched(chat.service, FakeChat.conversationId);

      final newest = await watched.where(_ready);
      check(newest.messages).length.equals(ChatService.pageSize);
      check(newest.messages.first.id).equals('m-70');
      check(newest.messages.last.id).equals('m-119');
      check(newest.hasOlder).isTrue();

      await chat.service.loadOlder(FakeChat.conversationId);
      final older = await watched.where(
        (state) => state.messages.length == 100,
      );
      check(older.messages.first.id).equals('m-20');
      check(older.hasOlder).isTrue();

      await chat.service.loadOlder(FakeChat.conversationId);
      final all = await watched.where(
        (state) => state.messages.length == 120 && !state.loadingOlder,
      );
      check(all.messages.first.id).equals('m-0');
      check(all.hasOlder).isFalse();
      check(chat.messagePageReads).equals(3);
    });

    test('has no older page when the history fits in one', () async {
      final backends = FakeBackends(
        chat: FakeChat(
          origin: chatMediaUri,
          messages: _history(ChatService.pageSize),
        ),
      );
      final chat = await _Chat(backends).started();
      final watched = _Watched(chat.service, FakeChat.conversationId);

      final state = await watched.where(_ready);

      check(state.messages).length.equals(ChatService.pageSize);
      check(state.hasOlder).isFalse();
    });

    test('hides internal notes', () async {
      final backends = FakeBackends(
        chat: FakeChat(
          origin: chatMediaUri,
          messages: [
            _text('m-0', 0),
            FakeChat.message(
              id: 'note',
              createdAt: _start.add(const Duration(minutes: 1)),
              content: 'For the team',
              internal: true,
            ),
          ],
        ),
      );
      final chat = await _Chat(backends).started();

      final state = await _Watched(
        chat.service,
        FakeChat.conversationId,
      ).where(_ready);

      check(_ids(state)).deepEquals(['m-0']);
    });

    test('drops cached messages Ekklo no longer has', () async {
      final cache = FujinDatabase.cacheInMemory();
      final backends = FakeBackends(
        chat: FakeChat(origin: chatMediaUri, messages: _history(3)),
      );
      final first = await _Chat(backends, cache: cache).started();
      await _Watched(
        first.service,
        FakeChat.conversationId,
      ).where((state) => state.messages.length == 3);
      first.service.dispose();
      backends.chat.messages.removeAt(1);

      final again = await _Chat(backends, cache: cache).started();
      final state = await _Watched(
        again.service,
        FakeChat.conversationId,
      ).where((state) => _ready(state) && state.messages.length == 2);

      check(_ids(state)).deepEquals(['m-0', 'm-2']);
    });

    test('reads again the messages a broken walk left out', () async {
      final cache = FujinDatabase.cacheInMemory();
      final backends = FakeBackends(
        chat: FakeChat(origin: chatMediaUri, messages: _history(50)),
      );
      final first = await _Chat(backends, cache: cache).started();
      await _Watched(
        first.service,
        FakeChat.conversationId,
      ).where((state) => _ready(state) && state.messages.length == 50);
      first.service.dispose();
      backends.chat.messages.addAll([
        for (var index = 50; index < 170; index++) _text('m-$index', index),
      ]);
      final newest = backends.chatGates[_pageRead] = Completer();
      final readBefore = first.messagePageReads;

      final again = await _Chat(backends, cache: cache).started();
      final watched = _Watched(again.service, FakeChat.conversationId);
      await until(
        () => again.messagePageReads,
        (reads) => reads == readBefore + 1,
      );
      final older = backends.chatGates[_pageRead] = Completer();
      newest.complete();
      await until(
        () => again.messagePageReads,
        (reads) => reads == readBefore + 2,
      );
      backends.refusedChatCalls.add(_pageRead);
      older.complete();
      await until(() => again.timers, (timers) => timers.isNotEmpty);
      backends
        ..refusedChatCalls.clear()
        ..chatGates.remove(_pageRead);
      again.timers.last.fire();
      await until(() => backends.socketConnections, (count) => count == 2);
      var state = await watched.where(
        (state) => _ready(state) && state.messages.first.id == 'm-120',
      );
      while (state.hasOlder) {
        await again.service.loadOlder(FakeChat.conversationId);
        state = await watched.where((state) => !state.loadingOlder);
      }

      check(_ids(state)).deepEquals([
        for (var index = 0; index < 170; index++) 'm-$index',
      ]);
    });

    test('focuses the socket on it', () async {
      final backends = FakeBackends();
      final chat = await _Chat(backends).started();
      await chat.connected();

      _Watched(chat.service, FakeChat.conversationId);

      await until(
        () => backends.chat.focused,
        (focused) => focused.contains(FakeChat.conversationId),
      );
    });

    test('is re-read after the socket drops', () async {
      final backends = FakeBackends(
        chat: FakeChat(origin: chatMediaUri, messages: _history(2)),
      );
      final chat = await _Chat(backends).started();
      final watched = _Watched(chat.service, FakeChat.conversationId);
      await watched.where(
        (state) => _ready(state) && state.messages.length == 2,
      );

      backends.chat.messages.add(_text('m-2', 2));
      backends.dropSockets();

      final state = await watched.where(
        (state) => _ready(state) && state.messages.length == 3,
      );
      check(_ids(state)).deepEquals(['m-0', 'm-1', 'm-2']);
      check(backends.socketConnections).equals(2);
    });
  });

  group('live events', () {
    test('add, edit, react to and delete messages', () async {
      final backends = FakeBackends(
        chat: FakeChat(origin: chatMediaUri, messages: _history(1)),
      );
      final chat = await _Chat(backends).started();
      final watched = _Watched(chat.service, FakeChat.conversationId);
      await watched.where(
        (state) => _ready(state) && state.messages.length == 1,
      );

      backends.chat.deliver(_text('m-1', 1));
      await watched.where((state) => state.messages.length == 2);

      backends.chat.edit('m-1', 'Edited');
      await watched.where(
        (state) => state.messages.last.content == 'Edited',
      );

      backends.chat.react('m-1', '🔥', userId: FakeChat.coachId, added: true);
      final reacted = await watched.where(
        (state) => state.messages.last.reactions.isNotEmpty,
      );
      check(reacted.messages.last.reactions).deepEquals([
        const EkkloReaction(emoji: '🔥', count: 1),
      ]);

      backends.chat.delete('m-0');
      final state = await watched.where(
        (state) => state.messages.length == 1,
      );
      check(_ids(state)).deepEquals(['m-1']);
    });

    test('keep my messages seen when they come back unmarked', () async {
      final backends = FakeBackends(
        chat: FakeChat(
          origin: chatMediaUri,
          messages: [
            _text('m-0', 0, senderId: FakeChat.ownerId),
            _text('m-1', 1, senderId: FakeChat.ownerId),
          ],
        ),
      );
      final (chat, watched) = await _opened(backends);
      backends.chat.announce('message_read', {
        'conversation_id': FakeChat.conversationId,
        'message_id': 'm-1',
        'user_id': FakeChat.coachId,
      });
      await watched.where(
        (state) => state.messages.every((message) => message.readByOther),
      );

      backends.chat.edit('m-0', 'Edited');
      await watched.where(
        (state) => state.messages.first.content == 'Edited',
      );
      backends.chat.messages.add(_text('m-2', 2));
      backends.dropSockets();

      final state = await watched.where(
        (state) => _ready(state) && state.messages.length == 3,
      );
      check(
        state.messages.map((message) => message.readByOther),
      ).deepEquals([true, true, false]);
      check(backends.socketConnections).equals(2);
    });

    test('a coach message updates the unread count', () async {
      final backends = FakeBackends();
      final chat = await _Chat(backends).started();
      await chat.connected();
      await chat.chatWhere(
        (state) => state is ChatPresent && state.link == ChatLink.online,
      );

      backends.chat.deliver(_text('m-1', 1));

      await chat.chatWhere(
        (state) => state is ChatPresent && state.unreadCount == 1,
      );
    });
  });

  test('records when the app came to the foreground', () async {
    final chat = await _Chat(FakeBackends()).started(foreground: false);
    check(chat.stamp).isNull();

    chat.service.setForeground(foreground: true);

    check(chat.stamp).equals(_start);
  });

  test('closes the socket in the background', () async {
    final backends = FakeBackends();
    final chat = await _Chat(backends).started();
    await chat.connected();

    chat.service.setForeground(foreground: false);

    await chat.chatWhere(
      (state) => state is ChatPresent && state.link == ChatLink.connecting,
    );
    check(backends.socketConnections).equals(1);
  });

  group('a text', () {
    test('shows pending, then the message Ekklo answers', () async {
      final backends = FakeBackends(
        chat: FakeChat(origin: chatMediaUri, messages: _history(2)),
      );
      final (chat, watched) = await _opened(backends);
      final gate = backends.chatGates[_postText] = Completer();
      final quoted = chat.service.message('m-1');

      final sending = chat.service.sendText(
        FakeChat.conversationId,
        'Bien reçu',
        replyTo: quoted,
      );
      final pending = await watched.where(
        (state) => state.pendingTexts.isNotEmpty,
      );
      check(pending.pendingTexts.single)
        ..has((text) => text.state, 'state').equals(PendingTextState.sending)
        ..has((text) => text.message.replyTo?.id, 'replyTo').equals('m-1');
      gate.complete();
      await sending;

      final sent = await watched.where((state) => state.pendingTexts.isEmpty);
      check(sent.messages.last)
        ..has((message) => message.content, 'content').equals('Bien reçu')
        ..has((message) => message.replyTo?.id, 'replyTo').equals('m-1');
      check(
        _ids(sent).where((id) => id == sent.messages.last.id),
      ).length.equals(1);
    });

    test('stays failed when Ekklo refuses it, without retrying', () async {
      final backends = FakeBackends();
      final (chat, watched) = await _opened(backends);
      backends.refusedChatCalls.add(_postText);

      await chat.service.sendText(FakeChat.conversationId, 'Coucou');

      await watched.where(
        (state) =>
            state.pendingTexts.singleOrNull?.state == PendingTextState.failed,
      );
      await Future<void>.delayed(const Duration(milliseconds: 20));
      check(_count(chat, _postText)).equals(1);
    });

    test(
      'leaves on its own when its echo arrives through the socket',
      () async {
        final backends = FakeBackends(
          chat: FakeChat(origin: chatMediaUri, messages: _history(2)),
        );
        final (chat, watched) = await _opened(backends);
        backends.refusedChatCalls.add(_postText);
        await chat.service.sendText(FakeChat.conversationId, 'Message m-7');
        await watched.where(
          (state) =>
              state.pendingTexts.singleOrNull?.state == PendingTextState.failed,
        );

        backends.chat.deliver(_text('m-7', 7, senderId: FakeChat.ownerId));

        final settled = await watched.where(
          (state) => state.pendingTexts.isEmpty,
        );
        check(_ids(settled)).deepEquals(['m-0', 'm-1', 'm-7']);
        check(_count(chat, _postText)).equals(1);
      },
    );

    test(
      'stays failed when my identical text came before the attempt',
      () async {
        final backends = FakeBackends(
          chat: FakeChat(
            origin: chatMediaUri,
            messages: [
              _text('m-0', 0),
              _text('m-1', 1, senderId: FakeChat.ownerId),
            ],
          ),
        );
        final (chat, watched) = await _opened(backends);
        backends.refusedChatCalls.add(_postText);
        await chat.service.sendText(FakeChat.conversationId, 'Message m-1');
        await watched.where(
          (state) =>
              state.pendingTexts.singleOrNull?.state == PendingTextState.failed,
        );

        backends.chat.deliver(_text('m-2', 2));

        final state = await watched.where(
          (state) => state.messages.length == 3,
        );
        check(
          state.pendingTexts.single.state,
        ).equals(PendingTextState.failed);
      },
    );

    test('stays failed when the same text sent just before went', () async {
      final backends = FakeBackends(
        chat: FakeChat(origin: chatMediaUri, messages: _history(2)),
      );
      final (chat, watched) = await _opened(backends);
      final firstGate = backends.chatGates[_postText] = Completer();
      final first = chat.service.sendText(FakeChat.conversationId, 'ok');
      await until(() => _count(chat, _postText), (count) => count == 1);
      final secondGate = backends.chatGates[_postText] = Completer();
      final second = chat.service.sendText(FakeChat.conversationId, 'ok');
      await until(() => _count(chat, _postText), (count) => count == 2);

      firstGate.complete();
      await first;
      backends.refusedChatCalls.add(_postText);
      secondGate.complete();
      await second;

      final state = await watched.where(
        (state) =>
            state.messages.last.content == 'ok' &&
            state.pendingTexts.every(
              (text) => text.state != PendingTextState.sending,
            ),
      );
      check(state.pendingTexts.map((text) => text.state)).deepEquals([
        PendingTextState.failed,
      ]);
      check(
        state.messages.where((message) => message.content == 'ok'),
      ).length.equals(1);
    });

    test('is not sent twice when a retry finds it already arrived', () async {
      final backends = FakeBackends(
        chat: FakeChat(origin: chatMediaUri, messages: _history(2)),
      );
      final (chat, watched) = await _opened(backends);
      backends.refusedChatCalls.add(_postText);
      await chat.service.sendText(FakeChat.conversationId, 'Message m-7');
      final failed = await watched.where(
        (state) =>
            state.pendingTexts.singleOrNull?.state == PendingTextState.failed,
      );
      backends
        ..refusedChatCalls.clear()
        ..chat.messages.add(_text('m-7', 7, senderId: FakeChat.ownerId));

      await chat.service.retryText(
        FakeChat.conversationId,
        failed.pendingTexts.single.id,
      );

      final settled = await watched.where(
        (state) => state.pendingTexts.isEmpty,
      );
      check(_count(chat, _postText)).equals(1);
      check(_ids(settled)).deepEquals(['m-0', 'm-1', 'm-7']);
    });

    test('is sent again on retry when it never arrived', () async {
      final backends = FakeBackends(
        chat: FakeChat(origin: chatMediaUri, messages: _history(1)),
      );
      final (chat, watched) = await _opened(backends);
      backends.refusedChatCalls.add(_postText);
      await chat.service.sendText(FakeChat.conversationId, 'Encore');
      final failed = await watched.where(
        (state) =>
            state.pendingTexts.singleOrNull?.state == PendingTextState.failed,
      );
      backends.refusedChatCalls.clear();

      await chat.service.retryText(
        FakeChat.conversationId,
        failed.pendingTexts.single.id,
      );

      final sent = await watched.where((state) => state.pendingTexts.isEmpty);
      check(_count(chat, _postText)).equals(2);
      check(sent.messages.last.content).equals('Encore');
    });
  });

  group('a reaction', () {
    FakeBackends reacting({bool mine = false}) => FakeBackends(
      chat: FakeChat(
        origin: chatMediaUri,
        messages: [
          FakeChat.message(
            id: 'm-1',
            createdAt: _start,
            content: 'Bravo',
            reactions: [
              if (mine) FakeChat.reaction('👍', mine: true),
            ],
          ),
        ],
      ),
    );

    test('shows at once, then keeps the count Ekklo answers', () async {
      final backends = reacting();
      final (chat, watched) = await _opened(backends);
      final gate = backends.chatGates['POST ${_reactions('m-1')}'] =
          Completer();

      final pendingReaction = chat.service.react('m-1', '❤️');
      final optimistic = await watched.where(
        (state) => state.messages.single.reactions.isNotEmpty,
      );
      check(optimistic.messages.single.reactions.single)
        ..has((reaction) => reaction.count, 'count').equals(1)
        ..has((reaction) => reaction.mine, 'mine').isTrue();
      gate.complete();
      await pendingReaction;

      check(
        chat.service.message('m-1')?.reactions,
      ).isNotNull().deepEquals([
        const EkkloReaction(emoji: '❤️', count: 1, mine: true),
      ]);
    });

    test('is rolled back when Ekklo refuses it', () async {
      final backends = reacting();
      final (chat, watched) = await _opened(backends);
      backends.refusedChatCalls.add('POST ${_reactions('m-1')}');

      await check(
        chat.service.react('m-1', '❤️'),
      ).throws<EkkloException>();

      final state = await watched.where(
        (state) => state.messages.single.reactions.isEmpty,
      );
      check(state.messages.single.reactions).isEmpty();
    });

    test('of mine is removed when touched again', () async {
      final backends = reacting(mine: true);
      final (chat, watched) = await _opened(backends);

      await chat.service.react('m-1', '👍');

      await watched.where((state) => state.messages.single.reactions.isEmpty);
      check(
        _count(chat, 'DELETE ${_reactions('m-1')}'),
      ).equals(1);
    });
  });

  group('deleting', () {
    test('shows the message deleting until Ekklo removes it', () async {
      final backends = FakeBackends(
        chat: FakeChat(
          origin: chatMediaUri,
          messages: [_text('m-1', 1, senderId: FakeChat.ownerId)],
        ),
      );
      final (chat, watched) = await _opened(backends);
      final gate =
          backends.chatGates['DELETE $_conversationPath/messages/m-1'] =
              Completer();

      final deleting = chat.service.deleteMessage(
        FakeChat.conversationId,
        'm-1',
      );
      await watched.where((state) => state.deleting.contains('m-1'));
      gate.complete();
      await deleting;

      final deleted = await watched.where((state) => state.messages.isEmpty);
      check(deleted.deleting).isEmpty();
    });

    test('keeps a media message Ekklo cannot delete', () async {
      final backends = FakeBackends(
        chat: FakeChat(
          origin: chatMediaUri,
          messages: [
            FakeChat.message(
              id: 'm-1',
              createdAt: _start,
              senderId: FakeChat.ownerId,
              type: 'image',
              mediaUrls: ['$chatMediaUri/media/a.jpg'],
            ),
          ],
        ),
      );
      final (chat, watched) = await _opened(backends);

      await check(
        chat.service.deleteMessage(FakeChat.conversationId, 'm-1'),
      ).throws<EkkloMessageNotDeletedException>();

      final kept = await watched.where((state) => state.deleting.isEmpty);
      check(_ids(kept)).deepEquals(['m-1']);
    });
  });

  group('reading', () {
    FakeBackends unread(int count) => FakeBackends(
      chat: FakeChat(
        origin: chatMediaUri,
        conversations: [FakeChat.conversation(unreadCount: count)],
        messages: _history(1),
      ),
    );

    test('marks an open conversation with unread messages as read', () async {
      final backends = unread(2);
      final (chat, _) = await _opened(backends);

      final read = await chat.chatWhere(
        (state) => state is ChatPresent && state.unreadCount == 0,
      );

      check(read).isA<ChatPresent>();
      check(_count(chat, _markRead)).equals(1);
    });

    test('leaves a conversation without unread messages alone', () async {
      final backends = unread(0);
      final (chat, _) = await _opened(backends);
      await Future<void>.delayed(const Duration(milliseconds: 20));

      check(_count(chat, _markRead)).equals(0);
    });

    test('never marks read from the background', () async {
      final backends = unread(2);
      final chat = await _Chat(backends).started(foreground: false);
      _Watched(chat.service, FakeChat.conversationId);
      await chat.chatWhere((state) => state is ChatPresent);
      await Future<void>.delayed(const Duration(milliseconds: 20));

      check(_count(chat, _markRead)).equals(0);
    });

    test('marks read again when the coach writes while it is open', () async {
      final backends = unread(1);
      final (chat, _) = await _opened(backends);
      await until(() => _count(chat, _markRead), (count) => count == 1);
      await chat.chatWhere(
        (state) => state is ChatPresent && state.unreadCount == 0,
      );

      backends.chat.deliver(_text('m-9', 9));

      await until(() => _count(chat, _markRead), (count) => count == 2);
    });
  });
}
