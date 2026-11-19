import 'package:dart_mappable/dart_mappable.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/domain/chat/conversation_state.dart';

part 'chat_viewer_read.mapper.dart';

@MappableClass()
final class ChatViewerRead with ChatViewerReadMappable {
  const ChatViewerRead({
    required this.mine,
    required this.coach,
    required this.createdAt,
    required this.caption,
    required this.media,
  });

  final bool mine;
  final EkkloPerson? coach;
  final DateTime createdAt;
  final String caption;
  final List<EkkloMedia> media;

  static ChatViewerRead? of(ConversationState state, String messageId) {
    final message = state.messages
        .where((message) => message.id == messageId)
        .firstOrNull;
    if (message == null) return null;
    final media = [
      for (final item in message.media)
        if (item.kind case EkkloMediaKind.image || EkkloMediaKind.video) item,
    ];
    return switch (media) {
      [] => null,
      _ => ChatViewerRead(
        mine: state.isMine(message),
        coach: state.conversation?.coach,
        createdAt: message.createdAt,
        caption: message.content.trim(),
        media: media,
      ),
    };
  }
}
