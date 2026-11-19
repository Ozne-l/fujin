import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/media/milliseconds_hook.dart';

part 'kept_passage.mapper.dart';

@MappableClass()
final class KeptPassage with KeptPassageMappable {
  const KeptPassage({required this.start, required this.end});

  @MappableField(key: 'start_ms', hook: MillisecondsHook())
  final Duration start;

  @MappableField(key: 'end_ms', hook: MillisecondsHook())
  final Duration end;
}
