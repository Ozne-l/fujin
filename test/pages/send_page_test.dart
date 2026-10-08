import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_backends.dart';
import '../support/fixtures.dart';
import '../support/pump_fujin.dart';

Future<void> _tap(WidgetTester tester, String text) async {
  final target = find.text(text);
  await tester.ensureVisible(target);
  await tester.pumpAndSettle();
  await tester.tap(target);
  await tester.pumpAndSettle();
}

void _sees(String text) => check(find.text(text).evaluate()).isNotEmpty();

void main() {
  setUp(() {
    final view =
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    addTearDown(view.reset);
    view
      ..physicalSize = const Size(800, 1800)
      ..devicePixelRatio = 1;
  });

  testWidgets('sends a day reviewed on screen 10 and comes back to a '
      'Journal all in Ekklo', (tester) async {
    final backends = FakeBackends(
      mealNames: [breakfast, 'Collations'],
      entries: [
        entry('E-1'),
        entry(
          'E-2',
          food: skyr,
          description: 'Skyr nature',
          brand: 'Isey',
          meal: 'Collations',
          servingValue: 250,
          nutrients: nutrients(kcal: 160, protein: 25, carbs: 10, fat: 0.5),
        ),
      ],
      ekkloSearches: {
        'skyr': [isey, siggis],
      },
    );
    await pumpFujin(tester, backends);

    await _tap(tester, 'Envoyer 2 aliments vers Ekklo');
    _sees('1 à vérifier');
    _sees('Nouvelle association');

    await _tap(tester, 'Envoyer 2 aliments vers Ekklo');
    _sees('Envoi terminé');
    _sees('Fūjin a envoyé 2 aliments vers Ekklo.');
    _sees('1 nouvelle association : Skyr nature');

    await _tap(tester, 'Retour au journal');
    check(find.text('1/1 dans Ekklo').evaluate()).length.equals(2);
    check(backends.ekkloItems).length.equals(2);
  });

  testWidgets('says what stopped a send and sends only what is missing', (
    tester,
  ) async {
    final backends = FakeBackends(
      mealNames: [breakfast, lunch],
      entries: [
        entry('E-1'),
        entry('E-2', meal: lunch),
      ],
    );
    backends.failingMeals.add(dejeuner);
    await pumpFujin(tester, backends);

    await _tap(tester, 'Envoyer 2 aliments vers Ekklo');
    await _tap(tester, 'Envoyer 2 aliments vers Ekklo');
    _sees('Envoi interrompu');
    _sees("Ekklo a refusé l'envoi : Déjeuner.");
    _sees("1 aliment attend. Rien n'est perdu.");

    backends.failingMeals.clear();
    await _tap(tester, "Envoyer l'aliment restant");
    _sees('Envoi terminé');
    check(backends.ekkloItems).length.equals(2);
  });

  testWidgets('updates an entry changed in MyFitnessPal without review', (
    tester,
  ) async {
    final backends = FakeBackends(
      mealNames: [breakfast],
      entries: [entry('E-2', servings: 2)],
      ekkloMeals: [
        meal('meal-1', [item('I-1')]),
      ],
    );
    await pumpFujin(tester, backends, links: [link('E-1', 'I-1')]);

    await _tap(tester, 'Mettre à jour 1 aliment dans Ekklo');
    _sees('Envoi terminé');
    _sees('1 aliment mis à jour');
    check(backends.ekkloItems.single.quantity).equals(200);
  });
}
