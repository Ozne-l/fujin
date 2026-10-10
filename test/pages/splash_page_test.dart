import 'package:checks/checks.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart'
    show WidgetTester, addTearDown, find, testWidgets;
import 'package:fujin/app/app_environment.dart';
import 'package:fujin/app/splash_app.dart';
import 'package:fujin/pages/common/seigaiha_band.dart';
import 'package:fujin/pages/splash/splash_view.dart';

import '../support/fake_backends.dart';
import '../support/fixtures.dart';
import '../support/gated_ekklo_token_store.dart';
import '../support/pump_fujin.dart';

const _title = 'Fūjin';
const _tagline = 'Laisse le vent faire.';

void main() {
  testWidgets(
    'shows the splash from the first frame while the app opens its database',
    (tester) async {
      await _pumpSplashApp(tester);

      check(find.text(_title).evaluate()).length.equals(1);
      check(find.text(_tagline).evaluate()).length.equals(1);
    },
  );

  testWidgets(
    'hands over to the splash route without moving the logo, the title or '
    'the tagline',
    (tester) async {
      await _pumpSplashApp(tester);
      final opening = _layout(tester);
      final backends = FakeBackends(mealNames: [breakfast]);
      final tokens = GatedEkkloTokenStore(InMemoryEkkloTokenStore());

      await pumpFujin(tester, backends, ekklo: backends.ekkloWith(tokens));

      check(_layout(tester)).deepEquals(opening);
    },
  );

  testWidgets(
    'shows the splash while the sessions are read, then the Journal once '
    'both accounts are signed in',
    (tester) async {
      final backends = FakeBackends(
        mealNames: [breakfast],
        entries: [entry('E-1')],
        ekkloMeals: [
          meal('meal-1', [item('I-1')]),
        ],
      );
      final tokens = GatedEkkloTokenStore(await backends.ekkloTokenStore());

      await pumpFujin(tester, backends, ekklo: backends.ekkloWith(tokens));

      check(find.text(_tagline).evaluate()).length.equals(1);

      tokens.open();
      await tester.pumpAndSettle();

      check(find.text(_tagline).evaluate()).isEmpty();
      check(find.text('1/1 dans Ekklo').evaluate()).length.equals(1);
    },
  );

  testWidgets(
    'shows the splash while the sessions are read, then the welcome screen '
    'when a session is missing',
    (tester) async {
      final backends = FakeBackends(mealNames: [breakfast]);
      final tokens = GatedEkkloTokenStore(InMemoryEkkloTokenStore());

      await pumpFujin(tester, backends, ekklo: backends.ekkloWith(tokens));

      check(find.text(_tagline).evaluate()).length.equals(1);

      tokens.open();
      await tester.pumpAndSettle();

      check(find.text(_tagline).evaluate()).isEmpty();
      check(
        find.text('Note une fois,\nton coach voit tout.').evaluate(),
      ).length.equals(1);
    },
  );
}

Future<void> _pumpSplashApp(WidgetTester tester) async {
  tester.platformDispatcher.localesTestValue = const [Locale('fr')];
  addTearDown(tester.platformDispatcher.clearLocalesTestValue);
  await tester.pumpWidget(
    const SplashApp(environment: AppEnvironment.production),
  );
}

List<Rect> _layout(WidgetTester tester) => [
  tester.getRect(find.byType(SplashView)),
  tester.getRect(find.byType(SeigaihaBand)),
  tester.getRect(find.text(_title)),
  tester.getRect(find.text(_tagline)),
];
