import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/chat/message_in_progress_state.dart';

part 'message_in_progress.mapper.dart';

@MappableClass()
final class MessageInProgress with MessageInProgressMappable {
  const MessageInProgress({
    required this.id,
    required this.conversationId,
    required this.startedAt,
    required this.state,
    this.caption,
    this.replyToId,
    this.durationSeconds,
  });

  final String id;
  final String conversationId;
  final DateTime startedAt;
  final MessageInProgressState state;
  final String? caption;
  final String? replyToId;
  final int? durationSeconds;
}
