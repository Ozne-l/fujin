import 'package:fujin/data/voice/voice_settings.dart';

abstract interface class VoiceRecorder {
  Future<bool> allowed();

  Future<VoiceSettings> start(String path);

  Future<double> level();

  Future<void> stop();

  Future<void> cancel();
}
