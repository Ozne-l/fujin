import 'package:checks/checks.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../support/fake_backends.dart';
import '../support/fixtures.dart';
import '../support/pump_fujin.dart';

Future<InMemoryEkkloTokenStore> _openSignIn(
  WidgetTester tester,
  FakeBackends backends,
) async {
  final store = InMemoryEkkloTokenStore();
  await store.write(FakeBackends.staleEkkloTokens);
  await pumpFujin(tester, backends, ekklo: backends.ekkloWith(store));
  await tester.tap(find.text('Se reconnecter à Ekklo'));
  await tester.pumpAndSettle();
  return store;
}

Future<void> _signIn(
  WidgetTester tester, {
  String email = FakeBackends.ekkloEmail,
  String password = FakeBackends.ekkloPassword,
}) async {
  await tester.enterText(find.byType(TextField).first, email);
  await tester.enterText(find.byType(TextField).last, password);
  await tester.pump();
  await tester.tap(find.text('Se connecter'));
  await tester.pumpAndSettle();
}

Iterable<http.Request> _logins(FakeBackends backends) => backends.requests
    .where((request) => request.url.path == '/api/v1/auth/login');

void main() {
  testWidgets('signs in to Ekklo, then reads the day again', (tester) async {
    final backends = FakeBackends(
      mealNames: [breakfast],
      entries: [entry('E-1')],
      ekkloMeals: [
        meal('meal-1', [item('I-1')]),
      ],
    );
    final store = await _openSignIn(tester, backends);

    await _signIn(tester, email: ' ${FakeBackends.ekkloEmail} ');

    check(await store.read()).isNotNull();
    check(find.text('Ta session Ekklo a expiré.').evaluate()).isEmpty();
    check(find.text('1/1 dans Ekklo').evaluate()).length.equals(1);
  });

  testWidgets('waits for both fields before calling Ekklo', (tester) async {
    final backends = FakeBackends(mealNames: [breakfast]);
    await _openSignIn(tester, backends);

    await tester.enterText(
      find.byType(TextField).first,
      FakeBackends.ekkloEmail,
    );
    await tester.pump();
    await tester.tap(find.text('Se connecter'));
    await tester.pumpAndSettle();

    check(_logins(backends)).isEmpty();
  });

  testWidgets(
    "shows Ekklo's refusal with its message until the next attempt",
    (tester) async {
      final backends = FakeBackends(mealNames: [breakfast]);
      final store = await _openSignIn(tester, backends);

      await _signIn(tester, password: 'wrong-password');
      await tester.enterText(find.byType(TextField).last, 'another-try');
      await tester.pump();

      check(await store.read()).isNull();
      check(
        find.text('Ekklo a refusé la connexion').evaluate(),
      ).length.equals(1);
      check(
        find.text('« ${FakeBackends.ekkloRefusal} »').evaluate(),
      ).length.equals(1);
    },
  );

  testWidgets('says Ekklo is not responding when it cannot be reached', (
    tester,
  ) async {
    final backends = FakeBackends(mealNames: [breakfast]);
    final store = await _openSignIn(tester, backends);
    backends.ekkloReachable = false;

    await _signIn(tester);

    check(await store.read()).isNull();
    check(find.text('Ekklo ne répond pas').evaluate()).length.equals(1);
    check(
      find.text('Vérifie ta connexion, puis réessaie.').evaluate(),
    ).length.equals(1);
  });
}
