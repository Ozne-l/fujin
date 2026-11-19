import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/database/json_text_hook.dart';

part 'cached_conversation.mapper.dart';

@MappableClass()
final class CachedConversation with CachedConversationMappable {
  const CachedConversation({required this.id, required this.json});

  final String id;
  @MappableField(hook: JsonTextHook())
  final Map<String, Object?> json;
}
