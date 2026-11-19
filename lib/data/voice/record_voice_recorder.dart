import 'package:fujin/data/voice/voice_recorder.dart';
import 'package:fujin/data/voice/voice_settings.dart';
import 'package:record/record.dart';

final class RecordVoiceRecorder implements VoiceRecorder {
  final AudioRecorder _recorder = AudioRecorder();

  static final RecordConfig _config = RecordConfig(
    sampleRate: VoiceSettings.requested.sampleRate,
    numChannels: VoiceSettings.requested.channels,
    bitRate: VoiceSettings.requested.bitRate,
    androidConfig: const AndroidRecordConfig(manageBluetooth: false),
  );

  @override
  Future<bool> allowed() => _recorder.hasPermission();

  @override
  Future<VoiceSettings> start(String path) async {
    var applied = VoiceSettings.requested;
    await _recorder.setOnConfigChanged(
      (config) => applied = VoiceSettings(
        sampleRate: config.sampleRate,
        channels: config.numChannels,
        bitRate: config.bitRate,
      ),
    );
    try {
      await _recorder.start(_config, path: path);
    } finally {
      await _recorder.setOnConfigChanged(null);
    }
    return applied;
  }

  @override
  Future<double> level() async => (await _recorder.getAmplitude()).current;

  @override
  Future<void> stop() => _recorder.stop();

  @override
  Future<void> cancel() => _recorder.cancel();

  Future<void> dispose() => _recorder.dispose();
}
