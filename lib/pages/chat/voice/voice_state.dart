import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/media/milliseconds_hook.dart';

part 'voice_state.mapper.dart';

@MappableClass(discriminatorKey: 'stage')
sealed class VoiceState with VoiceStateMappable {
  const VoiceState();
}

@MappableClass(discriminatorValue: 'idle')
final class VoiceIdle extends VoiceState with VoiceIdleMappable {
  const VoiceIdle();
}

@MappableClass(discriminatorValue: 'starting')
final class VoiceStarting extends VoiceState with VoiceStartingMappable {
  const VoiceStarting();
}

@MappableClass(discriminatorValue: 'recording')
final class VoiceRecording extends VoiceState with VoiceRecordingMappable {
  const VoiceRecording({required this.elapsed, required this.levels});

  @MappableField(key: 'elapsed_ms', hook: MillisecondsHook())
  final Duration elapsed;

  final List<double> levels;
}

@MappableClass(discriminatorValue: 'kept')
final class VoiceKept extends VoiceState with VoiceKeptMappable {
  const VoiceKept({
    required this.path,
    required this.duration,
    required this.levels,
    required this.atLimit,
  });

  final String path;

  @MappableField(key: 'duration_ms', hook: MillisecondsHook())
  final Duration duration;

  final List<double> levels;
  final bool atLimit;
}

@MappableClass(discriminatorValue: 'sending')
final class VoiceSending extends VoiceState with VoiceSendingMappable {
  const VoiceSending({required this.shown, required this.levels});

  @MappableField(key: 'shown_ms', hook: MillisecondsHook())
  final Duration shown;

  final List<double> levels;
}
