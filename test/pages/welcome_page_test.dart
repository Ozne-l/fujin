import 'package:checks/checks.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

import '../support/fake_backends.dart';
import '../support/fixtures.dart';
import '../support/pump_fujin.dart';

FilledButton _continueButton(WidgetTester tester) =>
    tester.widget(find.widgetWithText(FilledButton, 'Continuer'));

void main() {
  testWidgets(
    'opens on the welcome screen, without reading the diary, until both '
    'accounts are signed in',
    (tester) async {
      final backends = FakeBackends(mealNames: [breakfast]);

      await pumpFujin(
        tester,
        backends,
        mfp: backends.mfpWith(InMemoryMfpSessionStore()),
        ekklo: backends.ekkloWith(InMemoryEkkloTokenStore()),
      );

      check(
        find.text('Note une fois,\nton coach voit tout.').evaluate(),
      ).length.equals(1);
      check(find.text('Se connecter').evaluate()).length.equals(2);
      check(_continueButton(tester).onPressed).isNull();
      check(backends.requests).isEmpty();
    },
  );

  testWidgets(
    'signs in to Ekklo from the welcome screen, then continues to the Journal',
    (tester) async {
      final backends = FakeBackends(
        mealNames: [breakfast],
        entries: [entry('E-1')],
        ekkloMeals: [
          meal('meal-1', [item('I-1')]),
        ],
      );
      await pumpFujin(
        tester,
        backends,
        ekklo: backends.ekkloWith(InMemoryEkkloTokenStore()),
      );
      check(find.text('Session active').evaluate()).length.equals(1);

      await tester.tap(find.text('Se connecter'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byType(TextField).first,
        FakeBackends.ekkloEmail,
      );
      await tester.enterText(
        find.byType(TextField).last,
        FakeBackends.ekkloPassword,
      );
      await tester.pump();
      await tester.tap(find.text('Se connecter'));
      await tester.pumpAndSettle();

      check(find.text('Connecté').evaluate()).length.equals(2);
      await tester.tap(find.text('Continuer'));
      await tester.pumpAndSettle();

      check(find.text('1/1 dans Ekklo').evaluate()).length.equals(1);
    },
  );
}
