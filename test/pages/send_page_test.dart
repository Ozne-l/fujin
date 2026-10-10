import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fujin/data/memory/remembered_food.dart';

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

void _sees(String text) => check(find.text(text).evaluate()).length.equals(1);

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
      mealNames: [breakfast, snacks],
      entries: [
        entry('E-1'),
        entry(
          'E-2',
          food: skyr,
          description: 'Skyr nature',
          brand: 'Isey',
          meal: snacks,
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
  testWidgets('sends the candidate chosen on sheet 11 and remembers it for '
      'the next send', (tester) async {
    final backends = FakeBackends(
      mealNames: [breakfast],
      entries: [skyrEntry],
      ekkloSearches: {
        'skyr': [isey, siggis],
      },
    );
    await pumpFujin(tester, backends);

    await _tap(tester, 'Envoyer 1 aliment vers Ekklo');
    await _tap(tester, 'Changer ›');
    await _tap(tester, 'Skyr');
    await _tap(tester, 'Associer et mémoriser');
    _sees('→ Skyr');

    await _tap(tester, 'Envoyer 1 aliment vers Ekklo');
    _sees('1 nouvelle association : Skyr nature');
    check(backends.ekkloItems.single.foodId).equals(siggis.id);

    backends.entries = [skyrEntry, entry('E-2', food: skyr, servingValue: 250)];
    await _tap(tester, 'Retour au journal');
    await _tap(tester, 'Envoyer 1 aliment vers Ekklo');
    _sees('1 automatique');
    check(find.text('1 à vérifier').evaluate()).isEmpty();

    await _tap(tester, 'Envoyer 1 aliment vers Ekklo');
    check(
      backends.ekkloItems.map((item) => item.foodId),
    ).deepEquals([siggis.id, siggis.id]);
  });

  testWidgets('leaves a skipped entry out of the send and still to send in '
      'the Journal', (tester) async {
    final backends = FakeBackends(
      mealNames: [breakfast],
      entries: [skyrEntry, entry('E-2')],
      ekkloSearches: {
        'skyr': [isey, siggis],
      },
    );
    await pumpFujin(tester, backends);

    await _tap(tester, 'Envoyer 2 aliments vers Ekklo');
    await _tap(tester, 'Changer ›');
    await _tap(tester, 'Sauter');
    _sees('Sauté');

    await _tap(tester, 'Envoyer 1 aliment vers Ekklo');
    _sees('Fūjin a envoyé 1 aliment vers Ekklo.');
    check(backends.ekkloItems.single.foodId).equals(oatsInEkklo);

    await _tap(tester, 'Retour au journal');
    _sees('À envoyer');
    _sees('Envoyer 1 aliment vers Ekklo');
  });

  testWidgets('sends the quantity of a unit weight confirmed on sheet 12', (
    tester,
  ) async {
    final backends = FakeBackends(
      mealNames: [breakfast],
      entries: [
        entry(
          'E-1',
          food: rice,
          unit: cup,
          servingValue: 1,
          servings: 2,
          nutrients: nutrients(kcal: 468, carbs: 100),
        ),
      ],
      ekkloFoods: [ekkloFood(riceInEkklo, calories: 130, carbs: 28)],
    );
    await pumpFujin(tester, backends);

    await _tap(tester, 'Envoyer 1 aliment vers Ekklo');
    _sees('Poids à confirmer');
    await _tap(tester, 'Confirmer');
    await tester.enterText(find.byType(TextField), '200');
    await _tap(tester, 'Valider');
    _sees('Confirmé');

    await _tap(tester, 'Envoyer 1 aliment vers Ekklo');
    _sees('1 poids retenu : 1 cup = 200 g');
    check(backends.ekkloItems.single)
      ..has((item) => item.foodId, 'food').equals(riceInEkklo)
      ..has((item) => item.quantity, 'quantity').equals(400);
  });

  testWidgets('sends an own copy made from the MyFitnessPal values', (
    tester,
  ) async {
    final backends = FakeBackends(
      mealNames: [breakfast],
      entries: [skyrEntry],
      ekkloSearches: {
        'skyr': [isey, siggis],
      },
    );
    await pumpFujin(tester, backends);

    await _tap(tester, 'Envoyer 1 aliment vers Ekklo');
    await _tap(tester, 'Changer ›');
    await _tap(tester, 'Aliment perso');
    await _tap(tester, "Créer l'aliment perso");
    _sees('→ Aliment perso à créer');

    await _tap(tester, 'Envoyer 1 aliment vers Ekklo');
    _sees('1 aliment perso créé : Skyr nature');
    final ownCopy = backends.ekkloFoods.single;
    check(ownCopy)
      ..has((food) => food.name, 'name').equals('Skyr nature')
      ..has((food) => food.brands, 'brands').equals('Isey')
      ..has((food) => food.portion, 'portion').equals(100)
      ..has((food) => food.calories, 'calories').isCloseTo(64, 0.01)
      ..has((food) => food.proteins, 'proteins').isCloseTo(10, 0.01);
    check(backends.ekkloItems.single)
      ..has((item) => item.foodId, 'food').equals(ownCopy.id)
      ..has((item) => item.quantity, 'quantity').equals(250);
  });

  testWidgets('shows a new unit for a food copied in another unit', (
    tester,
  ) async {
    final backends = FakeBackends(
      mealNames: [breakfast],
      entries: [entry('E-1', food: oil, unit: teaspoon, description: oil)],
    );
    await pumpFujin(
      tester,
      backends,
      ownCopies: const [
        OwnCopy(
          mfpFoodId: oil,
          mfpDescription: oil,
          ekkloFoodId: 'own-oil',
          ekkloFoodName: oil,
          mfpUnit: tablespoon,
        ),
      ],
    );

    await _tap(tester, 'Envoyer 1 aliment vers Ekklo');
    _sees('Nouvelle unité');
    check(find.text('Mémorisé').evaluate()).isEmpty();
  });
}
