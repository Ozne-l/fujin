import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart' show WidgetTester, addTearDown;

enum Haptic {
  select('HapticFeedbackType.selectionClick'),
  threshold('HapticFeedbackType.lightImpact'),
  press('HapticFeedbackType.mediumImpact'),
  success('HapticFeedbackType.successNotification'),
  error('HapticFeedbackType.errorNotification');

  const Haptic(this.platformType);

  final String platformType;

  static const _vibrate = 'HapticFeedback.vibrate';

  static List<Haptic> record(WidgetTester tester) {
    final felt = <Haptic>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == _vibrate) {
          felt.add(
            Haptic.values.firstWhere(
              (haptic) => haptic.platformType == call.arguments,
            ),
          );
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    return felt;
  }
}
