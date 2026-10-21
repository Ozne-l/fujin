import 'package:checks/checks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fujin/pages/tabs/tab_plate.dart';

import '../support/fake_backends.dart';
import '../support/fixtures.dart';
import '../support/gestures.dart';
import '../support/pump_fujin.dart';

const _scroll = 300.0;
const _scrollBack = 100.0;
const _nudge = 12.0;
const _goals = 'Tous les jours';

double _plateWidth(WidgetTester tester) =>
    tester.getRect(find.byType(TabPlate)).width;

double _scrolled(WidgetTester tester, String text) => tester
    .state<ScrollableState>(
      find.ancestor(of: find.text(text), matching: find.byType(Scrollable)),
    )
    .position
    .pixels;

void main() {
  testWidgets('opens the tab the finger is lifted over after sliding along '
      'the plate', (tester) async {
    await pumpFujin(tester, FakeBackends(mealNames: [breakfast]));

    await slide(
      tester,
      tester.getCenter(find.text('Journal')),
      tester.getCenter(find.text('Réglages')),
    );
    await tester.pumpAndSettle();

    check(find.text('APPARENCE').evaluate()).length.equals(1);
  });

  testWidgets('shrinks the bar while the journal scrolls down and brings it '
      'back when scrolling up', (tester) async {
    await pumpFujin(tester, FakeBackends(mealNames: [breakfast]));
    final full = _plateWidth(tester);

    await tester.drag(find.text(breakfast), const Offset(0, -_scroll));
    await tester.pumpAndSettle();
    final shrunk = _plateWidth(tester);

    await tester.drag(find.text(breakfast), const Offset(0, _scrollBack));
    await tester.pumpAndSettle();

    check(shrunk).isLessThan(full);
    check(_plateWidth(tester)).equals(full);
  });

  testWidgets('keeps the bar full on the next tab until it scrolls down by '
      'more than the shrink threshold', (tester) async {
    await pumpFujin(tester, FakeBackends(mealNames: [breakfast]));
    final full = _plateWidth(tester);
    await tester.drag(find.text(breakfast), const Offset(0, -_scroll));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Réglages'));
    await tester.pumpAndSettle();
    await tester.drag(
      find.text(_goals),
      const Offset(0, -(kDragSlopDefault + _nudge)),
    );
    await tester.pumpAndSettle();

    check(_scrolled(tester, _goals)).isGreaterThan(0);
    check(_plateWidth(tester)).equals(full);
  });
}
