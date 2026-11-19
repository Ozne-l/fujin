import 'package:dart_mappable/dart_mappable.dart';

part 'voice_settings.mapper.dart';

@MappableClass()
final class VoiceSettings with VoiceSettingsMappable {
  const VoiceSettings({
    required this.sampleRate,
    required this.channels,
    required this.bitRate,
  });

  static const requested = VoiceSettings(
    sampleRate: 44100,
    channels: 1,
    bitRate: 64000,
  );

  final int sampleRate;
  final int channels;
  final int bitRate;
}
