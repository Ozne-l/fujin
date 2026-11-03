import 'dart:async';

import 'package:checks/checks.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart'
    show
        FakeAccessibilityFeatures,
        Finder,
        WidgetTester,
        addTearDown,
        find,
        testWidgets;
import 'package:fujin/data/connectors/connector.dart';
import 'package:fujin/pages/adding/add_search_notifier.dart';
import 'package:fujin/pages/journal/widgets/connector_pill.dart';

import '../../support/fake_backends.dart';
import '../../support/fixtures.dart';
import '../../support/pump_fujin.dart';

final Finder _mfpPill = find.byWidgetPredicate(
  (widget) => widget is ConnectorPill && widget.connector == Connector.mfp,
);

void _stillClocks(WidgetTester tester) {
  tester.platformDispatcher.accessibilityFeaturesTestValue =
      const FakeAccessibilityFeatures(disableAnimations: true);
  addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
}

Future<void> _pumpWithoutEkklo(
  WidgetTester tester,
  FakeBackends backends,
) async {
  final store = InMemoryEkkloTokenStore();
  await store.write(FakeBackends.staleEkkloTokens);
  await pumpFujin(tester, backends, ekklo: backends.ekkloWith(store));
}

Future<void> _tap(WidgetTester tester, Finder target) async {
  await tester.ensureVisible(target);
  await tester.pumpAndSettle();
  await tester.tap(target);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows a MyFitnessPal row without id with nothing left to write '
      'when Ekklo is unreadable', (tester) async {
    _stillClocks(tester);
    final backends = FakeBackends(
      mealNames: [breakfast],
      entries: [entry(null)],
    );
    await _pumpWithoutEkklo(tester, backends);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -400));
    await tester.pumpAndSettle();
    check(find.text('Ekklo indisponible').evaluate()).length.equals(1);
    check(find.text(oats).evaluate()).length.equals(1);
    check(_mfpPill.evaluate()).isEmpty();
  });

  testWidgets('shows a food still waiting for MyFitnessPal next to a row '
      'without id when Ekklo is unreadable', (tester) async {
    _stillClocks(tester);
    final gratin = mfpFood(
      'mfp-gratin',
      description: 'Gratin dauphinois',
      nutrients: nutrients(kcal: 320),
    );
    final backends = FakeBackends(
      mealNames: [breakfast],
      entries: [entry(null)],
      mfpFoods: [gratin],
      mfpSearches: {
        'gratin': [gratin],
      },
    )..mfpAddGate = Completer<void>();
    final store = await backends.ekkloTokenStore();
    await pumpFujin(tester, backends, ekklo: backends.ekkloWith(store));

    await _tap(tester, find.text('Ajouter un aliment').last);
    await tester.enterText(find.byType(TextField), 'gratin');
    await tester.pump(AddSearchNotifier.typingPause);
    await tester.pumpAndSettle();
    await _tap(tester, find.text('Gratin dauphinois').first);
    await _tap(tester, find.text('Ajouter à MFP et Ekklo'));
    tester
        .state<ScaffoldMessengerState>(find.byType(ScaffoldMessenger))
        .clearSnackBars();
    await store.write(FakeBackends.staleEkkloTokens);
    await tester.drag(find.byType(CustomScrollView), const Offset(0, 2000));
    await tester.pumpAndSettle();
    await tester.fling(
      find.byType(CustomScrollView),
      const Offset(0, 400),
      1000,
    );
    await tester.pumpAndSettle();

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -400));
    await tester.pumpAndSettle();
    check(find.text('Ekklo indisponible').evaluate()).length.equals(1);
    check(find.text(oats).evaluate()).length.equals(1);
    check(find.text('Gratin dauphinois').evaluate()).length.equals(1);
    check(_mfpPill.evaluate()).length.equals(1);
  });
}
