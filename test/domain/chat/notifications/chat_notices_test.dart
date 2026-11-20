import 'dart:ui';

import 'package:checks/checks.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter_test/flutter_test.dart' show group, test;
import 'package:fujin/app/notifications/chat_notification_text.dart';
import 'package:fujin/domain/chat/notifications/chat_notices.dart';
import 'package:fujin/domain/chat/notifications/conversation_notice.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';

const _conversationId = 'c-1';
const _ownerId = 'u-owner';
const _owner = EkkloPerson(id: _ownerId, fullName: 'Élie Labat');
const _coach = EkkloPerson(id: 'u-coach', firstName: 'Léa', lastName: 'Morel');

final AppLocalizations _french = lookupAppLocalizations(const Locale('fr'));

EkkloMessage _message(
  String id, {
  required int minute,
  String sender = 'u-coach',
  EkkloMessageType type = EkkloMessageType.text,
  String content = '',
  List<String> urls = const [],
  bool internal = false,
  Map<String, dynamic>? contentRef,
}) => EkkloMessage(
  id: id,
  conversationId: _conversationId,
  senderId: sender,
  type: type,
  createdAt: DateTime.utc(2026, 11, 19, 9, minute),
  content: content,
  mediaUrls: urls,
  internal: internal,
  contentRef: contentRef,
);

EkkloConversation _conversation(
  List<EkkloMessage> newestFirst, {
  required int unread,
  String id = _conversationId,
}) => EkkloConversation(
  id: id,
  canSend: true,
  unreadCount: unread,
  coach: _coach,
  customer: _owner,
  lastMessages: newestFirst,
);

List<ConversationNotice> _notices(
  List<EkkloConversation> conversations, {
  List<EkkloConversation> previous = const [],
  String? ownerId = _ownerId,
}) => chatNotices(
  conversations,
  previous: {
    for (final conversation in previous) conversation.id: conversation,
  },
  ownerId: ownerId,
);

List<String> _texts(List<ConversationNotice> notices) => [
  for (final notice in notices)
    if (notice case ShowNotice(:final notification))
      for (final message in notification.messages)
        ChatNotificationText(_french).textOf(message.content),
];

List<String> _textOfEach(List<EkkloMessage> messages) => [
  for (final message in messages)
    ..._texts(
      _notices([
        _conversation([message], unread: 1),
      ]),
    ),
];

void main() {
  group('a conversation with unread messages from the coach', () {
    test('shows them oldest first, as text, under the coach and owner '
        'names', () {
      final notices = _notices([
        _conversation([
          _message('m-3', minute: 3, content: 'Et le dîner ?'),
          _message('m-2', minute: 2, content: 'Top séance 💪'),
          _message('m-1', minute: 1, content: 'Déjà lu'),
        ], unread: 2),
      ]);

      check(notices).length.equals(1);
      final notification = (notices.single as ShowNotice).notification;
      check(notification.conversationId).equals(_conversationId);
      check(notification.coachName).equals('Léa Morel');
      check(notification.ownerName).equals('Élie Labat');
      check([
        for (final message in notification.messages) message.id,
      ]).deepEquals(['m-2', 'm-3']);
      check(_texts(notices)).deepEquals(['Top séance 💪', 'Et le dîner ?']);
    });

    test('labels media by their kind and count', () {
      check(
        _textOfEach([
          _message(
            'photo',
            minute: 1,
            type: EkkloMessageType.image,
            urls: ['a.jpg'],
          ),
          _message(
            'photos',
            minute: 1,
            type: EkkloMessageType.image,
            urls: ['a.jpg', 'b.png'],
          ),
          _message(
            'video',
            minute: 1,
            type: EkkloMessageType.video,
            urls: ['a.mp4'],
          ),
          _message(
            'videos',
            minute: 1,
            type: EkkloMessageType.video,
            urls: ['a.mp4', 'b.mp4'],
          ),
          _message(
            'voice',
            minute: 1,
            type: EkkloMessageType.audio,
            urls: ['a.m4a'],
          ),
          _message(
            'mixed',
            minute: 1,
            type: EkkloMessageType.mixed,
            urls: ['a.jpg', 'b.mp4', 'c.jpg'],
          ),
        ]),
      ).deepEquals([
        'Photo',
        '2 photos',
        'Vidéo',
        '2 vidéos',
        'Message vocal',
        '3 médias',
      ]);
    });

    test('follows a media label with its caption', () {
      check(
        _textOfEach([
          _message(
            'photos',
            minute: 1,
            type: EkkloMessageType.image,
            urls: ['a.jpg', 'b.jpg'],
            content: 'Avant / après',
          ),
          _message(
            'blank caption',
            minute: 1,
            type: EkkloMessageType.video,
            urls: ['a.mp4'],
            content: '  ',
          ),
        ]),
      ).deepEquals(['2 photos · Avant / après', 'Vidéo']);
    });

    test('labels a media listed without its URLs by its type alone', () {
      check(
        _textOfEach([
          _message('photo', minute: 1, type: EkkloMessageType.image),
          _message('video', minute: 1, type: EkkloMessageType.video),
          _message('voice', minute: 1, type: EkkloMessageType.voice),
          _message(
            'mixed',
            minute: 1,
            type: EkkloMessageType.mixed,
            content: 'Séance',
          ),
        ]),
      ).deepEquals([
        'Photo',
        'Vidéo',
        'Message vocal',
        'Photos et vidéos · Séance',
      ]);
    });

    test('shows content Fūjin cannot display as one to open in Ekklo', () {
      check(
        _textOfEach([
          _message(
            'reference',
            minute: 1,
            content: 'Programme',
            contentRef: {'type': 'program'},
          ),
          _message('unknown', minute: 1, type: EkkloMessageType.unknown),
          _message(
            'bad url',
            minute: 1,
            type: EkkloMessageType.mixed,
            urls: ['a.pdf'],
          ),
        ]),
      ).deepEquals([
        'Contenu à ouvrir dans Ekklo',
        'Contenu à ouvrir dans Ekklo',
        'Contenu à ouvrir dans Ekklo',
      ]);
    });

    test("leaves out the owner's own messages and internal ones", () {
      final notices = _notices([
        _conversation([
          _message('mine', minute: 3, sender: _owner.id, content: 'Ok'),
          _message('internal', minute: 2, internal: true, content: 'Note'),
          _message('coach', minute: 1, content: 'Bravo'),
        ], unread: 2),
      ]);

      check(_texts(notices)).deepEquals(['Bravo']);
    });

    test("takes the conversation's customer as the owner until Fūjin "
        'knows him', () {
      final notices = _notices(
        [
          _conversation([
            _message('mine', minute: 2, sender: _ownerId, content: 'Ok'),
            _message('coach', minute: 1, content: 'Bravo'),
          ], unread: 1),
        ],
        ownerId: null,
      );

      check(_texts(notices)).deepEquals(['Bravo']);
    });
  });

  group('a notification', () {
    test('is removed once the conversation has no unread message', () {
      check(
        _notices([
          _conversation([
            _message('m-1', minute: 1, content: 'Bravo'),
          ], unread: 0),
        ]),
      ).deepEquals([const RemoveNotice(_conversationId)]);
    });

    test('is removed when Ekklo no longer lists its conversation', () {
      check(
        _notices(
          [],
          previous: [
            _conversation([_message('m-1', minute: 1)], unread: 1),
          ],
        ),
      ).deepEquals([const RemoveNotice(_conversationId)]);
    });

    test('is not shown again for the messages of the previous read', () {
      final read = _conversation([
        _message('m-1', minute: 1, content: 'Bravo'),
      ], unread: 1);

      check(_notices([read], previous: [read])).isEmpty();
    });

    test('is shown again with every unread message once a newer one '
        'arrives', () {
      final notices = _notices(
        [
          _conversation([
            _message('m-2', minute: 2, content: 'Et demain ?'),
            _message('m-1', minute: 1, content: 'Bravo'),
          ], unread: 2),
        ],
        previous: [
          _conversation([
            _message('m-1', minute: 1, content: 'Bravo'),
          ], unread: 1),
        ],
      );

      check(_texts(notices)).deepEquals(['Bravo', 'Et demain ?']);
    });
  });
}
