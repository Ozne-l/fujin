import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart' show group, test;
import 'package:fujin/domain/chat/voice/voice_limits.dart';

void main() {
  group('the duration sent', () {
    test('is the read-back length rounded to whole seconds', () {
      check(
        VoiceLimits.seconds(const Duration(milliseconds: 37400)),
      ).equals(37);
      check(
        VoiceLimits.seconds(const Duration(milliseconds: 37500)),
      ).equals(38);
    });

    test("stays within Ekklo's 1 to 300 seconds", () {
      check(
        VoiceLimits.seconds(const Duration(milliseconds: 1000 - 80)),
      ).equals(1);
      check(
        VoiceLimits.seconds(const Duration(minutes: 5, milliseconds: 600)),
      ).equals(300);
    });
  });
}
