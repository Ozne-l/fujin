import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart' show group, test;
import 'package:fujin/domain/adding/store_code.dart';

void main() {
  group('a store code', () {
    test('is an EAN-13 starting with 20 to 29', () {
      check(isStoreCode('2112345004501')).isTrue();
      check(isStoreCode('2000000000008')).isTrue();
      check(isStoreCode('2912345678906')).isTrue();
    });

    test('is an EAN-13 starting with 02', () {
      check(isStoreCode('0212345678909')).isTrue();
    });

    test('is a UPC-A starting with 2, the EAN-13 02 without its 0', () {
      check(isStoreCode('212345678909')).isTrue();
    });

    test('is not a code from a GS1 country prefix', () {
      check(isStoreCode('3275760750398')).isFalse();
      check(isStoreCode('0312345678906')).isFalse();
      check(isStoreCode('1234567890128')).isFalse();
      check(isStoreCode('012345678905')).isFalse();
    });

    test('is never an EAN-8 or a GTIN-14', () {
      check(isStoreCode('20123451')).isFalse();
      check(isStoreCode('20123456789016')).isFalse();
    });
  });
}
