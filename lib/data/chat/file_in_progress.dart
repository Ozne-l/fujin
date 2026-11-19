import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/chat/chat_media_kind.dart';
import 'package:fujin/data/database/json_text_hook.dart';

part 'file_in_progress.mapper.dart';

@MappableClass()
final class FileInProgress with FileInProgressMappable {
  const FileInProgress({
    required this.id,
    required this.messageId,
    required this.position,
    required this.kind,
    this.source,
    this.path,
    this.originalBytes,
    this.publicUrl,
    this.completedAt,
  });

  final String id;
  final String messageId;
  final int position;
  final ChatMediaKind kind;
  @MappableField(hook: JsonTextHook())
  final Map<String, Object?>? source;
  final String? path;
  final int? originalBytes;
  final String? publicUrl;
  final DateTime? completedAt;

  bool get isComplete => completedAt != null && publicUrl != null;
}
