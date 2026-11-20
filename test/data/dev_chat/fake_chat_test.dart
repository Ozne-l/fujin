import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:checks/checks.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter_test/flutter_test.dart' show addTearDown, group, test;
import 'package:fujin/data/dev_chat/dev_chat_asset.dart';
import 'package:fujin/data/dev_chat/fake_chat.dart';
import 'package:fujin/data/dev_chat/fake_chat_server.dart';
import 'package:fujin/data/dev_chat/seeded_fake_chat.dart';
import 'package:http/http.dart' as http;

import '../../support/fake_backends.dart';

final _now = DateTime.utc(2026, 11, 18, 20);
final _assetBytes = Uint8List.fromList(List.generate(64, (index) => index));

Future<EkkloMessaging> _messaging(FakeChat chat) async =>
    (await FakeBackends(chat: chat).ekklo()).messaging;

FakeChatJson _text(
  String id,
  int minute, {
  String senderId = FakeChat.coachId,
}) => FakeChat.message(
  id: id,
  createdAt: _now.add(Duration(minutes: minute)),
  senderId: senderId,
  content: 'Message $id',
);

void main() {
  group('the fake Ekklo chat', () {
    test('answers pages oldest first, older pages before an id', () async {
      final messaging = await _messaging(
        FakeChat(
          origin: chatMediaUri,
          messages: [
            for (var index = 0; index < 5; index++) _text('m-$index', index),
          ],
        ),
      );

      final newest = await messaging.messages(
        FakeChat.conversationId,
        limit: 3,
      );
      final older = await messaging.messages(
        FakeChat.conversationId,
        limit: 3,
        beforeId: newest.messages.first.id,
      );

      check(newest.messages.map((m) => m.id)).deepEquals(['m-2', 'm-3', 'm-4']);
      check(newest.hasMore).isTrue();
      check(older.messages.map((m) => m.id)).deepEquals(['m-0', 'm-1']);
      check(older.hasMore).isFalse();
    });

    test('lists the conversation with its newest messages', () async {
      final messaging = await _messaging(
        FakeChat(
          origin: chatMediaUri,
          messages: [
            for (var index = 0; index < 5; index++) _text('m-$index', index),
          ],
        ),
      );

      final conversation = (await messaging.conversations()).single;

      check(conversation.lastMessages.map((m) => m.id)).deepEquals([
        'm-4',
        'm-3',
        'm-2',
      ]);
      check(conversation.coach?.fullName).equals('Nora Lindqvist');
    });

    test('sends text, media and voice messages', () async {
      final chat = FakeChat(origin: chatMediaUri);
      final messaging = await _messaging(chat);
      final picture = chatMediaUri.resolve('${FakeChat.mediaPath}plate.jpg');
      final voice = chatMediaUri.resolve('${FakeChat.mediaPath}voice.m4a');

      final text = await messaging.sendText(FakeChat.conversationId, 'Hello');
      final media = await messaging.sendMedia(
        FakeChat.conversationId,
        [
          EkkloDirectMedia(
            url: picture,
            mediaType: EkkloDirectMediaType.values.first,
          ),
        ],
        caption: 'Lunch',
        replyToId: text.id,
      );
      final note = await messaging.sendVoice(
        FakeChat.conversationId,
        url: voice,
        durationSeconds: 3,
      );

      check(text)
        ..has((m) => m.senderId, 'sender').equals(FakeChat.ownerId)
        ..has((m) => m.kind, 'kind').equals(EkkloMessageKind.text);
      check(media)
        ..has((m) => m.content, 'content').equals('Lunch')
        ..has((m) => m.replyTo?.id, 'reply').equals(text.id)
        ..has((m) => m.media.single.url, 'url').equals(picture);
      check(note.kind).equals(EkkloMessageKind.voice);
      check(chat.messages).length.equals(3);
    });

    test('deletes text but refuses media like Ekklo does', () async {
      final chat = FakeChat(
        origin: chatMediaUri,
        messages: [
          _text('own', 0, senderId: FakeChat.ownerId),
          FakeChat.message(
            id: 'photo',
            createdAt: _now,
            senderId: FakeChat.ownerId,
            type: 'image',
            mediaUrls: ['${chatMediaUri.resolve('/media/plate.jpg')}'],
          ),
        ],
      );
      final messaging = await _messaging(chat);

      await messaging.deleteMessage(FakeChat.conversationId, 'own');
      await check(
        messaging.deleteMessage(FakeChat.conversationId, 'photo'),
      ).throws<EkkloMessageNotDeletedException>();

      check(chat.messages.map((m) => m['id'])).deepEquals(['photo']);
    });

    test('counts reactions with the server count winning', () async {
      final messaging = await _messaging(
        FakeChat(origin: chatMediaUri, messages: [_text('m-0', 0)])
          ..react('m-0', '❤️', userId: FakeChat.coachId, added: true),
      );

      final added = await messaging.addReaction(
        FakeChat.conversationId,
        'm-0',
        '❤️',
      );
      final removed = await messaging.removeReaction(
        FakeChat.conversationId,
        'm-0',
        '❤️',
      );

      check(
        added,
      ).equals(const EkkloReaction(emoji: '❤️', count: 2, mine: true));
      check(removed).equals(const EkkloReaction(emoji: '❤️', count: 1));
    });

    test('presigns an upload under its media origin', () async {
      final messaging = await _messaging(FakeChat(origin: chatMediaUri));

      final upload = await messaging.presignUpload(
        fileName: 'plate.jpg',
        fileType: 'image/jpeg',
        resourceType: EkkloUploadResourceType.messageImage,
        resourceId: FakeChat.conversationId,
      );

      check(upload.uploadUrl.host).equals(chatMediaUri.host);
      check(upload.publicUrl.path).startsWith(FakeChat.mediaPath);
    });

    test('reports messaging off for the account', () async {
      final messaging = await _messaging(
        FakeChat(origin: chatMediaUri, owner: FakeChat.user(messaging: false)),
      );

      check((await messaging.me()).settings.messaging).isFalse();
    });
  });

  test(
    'the dev seed decodes in full and points at the bundled media',
    () async {
      final chat = seededFakeChat(origin: chatMediaUri, now: _now);
      final messaging = await _messaging(chat);

      final page = await messaging.messages(
        FakeChat.conversationId,
        limit: chat.messages.length,
      );

      check(page.messages).length.equals(chat.messages.length);
      check(
        page.messages.map((message) => message.kind).toSet(),
      ).deepEquals(EkkloMessageKind.values.toSet());
      final media = {
        for (final message in page.messages)
          for (final item in message.media) item.url.pathSegments.last,
      };
      check(media).deepEquals({
        for (final asset in DevChatAsset.values) asset.fileName,
      });
    },
  );

  group('the dev chat server', () {
    test('serves the chat, its media and live events on loopback', () async {
      final chat = FakeChat(origin: FakeChatServer.baseUri);
      final server = await FakeChatServer.start(
        chat,
        loadAsset: (key) async => ByteData.sublistView(_assetBytes),
      );
      check(server).isNotNull();
      addTearDown(() => server?.close());
      final client = FakeChatServer.client();
      addTearDown(client.close);

      check((await client.messaging.me()).id).equals(FakeChat.ownerId);

      final socket = await client.messaging.connectSocket();
      addTearDown(socket.close);
      final events = StreamIterator(socket.events);
      socket.focusConversation(FakeChat.conversationId);
      chat.deliver(_text('live', 0));
      check(await events.moveNext()).isTrue();
      check(events.current)
          .isA<EkkloNewMessage>()
          .has(
            (event) => event.message.id,
            'id',
          )
          .equals('live');
      check(chat.focused).deepEquals([FakeChat.conversationId]);

      final media = FakeChatServer.baseUri.resolve(
        '${FakeChat.mediaPath}${DevChatAsset.squat.fileName}',
      );
      final whole = await http.get(media);
      final part = await http.get(media, headers: {'range': 'bytes=8-15'});
      final missing = await http.get(
        FakeChatServer.baseUri.resolve('${FakeChat.mediaPath}nothing.mp4'),
      );
      check(whole.bodyBytes).deepEquals(_assetBytes);
      check(whole.headers['content-type']).equals('video/mp4');
      check(part.statusCode).equals(HttpStatus.partialContent);
      check(part.bodyBytes).deepEquals(_assetBytes.sublist(8, 16));
      check(missing.statusCode).equals(HttpStatus.notFound);
    });

    test('takes an upload and serves it back', () async {
      final chat = FakeChat(origin: FakeChatServer.baseUri);
      final server = await FakeChatServer.start(
        chat,
        loadAsset: (key) async => ByteData(0),
      );
      addTearDown(() => server?.close());
      final client = FakeChatServer.client();
      addTearDown(client.close);
      final bytes = [9, 8, 7];

      final upload = await client.messaging.presignUpload(
        fileName: 'clip.mp4',
        fileType: 'video/mp4',
        resourceType: EkkloUploadResourceType.messageVideo,
        resourceId: FakeChat.conversationId,
      );
      final put = await http.put(upload.uploadUrl, body: bytes);
      final served = await http.get(upload.publicUrl);

      check(put.statusCode).equals(HttpStatus.ok);
      check(served.bodyBytes).deepEquals(bytes);
    });

    test('answers a range it cannot satisfy with 416', () async {
      final chat = FakeChat(origin: FakeChatServer.baseUri);
      final server = await FakeChatServer.start(
        chat,
        loadAsset: (key) async => ByteData.sublistView(_assetBytes),
      );
      addTearDown(() => server?.close());
      final client = FakeChatServer.client();
      addTearDown(client.close);
      final upload = await client.messaging.presignUpload(
        fileName: 'empty.mp4',
        fileType: 'video/mp4',
        resourceType: EkkloUploadResourceType.messageVideo,
        resourceId: FakeChat.conversationId,
      );
      await http.put(upload.uploadUrl, body: const <int>[]);
      final asset = FakeChatServer.baseUri.resolve(
        '${FakeChat.mediaPath}${DevChatAsset.squat.fileName}',
      );

      final empty = await http.get(
        upload.publicUrl,
        headers: {'range': 'bytes=0-'},
      );
      final pastEnd = await http.get(
        asset,
        headers: {'range': 'bytes=${_assetBytes.length}-'},
      );

      check(empty.statusCode).equals(HttpStatus.requestedRangeNotSatisfiable);
      check(pastEnd.statusCode).equals(HttpStatus.requestedRangeNotSatisfiable);
      check(
        pastEnd.headers['content-range'],
      ).equals('bytes */${_assetBytes.length}');
    });

    test('refuses requests without the dev token', () async {
      final server = await FakeChatServer.start(
        FakeChat(origin: FakeChatServer.baseUri),
        loadAsset: (key) async => ByteData(0),
      );
      addTearDown(() => server?.close());

      final refused = await http.get(
        FakeChatServer.baseUri.resolve('/api/v1/users/me'),
      );

      check(refused.statusCode).equals(HttpStatus.unauthorized);
    });
  });
}
