import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/domain/chat/notifications/notified_content.dart';

part 'notified_message.mapper.dart';

@MappableClass()
final class NotifiedMessage with NotifiedMessageMappable {
  const NotifiedMessage({
    required this.id,
    required this.sentAt,
    required this.content,
  });

  final String id;
  final DateTime sentAt;
  final NotifiedContent content;
}
