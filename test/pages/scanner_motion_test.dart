import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/scan_button.dart';
import 'package:fujin/pages/scanner/code_bounds.dart';
import 'package:fujin/pages/scanner/widgets/aim_frame.dart';

import '../support/fake_backends.dart';
import '../support/fake_scan_camera.dart';
import '../support/fixtures.dart';
import '../support/pump_fujin.dart';

const _code = '3275760750398';
const _thisProduct = 'C’est bien ce produit';
const _addTo = 'Ajouter à';
const _frame = Duration(milliseconds: 16);
const _frames = 120;
const _midway = Duration(milliseconds: 120);
const _aimFrame = Rect.fromLTWH(50, 186, 300, 190);
const double _margin = FujinSpace.s2;

FakeBackends _backends() => FakeBackends(
  mealNames: [breakfast, lunch],
  mfpFoods: [mfpFood(oats)],
  mfpBarcodes: {_code: mfpFood(oats)},
);

void _reduceMotion(WidgetTester tester) {
  tester.platformDispatcher.accessibilityFeaturesTestValue =
      const FakeAccessibilityFeatures(disableAnimations: true);
  addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
}

Future<void> _settle(WidgetTester tester) async {
  for (var frame = 0; frame < _frames; frame++) {
    await tester.pump(_frame);
  }
}

Future<FakeScanCamera> _scanner(WidgetTester tester) async {
  final camera = FakeScanCamera();
  await pumpFujin(tester, _backends(), camera: camera, settle: false);
  await tester.tap(find.byType(ScanButton));
  await _settle(tester);
  return camera;
}

Future<void> _until(WidgetTester tester, String text) async {
  for (
    var frame = 0;
    frame < _frames && find.text(text).evaluate().isEmpty;
    frame++
  ) {
    await tester.pump(_frame);
  }
}

double _top(WidgetTester tester) =>
    tester.getTopLeft(find.text(_thisProduct)).dy;

void main() {
  testWidgets('raises the sheet of a read code and lowers it when dismissed', (
    tester,
  ) async {
    final camera = await _scanner(tester);

    camera.read(_code);
    await _until(tester, _thisProduct);
    await tester.pump();
    await tester.pump(_midway);
    final rising = _top(tester);
    await _settle(tester);
    final rest = _top(tester);
    check(rising).isGreaterThan(rest);

    await tester.binding.handlePopRoute();
    await tester.pump();
    await tester.pump(_midway);
    check(_top(tester)).isGreaterThan(rest);
    await _settle(tester);
    check(find.text(_thisProduct).evaluate()).isEmpty();
  });

  testWidgets('takes no tap on a sheet on its way down', (tester) async {
    final camera = await _scanner(tester);
    camera.read(_code);
    await _until(tester, _thisProduct);
    await _settle(tester);

    await tester.binding.handlePopRoute();
    await tester.pump();
    await tester.pump(_frame);
    await tester.tap(find.text(_thisProduct), warnIfMissed: false);
    await _settle(tester);

    check(find.textContaining(_addTo).evaluate()).isEmpty();
  });

  testWidgets('puts the sheet in place at once when the phone asks for less '
      'motion', (tester) async {
    _reduceMotion(tester);
    final camera = await _scanner(tester);

    camera.read(_code);
    await _until(tester, _thisProduct);
    await tester.pump(_frame);
    final first = _top(tester);
    await _settle(tester);
    check(first).equals(_top(tester));

    await tester.binding.handlePopRoute();
    await tester.pump();
    await tester.pump(_frame);
    check(find.text(_thisProduct).evaluate()).isEmpty();
  });

  group('the aiming frame closes', () {
    test('around the code read, with a margin', () {
      const code = Rect.fromLTWH(80, 230, 200, 90);

      check(AimFrame.closingOn(_aimFrame, code: code)).equals(
        Rect.fromLTRB(
          code.left - _margin,
          code.top - _margin,
          code.right + _margin,
          code.bottom + _margin,
        ),
      );
    });

    test('no smaller than its two corners', () {
      const code = Rect.fromLTWH(190, 270, 10, 4);
      final closed = AimFrame.closingOn(_aimFrame, code: code);

      check(closed.center).equals(code.center);
      check(closed.width).equals(FujinSize.aimCorner * 2);
      check(closed.height).equals(FujinSize.aimCorner * 2);
    });

    test('on a barcode shape in its middle when the camera gave no '
        'corners', () {
      check(AimFrame.closingOn(_aimFrame, code: null)).equals(
        Rect.fromCenter(
          center: _aimFrame.center,
          width: FujinSize.aimCodeWidth,
          height: FujinSize.aimCodeHeight,
        ),
      );
    });
  });

  group('the code read', () {
    test('lands where the cropped camera picture shows it', () {
      final bounds = CodeBounds.of(
        corners: const [
          Offset(108, 960),
          Offset(972, 960),
          Offset(972, 1152),
          Offset(108, 1152),
        ],
        image: const Size(1080, 1920),
        view: const Size(400, 800),
      );

      check(bounds).isNotNull()
        ..has((rect) => rect.left, 'left').isCloseTo(20, 1e-9)
        ..has((rect) => rect.top, 'top').isCloseTo(400, 1e-9)
        ..has((rect) => rect.right, 'right').isCloseTo(380, 1e-9)
        ..has((rect) => rect.bottom, 'bottom').isCloseTo(480, 1e-9);
    });

    test('has no place when the camera gave no corners', () {
      check(
        CodeBounds.of(
          corners: const [],
          image: const Size(1080, 1920),
          view: const Size(400, 800),
        ),
      ).isNull();
    });
  });
}
