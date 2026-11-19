import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/database/epoch_microseconds_hook.dart';
import 'package:fujin/data/database/json_text_hook.dart';

part 'cached_message.mapper.dart';

@MappableClass()
final class CachedMessage with CachedMessageMappable {
  const CachedMessage({
    required this.id,
    required this.conversationId,
    required this.createdAt,
    required this.json,
  });

  final String id;
  final String conversationId;
  @MappableField(hook: EpochMicrosecondsHook())
  final DateTime createdAt;
  @MappableField(hook: JsonTextHook())
  final Map<String, Object?> json;
}
