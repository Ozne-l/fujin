import 'package:checks/checks.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter_test/flutter_test.dart' show find, testWidgets;

import '../support/fake_backends.dart';
import '../support/fixtures.dart';
import '../support/gated_ekklo_token_store.dart';
import '../support/pump_fujin.dart';

const _tagline = 'Laisse le vent faire.';

void main() {
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
