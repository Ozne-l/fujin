import 'package:fujin/data/dev_chat/dev_chat_asset.dart';
import 'package:fujin/data/dev_chat/fake_chat.dart';

const _days = 12;
const _textsPerDay = 9;
const _textGap = Duration(minutes: 37);
const _morning = Duration(hours: 8);

const _coachLines = [
  'Good morning! How did the night go?',
  'Remember to log your lunch before 2 pm.',
  'Nice work on the protein today.',
  'How heavy did the legs feel this morning?',
  'Let us keep the same plan for the week.',
  'Drink a big glass of water before the session.',
  'Send me a photo of your plate tonight if you can.',
  'Great consistency this week, keep it up.',
  'We can move the rest day to Sunday.',
];

const _ownerLines = [
  'Slept well, about seven hours.',
  'Lunch is logged.',
  'Thanks! The new recipe helped.',
  'A bit sore, nothing serious.',
  'Sounds good to me.',
  'Done, two glasses actually.',
  'Will do.',
  'Thanks, feeling good about it.',
  'Sunday works better for me.',
];

FakeChat seededFakeChat({required Uri origin, required DateTime now}) {
  Uri media(DevChatAsset asset) =>
      origin.resolve('${FakeChat.mediaPath}${asset.fileName}');
  final start = DateTime.utc(
    now.year,
    now.month,
    now.day,
  ).subtract(const Duration(days: _days)).add(_morning);
  final messages = <FakeChatJson>[];
  var number = 0;
  String id() => 'seed-${++number}';

  for (var day = 0; day < _days; day++) {
    for (var line = 0; line < _textsPerDay; line++) {
      final fromCoach = line.isEven;
      final lines = fromCoach ? _coachLines : _ownerLines;
      messages.add(
        FakeChat.message(
          id: id(),
          createdAt: start.add(Duration(days: day)).add(_textGap * line),
          senderId: fromCoach ? FakeChat.coachId : FakeChat.ownerId,
          content: lines[(day + line) % lines.length],
        ),
      );
    }
  }

  final lastDay = start.add(const Duration(days: _days - 1));
  DateTime at(int minutes) =>
      lastDay.add(_textGap * _textsPerDay).add(Duration(minutes: minutes));

  final plate = FakeChat.message(
    id: id(),
    createdAt: at(1),
    senderId: FakeChat.ownerId,
    type: 'image',
    content: 'Dinner tonight',
    mediaUrls: ['${media(DevChatAsset.plate)}'],
  );
  final squat = FakeChat.message(
    id: id(),
    createdAt: at(4),
    type: 'video',
    mediaUrls: ['${media(DevChatAsset.squat)}'],
  );
  final question = FakeChat.message(
    id: id(),
    createdAt: at(6),
    content: 'Can you film your next set from the side?',
    reactions: [FakeChat.reaction('👍', mine: true)],
  );
  return FakeChat(
    origin: origin,
    messages: [
      ...messages,
      plate,
      FakeChat.message(
        id: id(),
        createdAt: at(2),
        content: 'Looks balanced, maybe a bit more vegetables.',
        replyTo: {
          'id': plate['id'],
          'sender_id': FakeChat.ownerId,
          'sender_name': FakeChat.customerPerson['full_name'],
          'content': plate['content'],
          'message_type': 'image',
          'deleted': false,
        },
        reactions: [
          FakeChat.reaction('❤️', mine: true),
          FakeChat.reaction('😆'),
        ],
      ),
      FakeChat.message(
        id: id(),
        createdAt: at(3),
        type: 'image',
        mediaUrls: [
          '${media(DevChatAsset.board)}',
          '${media(DevChatAsset.shapes)}',
        ],
      ),
      squat,
      FakeChat.message(
        id: id(),
        createdAt: at(5),
        type: 'audio',
        mediaUrls: ['${media(DevChatAsset.voice)}'],
      ),
      question,
      FakeChat.message(
        id: id(),
        createdAt: at(7),
        senderId: FakeChat.ownerId,
        type: 'mixed',
        content: 'Here is the set, and my breakfast',
        mediaUrls: [
          '${media(DevChatAsset.stretch)}',
          '${media(DevChatAsset.plate)}',
        ],
        replyTo: {
          'id': question['id'],
          'sender_id': FakeChat.coachId,
          'sender_name': FakeChat.coachPerson['full_name'],
          'content': question['content'],
          'message_type': 'text',
          'deleted': false,
        },
      ),
      FakeChat.message(
        id: id(),
        createdAt: at(8),
        senderId: FakeChat.ownerId,
        type: 'voice',
        mediaUrls: ['${media(DevChatAsset.voiceNote)}'],
      ),
      FakeChat.message(
        id: id(),
        createdAt: at(9),
        type: 'video',
        mediaUrls: [
          '${media(DevChatAsset.squat)}',
          '${media(DevChatAsset.stretch)}',
        ],
        replyTo: {
          'id': squat['id'],
          'sender_id': FakeChat.coachId,
          'sender_name': FakeChat.coachPerson['full_name'],
          'message_type': 'video',
          'deleted': false,
        },
      ),
      FakeChat.message(
        id: id(),
        createdAt: at(10),
        type: 'file',
        content: 'Weekly plan',
      ),
      FakeChat.message(
        id: id(),
        createdAt: at(11),
        content: 'Your plan for next week',
        contentRef: const {'type': 'nutrition_plan', 'id': 'plan-1'},
      ),
      FakeChat.message(
        id: id(),
        createdAt: at(12),
        content: 'Note for the team only',
        internal: true,
      ),
      FakeChat.message(
        id: id(),
        createdAt: at(13),
        content: 'Answering an old message',
        replyTo: const {
          'id': 'seed-removed',
          'sender_id': FakeChat.ownerId,
          'message_type': 'text',
          'deleted': true,
        },
      ),
      FakeChat.message(
        id: id(),
        createdAt: at(14),
        content: 'Talk tomorrow, rest well!',
      ),
    ],
    conversations: [FakeChat.conversation(unreadCount: 2)],
  );
}
