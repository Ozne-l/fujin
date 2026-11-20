import 'package:dart_mappable/dart_mappable.dart';
import 'package:ekklo_client/ekklo_client.dart';

part 'chat_change.mapper.dart';

@MappableClass(discriminatorKey: 'change')
sealed class ChatChange with ChatChangeMappable {
  const ChatChange();
}

@MappableClass(discriminatorValue: 'saved')
final class MessageSaved extends ChatChange with MessageSavedMappable {
  const MessageSaved(this.message);

  final EkkloMessage message;
}

@MappableClass(discriminatorValue: 'removed')
final class MessageRemoved extends ChatChange with MessageRemovedMappable {
  const MessageRemoved({required this.conversationId, required this.messageId});

  final String conversationId;
  final String messageId;
}

@MappableClass(discriminatorValue: 'read')
final class MessagesRead extends ChatChange with MessagesReadMappable {
  const MessagesRead({required this.conversationId, required this.messages});

  final String conversationId;
  final List<EkkloMessage> messages;
}

@MappableClass(discriminatorValue: 'none')
final class NothingChanged extends ChatChange with NothingChangedMappable {
  const NothingChanged();
}
