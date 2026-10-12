import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/data/settings/setting.dart';
import 'package:fujin/pages/sending/kept_choices_notifier.dart';
import 'package:fujin/pages/sending/send_notifier.dart';
import 'package:fujin/pages/sending/send_state.dart';
import 'package:fujin/pages/sending/widgets/automatic_sent_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../support/fake_backends.dart';
import '../support/fixtures.dart';
import '../support/in_memory_preferences.dart';
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

  group('in automatic mode', () {
    FakeBackends automaticDay() => FakeBackends(
      mealNames: [breakfast],
      entries: [skyrEntry, entry('E-2')],
      ekkloSearches: {
        'skyr': [isey, siggis],
      },
    );

    Future<void> pumpAutomatic(
      WidgetTester tester,
      FakeBackends backends,
    ) async => pumpFujin(
      tester,
      backends,
      preferences: await inMemoryPreferences(on: [Setting.automaticMode]),
    );

    testWidgets('sends without review and lists the choices made without '
        'the owner', (tester) async {
      final backends = automaticDay();
      await pumpAutomatic(tester, backends);

      await _tap(tester, 'Envoyer 2 aliments vers Ekklo');
      _sees('Envoi terminé');
      _sees('Fūjin a envoyé 2 aliments vers Ekklo.');
      _sees("Mode automatique : rien ne t'a été demandé.");
      _sees('CHOIX FAITS SANS TOI (1)');
      _sees('→ Skyr nature 0 % · Isey (le plus proche)');
      check(find.text('1 à vérifier').evaluate()).isEmpty();
      check(backends.ekkloItems).length.equals(2);

      await _tap(tester, 'Retour au journal');
      check(find.text('À envoyer').evaluate()).isEmpty();
      check(find.text('À mettre à jour').evaluate()).isEmpty();
    });

    testWidgets('keeps a choice reviewed with Revoir', (tester) async {
      final backends = automaticDay();
      await pumpAutomatic(tester, backends);
      await _tap(tester, 'Envoyer 2 aliments vers Ekklo');

      await _tap(tester, 'Revoir');
      await _tap(tester, 'Associer et mémoriser');
      _sees('Mémorisé');
      check(find.text('Revoir').evaluate()).isEmpty();

      await _tap(tester, 'Retour au journal');
      check(find.text('À mettre à jour').evaluate()).isEmpty();
      await _tap(tester, 'Réglages');
      _sees('3 aliments et 2 repas');
    });

    testWidgets('keeps a choice once when Revoir is confirmed twice', (
      tester,
    ) async {
      final backends = automaticDay();
      await pumpAutomatic(tester, backends);
      await _tap(tester, 'Envoyer 2 aliments vers Ekklo');
      final container = ProviderScope.containerOf(
        tester.element(find.byType(AutomaticSentView)),
      );
      final report = switch (container.read(sendProvider(day))) {
        SendDone(:final report) => report,
        _ => throw StateError('send not done'),
      };
      final planned = report.unattended.single.asOwnCopy();
      final kept = container.read(keptChoicesProvider(day).notifier);
      final ownCopiesBefore = backends.ekkloFoods.length;

      final first = kept.keep(planned);
      final second = kept.keep(planned);
      check(
        container.read(keptChoicesProvider(day)).keeping,
      ).deepEquals({planned.entryId});
      await Future.wait([first, second]);
      await tester.pumpAndSettle();

      check(backends.ekkloFoods).length.equals(ownCopiesBefore + 1);
      _sees('Mémorisé');
    });

    testWidgets('says the network is gone and keeps Revoir when a choice '
        'cannot be kept', (tester) async {
      final backends = automaticDay();
      await pumpAutomatic(tester, backends);
      await _tap(tester, 'Envoyer 2 aliments vers Ekklo');

      backends.ekkloReachable = false;
      await _tap(tester, 'Revoir');
      await _tap(tester, 'Aliment perso');
      await _tap(tester, "Créer l'aliment perso");
      _sees('Pas de connexion internet.');
      _sees('Revoir');
      check(find.text('Mémorisé').evaluate()).isEmpty();
    });

    testWidgets('lists a weight deduced from the kcal and an own copy made '
        'without the owner', (tester) async {
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
          entry('E-2', food: 'Tofu fumé', description: 'Tofu fumé'),
        ],
        ekkloFoods: [ekkloFood(riceInEkklo, calories: 130, carbs: 28)],
      );
      await pumpAutomatic(tester, backends);

      await _tap(tester, 'Envoyer 2 aliments vers Ekklo');
      _sees('CHOIX FAITS SANS TOI (2)');
      check(
        find.textContaining(', poids déduit des kcal').evaluate(),
      ).length.equals(1);
      _sees('→ aliment perso créé');
    });

    testWidgets('leaves an entry to update when Revoir keeps another food', (
      tester,
    ) async {
      final backends = automaticDay();
      await pumpAutomatic(tester, backends);
      await _tap(tester, 'Envoyer 2 aliments vers Ekklo');

      await _tap(tester, 'Revoir');
      await _tap(tester, 'Skyr');
      await _tap(tester, 'Associer et mémoriser');
      _sees('Mémorisé');
      check(
        backends.ekkloItems.map((item) => item.foodId),
      ).contains(isey.id);

      await _tap(tester, 'Retour au journal');
      _sees('À mettre à jour');
      _sees('Mettre à jour 1 aliment dans Ekklo');
    });

    testWidgets('says what stopped an automatic send and ends on its '
        'result', (tester) async {
      final backends = automaticDay();
      backends.failingMeals.add(petitDejeuner);
      await pumpAutomatic(tester, backends);

      await _tap(tester, 'Envoyer 2 aliments vers Ekklo');
      _sees('Envoi interrompu');

      backends.failingMeals.clear();
      await _tap(tester, 'Envoyer les 2 aliments restants');
      _sees("Mode automatique : rien ne t'a été demandé.");
      check(backends.ekkloItems).length.equals(2);
    });
  });
}
