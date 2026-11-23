import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart' show test;
import 'package:fujin/pages/weigh_ins/kilograms_typing.dart';

const _separator = ',';

KilogramsTyping _typed(List<int> digits) => digits.fold(
  const KilogramsTyping(separator: _separator),
  (typing, digit) => typing.pressed(digit),
);

void main() {
  test('takes no digit after a lone zero, only the separator', () {
    final typing = _typed([0, 6, 8]);

    check(typing.text).equals('0');
    check(typing.kilograms).isNull();
    check(typing.separated().pressed(6).text).equals('0,6');
  });
}
