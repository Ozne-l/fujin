import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/appearance_toggle.dart';
import 'package:fujin/pages/common/theme_reveal.dart';

import '../support/fake_backends.dart';
import '../support/fixtures.dart';
import '../support/phone_brightness.dart';
import '../support/pump_fujin.dart';

const _toDark = 'Passer en thème sombre';

int _circles() => find
    .descendant(
      of: find.byType(ThemeReveal),
      matching: find.byType(AbsorbPointer),
    )
    .evaluate()
    .length;

Future<int> _circlesAfterChoosing(WidgetTester tester, String choice) async {
  await tester.tap(find.text(choice).last);
  await tester.pump();
  return _circles();
}

Future<void> _openSettings(WidgetTester tester) async {
  await pumpFujin(tester, FakeBackends(mealNames: [breakfast]));
  await tester.tap(find.text('Réglages').last);
  await tester.pumpAndSettle();
}

void main() {
  setUp(() {
    final view =
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    addTearDown(view.reset);
    view
      ..physicalSize = const Size(800, 1800)
      ..devicePixelRatio = 1;
  });

  testWidgets('draws the circle when the choice changes the theme', (
    tester,
  ) async {
    phoneBrightness(tester, Brightness.light);
    await _openSettings(tester);
    final before = _circles();

    check(await _circlesAfterChoosing(tester, 'Sombre')).equals(before + 1);
  });

  testWidgets('draws no circle when the choice leaves the theme as it is', (
    tester,
  ) async {
    phoneBrightness(tester, Brightness.light);
    await _openSettings(tester);
    final before = _circles();

    check(await _circlesAfterChoosing(tester, 'Clair')).equals(before);
  });

  testWidgets('switches the theme without the circle when the phone reduces '
      'motion', (tester) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    final semantics = tester.ensureSemantics();
    phoneBrightness(tester, Brightness.light);
    await pumpFujin(tester, FakeBackends(mealNames: [breakfast]));
    final before = _circles();

    await tester.tap(find.bySemanticsLabel(_toDark));
    await tester.pump();

    check(_circles()).equals(before);
    check(
      colorsAt(tester, find.byType(AppearanceToggle)),
    ).identicalTo(FujinColors.dark);
    semantics.dispose();
  });
}
