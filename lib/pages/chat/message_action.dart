import 'package:dart_mappable/dart_mappable.dart';

part 'message_action.mapper.dart';

@MappableClass(discriminatorKey: 'action')
sealed class MessageAction with MessageActionMappable {
  const MessageAction();
}

@MappableClass(discriminatorValue: 'reply')
final class ReplyAction extends MessageAction with ReplyActionMappable {
  const ReplyAction();
}

@MappableClass(discriminatorValue: 'delete')
final class DeleteAction extends MessageAction with DeleteActionMappable {
  const DeleteAction();
}

@MappableClass(discriminatorValue: 'react')
final class ReactAction extends MessageAction with ReactActionMappable {
  const ReactAction(this.emoji);

  final String emoji;
}

@MappableClass(discriminatorValue: 'more_emoji')
final class MoreEmojiAction extends MessageAction with MoreEmojiActionMappable {
  const MoreEmojiAction();
}
