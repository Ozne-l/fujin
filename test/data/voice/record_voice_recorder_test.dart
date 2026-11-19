import 'package:checks/checks.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart'
    show
        TestDefaultBinaryMessengerBinding,
        TestWidgetsFlutterBinding,
        setUp,
        tearDown,
        test;
import 'package:fujin/data/voice/record_voice_recorder.dart';
import 'package:fujin/data/voice/voice_settings.dart';

const _messages = MethodChannel('com.llfbandit.record/messages');
const _codec = StandardMethodCodec();
const _path = '/tmp/voice.m4a';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  late List<MethodCall> calls;
  Map<String, Object>? adjusted;

  setUp(() {
    calls = [];
    adjusted = null;
    messenger.setMockMethodCallHandler(_messages, (call) async {
      calls.add(call);
      switch (call.method) {
        case 'start':
          if (adjusted case final config?) {
            final arguments = call.arguments as Map<Object?, Object?>;
            await messenger.handlePlatformMessage(
              'com.llfbandit.record/configChanged/${arguments['recorderId']}',
              _codec.encodeMethodCall(MethodCall('onConfigChanged', config)),
              (_) {},
            );
          }
          return null;
        default:
          return null;
      }
    });
  });

  tearDown(() => messenger.setMockMethodCallHandler(_messages, null));

  test('records AAC-LC mono at 44.1 kHz and 64 kbit/s into the path', () async {
    await RecordVoiceRecorder().start(_path);

    final start = calls.singleWhere((call) => call.method == 'start');
    check(start.arguments as Map<Object?, Object?>)
      ..['path'].equals(_path)
      ..['encoder'].equals('aacLc')
      ..['numChannels'].equals(1)
      ..['sampleRate'].equals(44100)
      ..['bitRate'].equals(64000);
  });

  test('reads back the settings the device applied', () async {
    adjusted = {
      'encoder': 'aacLc',
      'sampleRate': 48000,
      'numChannels': 1,
      'bitRate': 96000,
    };

    final applied = await RecordVoiceRecorder().start(_path);

    check(applied).equals(
      const VoiceSettings(sampleRate: 48000, channels: 1, bitRate: 96000),
    );
  });

  test('keeps the requested settings when the device changed none', () async {
    final applied = await RecordVoiceRecorder().start(_path);

    check(applied).equals(VoiceSettings.requested);
  });
}
