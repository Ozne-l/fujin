import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart' show test;
import 'package:fujin/domain/chat/edit/duration_clamp.dart';

const _low = Duration(seconds: 2);
const _high = Duration(seconds: 8);

void main() {
  test(
    'keeps a duration within the bounds and raises or lowers the others',
    () {
      check(
        const Duration(seconds: 5).clampedTo(_low, _high),
      ).equals(const Duration(seconds: 5));
      check(Duration.zero.clampedTo(_low, _high)).equals(_low);
      check(const Duration(seconds: 9).clampedTo(_low, _high)).equals(_high);
    },
  );
}
