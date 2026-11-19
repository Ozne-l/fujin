import 'package:dart_mappable/dart_mappable.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/domain/chat/pending_text_state.dart';

part 'pending_text.mapper.dart';

@MappableClass()
final class PendingText with PendingTextMappable {
  const PendingText({
    required this.message,
    required this.state,
    this.after,
  });

  final EkkloMessage message;
  final PendingTextState state;
  final String? after;

  String get id => message.id;
}
