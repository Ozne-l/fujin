import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart' show setUp, tearDown, test;
import 'package:fujin/data/chat/chat_media_kind.dart';
import 'package:fujin/data/chat/file_in_progress.dart';
import 'package:fujin/data/chat/message_in_progress.dart';
import 'package:fujin/data/chat/message_in_progress_repository.dart';
import 'package:fujin/data/chat/message_in_progress_state.dart';
import 'package:fujin/data/database/cache_table.dart';
import 'package:fujin/data/database/fujin_database.dart';

const _conversation = 'conv-1';
const _messageId = 'progress-1';
const _photoUrl = 'https://assets.ekklo.com/photo.jpg';
const _staleUrl = 'https://assets.ekklo.com/earlier-photo.jpg';
final _startedAt = DateTime.utc(2026, 11, 19, 10);

final _message = MessageInProgress(
  id: _messageId,
  conversationId: _conversation,
  startedAt: _startedAt,
  state: MessageInProgressState.uploading,
  caption: 'Squat',
  replyToId: 'm-7',
);

FileInProgress _file(String id, int position, ChatMediaKind kind) =>
    FileInProgress(
      id: id,
      messageId: _messageId,
      position: position,
      kind: kind,
      path: '/tmp/$id',
    );

void main() {
  late FujinDatabase<CacheTable> database;
  late MessageInProgressRepository messages;

  setUp(() {
    database = FujinDatabase.cacheInMemory();
    messages = MessageInProgressRepository(database);
  });

  tearDown(() => database.close());

  test('a message in progress keeps its files in order, their urls and the '
      'first completion of their current url, until it is deleted', () {
    final video = _file('f-video', 1, ChatMediaKind.video);
    final photo = _file('f-photo', 0, ChatMediaKind.image);
    final firstCompletion = _startedAt.add(const Duration(minutes: 1));

    messages
      ..start(_message, [video, photo])
      ..saveFile(photo.copyWith(publicUrl: _photoUrl))
      ..completeFile(
        photo.id,
        publicUrl: _staleUrl,
        at: _startedAt.add(const Duration(seconds: 30)),
      )
      ..completeFile(photo.id, publicUrl: _photoUrl, at: firstCompletion)
      ..completeFile(
        photo.id,
        publicUrl: _photoUrl,
        at: firstCompletion.add(const Duration(minutes: 1)),
      )
      ..save(_message.copyWith(state: MessageInProgressState.failed));

    check(messages.message(_messageId))
        .isNotNull()
        .has((message) => message.state, 'state')
        .equals(MessageInProgressState.failed);
    check(messages.inConversation(_conversation)).length.equals(1);
    check(messages.files(_messageId)).deepEquals([
      photo.copyWith(publicUrl: _photoUrl, completedAt: firstCompletion),
      video,
    ]);

    messages.delete(_messageId);

    check(messages.message(_messageId)).isNull();
    check(messages.inConversation(_conversation)).isEmpty();
    check(messages.files(_messageId)).isEmpty();
  });
}
