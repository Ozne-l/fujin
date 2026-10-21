import 'package:checks/checks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/glass_fill.dart';
import 'package:fujin/pages/common/glass_surface.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

import '../support/fake_backends.dart';
import '../support/fixtures.dart';
import '../support/pump_fujin.dart';

Iterable<Color?> _fillsIn(Type glass) => find
    .descendant(
      of: find.byType(glass),
      matching: find.byType(DecoratedBox),
    )
    .evaluate()
    .map((element) => (element.widget as DecoratedBox).decoration)
    .whereType<ShapeDecoration>()
    .map((decoration) => decoration.color);

void main() {
  testWidgets('draws the tab plate, the Scanner and the day/night toggle as '
      'opaque cards when the phone reduces transparency', (tester) async {
    await pumpFujin(
      tester,
      FakeBackends(mealNames: [breakfast]),
      reduceTransparency: true,
    );

    check(find.byType(LiquidGlass).evaluate()).isEmpty();
    check(
      _fillsIn(
        GlassSurface,
      ).where((fill) => fill == FujinColors.light.backgroundCard),
    ).length.equals(3);
  });

  testWidgets('lays the glass of the Apparence segment over the card when the '
      'phone reduces transparency', (tester) async {
    await pumpFujin(
      tester,
      FakeBackends(mealNames: [breakfast]),
      reduceTransparency: true,
    );
    await tester.tap(find.text('Réglages').last);
    await tester.pumpAndSettle();

    check(find.byType(LiquidGlass).evaluate()).isEmpty();
    check(_fillsIn(GlassFill)).contains(
      Color.alphaBlend(
        FujinColors.light.backgroundGlass,
        FujinColors.light.backgroundCard,
      ),
    );
  });

  testWidgets('swells no glass lens under the finger when the phone reduces '
      'transparency', (tester) async {
    await pumpFujin(
      tester,
      FakeBackends(mealNames: [breakfast]),
      reduceTransparency: true,
    );

    final finger = await tester.startGesture(
      tester.getCenter(find.text('Mémoire')),
    );
    await tester.pumpAndSettle();

    check(find.byType(LiquidGlass).evaluate()).isEmpty();
    await finger.up();
  });

  testWidgets('drops the glass when the phone turns on high contrast', (
    tester,
  ) async {
    await pumpFujin(tester, FakeBackends(mealNames: [breakfast]));
    check(find.byType(LiquidGlass).evaluate()).length.equals(3);

    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(highContrast: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    await tester.pumpAndSettle();

    check(find.byType(LiquidGlass).evaluate()).isEmpty();
    check(
      _fillsIn(
        GlassSurface,
      ).where((fill) => fill == FujinColors.light.backgroundCard),
    ).length.equals(3);
  });
}
