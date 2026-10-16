import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/data/memory/remembered_unit.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

import '../support/fake_backends.dart';
import '../support/fixtures.dart';
import '../support/pump_fujin.dart';

const _snack = 'Collation';
const _thaiRiceName = 'Riz thaï';

FakeBackends _riceBackends() => FakeBackends(
  mealNames: [breakfast, lunch],
  mfpFoods: [
    mfpFood(
      rice,
      description: _thaiRiceName,
      servingSizes: const [
        MfpServingSize(value: 100, unit: grams, nutritionMultiplier: 1),
        MfpServingSize(value: 1, unit: cup, nutritionMultiplier: 1.8),
      ],
      nutrients: nutrients(kcal: 350),
    ),
  ],
);

Future<void> _tap(WidgetTester tester, String text) async {
  final target = find.text(text).last;
  await tester.ensureVisible(target);
  await tester.pumpAndSettle();
  await tester.tap(target);
  await tester.pumpAndSettle();
}

int _count(String text) => find.text(text).evaluate().length;

Future<void> _back(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.chevron_left));
  await tester.pumpAndSettle();
}

Future<void> _openMemory(WidgetTester tester, FakeBackends backends) async {
  await pumpFujin(tester, backends, units: memory.units);
  await _tap(tester, 'Mémoire');
}

Future<void> _openMealMenu(WidgetTester tester) async {
  await _openMemory(
    tester,
    FakeBackends(
      mealNames: [breakfast],
      ekkloMeals: [
        meal('meal-1', [item('I-1')], name: _snack),
      ],
    ),
  );
  await _tap(tester, 'Repas (2)');
  await _tap(tester, petitDejeuner);
}

void main() {
  setUp(() {
    final view =
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    addTearDown(view.reset);
    view
      ..physicalSize = const Size(800, 1800)
      ..devicePixelRatio = 1;
  });

  testWidgets('lists the remembered foods and finds one by name', (
    tester,
  ) async {
    await _openMemory(tester, FakeBackends(mealNames: [breakfast]));

    check(_count('Aliments (2)')).equals(1);
    check(_count('→ $riceInEkklo')).equals(1);
    check(_count('1 cup = 180 g')).equals(1);

    await tester.enterText(find.byType(TextField), 'OATS');
    await tester.pumpAndSettle();
    check(_count(oats)).equals(1);
    check(_count(rice)).equals(0);
  });

  testWidgets('never shows the unit weight of a food the search left out', (
    tester,
  ) async {
    await pumpFujin(
      tester,
      FakeBackends(mealNames: [breakfast]),
      units: [
        ...memory.units,
        const RememberedUnit(mfpFoodId: oats, mfpUnit: 'bowl', grams: 40),
      ],
    );
    await _tap(tester, 'Mémoire');
    check(_count('1 bowl = 40 g')).equals(1);

    await tester.enterText(find.byType(TextField), 'rice');
    await tester.pump();
    check(_count('1 cup = 180 g')).equals(1);
    check(_count('1 bowl = 40 g')).equals(0);
  });

  testWidgets('shows the Ekklo values of a remembered food and saves its '
      'unit weight', (tester) async {
    await _openMemory(
      tester,
      FakeBackends(
        mealNames: [breakfast],
        ekkloFoods: [ekkloFood(riceInEkklo, calories: 130)],
      ),
    );

    await _tap(tester, rice);
    check(_count('130 kcal · pour 100 g')).equals(1);

    await tester.enterText(find.byType(TextField), '200');
    await tester.pumpAndSettle();
    await _back(tester);
    check(_count('1 cup = 200 g')).equals(1);
  });

  testWidgets('forgets a food only once the owner confirms', (tester) async {
    await _openMemory(tester, FakeBackends(mealNames: [breakfast]));

    await _tap(tester, rice);
    await _tap(tester, 'Oublier cet aliment');
    await _tap(tester, 'Annuler');
    await _back(tester);
    check(_count(rice)).equals(1);

    await _tap(tester, rice);
    await _tap(tester, 'Oublier cet aliment');
    await _tap(tester, 'Oublier');

    check(_count('Aliments (1)')).equals(1);
    check(_count(rice)).equals(0);
  });

  testWidgets('remembers the Ekklo food chosen with Changer', (tester) async {
    final basmati = ekkloFood('ekklo-basmati', name: 'Riz basmati');
    await _openMemory(
      tester,
      FakeBackends(
        mealNames: [breakfast],
        ekkloFoods: [ekkloFood(riceInEkklo), basmati],
        ekkloSearches: {
          'basmati': [basmati],
        },
      ),
    );

    await _tap(tester, rice);
    await _tap(tester, 'Changer ›');
    await tester.enterText(find.byType(TextField).last, 'basmati');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    await _tap(tester, 'Riz basmati');
    await _tap(tester, 'Associer et mémoriser');
    await _back(tester);

    check(_count('→ Riz basmati')).equals(1);
    check(_count('→ $riceInEkklo')).equals(0);
  });

  testWidgets('swipes between foods and meals and keeps the search', (
    tester,
  ) async {
    await _openMemory(tester, FakeBackends(mealNames: [breakfast]));
    await tester.enterText(find.byType(TextField), 'rice');
    await tester.pumpAndSettle();

    await tester.fling(find.byType(PageView), const Offset(-500, 0), 1000);
    await tester.pumpAndSettle();
    check(_count(petitDejeuner)).equals(1);
    check(_count('→ $riceInEkklo')).equals(0);

    await tester.fling(find.byType(PageView), const Offset(500, 0), 1000);
    await tester.pumpAndSettle();
    check(_count('→ $riceInEkklo')).equals(1);
    check(_count(oats)).equals(0);
    check(_count(petitDejeuner)).equals(0);
  });

  testWidgets('maps a MyFitnessPal meal to a meal seen in Ekklo', (
    tester,
  ) async {
    await _openMealMenu(tester);
    await _tap(tester, _snack);

    check(_count(_snack)).equals(1);
    check(_count(petitDejeuner)).equals(0);
  });

  testWidgets('marks the current Ekklo meal in the open menu and closes it '
      'without change when tapped outside', (tester) async {
    await _openMealMenu(tester);

    check(_count(_snack)).equals(1);
    check(
      tester.widget<Text>(find.text(petitDejeuner).last).style?.color,
    ).equals(FujinColorRole.textLink);

    await tester.tapAt(Offset.zero);
    await tester.pumpAndSettle();

    check(_count(_snack)).equals(0);
    check(_count(petitDejeuner)).equals(1);
  });

  testWidgets('adds a remembered food from its screen in its remembered unit, '
      'confirms it and undoes it on request', (tester) async {
    final backends = _riceBackends();
    await _openMemory(tester, backends);
    await _tap(tester, rice);

    await _tap(tester, 'Ajouter');
    check(_count('Ajouter à $breakfast')).equals(1);
    await _tap(tester, 'Ajouter à MFP et Ekklo');

    check(_count('Oublier cet aliment')).equals(1);
    check(_count('$_thaiRiceName ajouté')).equals(1);
    check(backends.entries.single)
      ..has((entry) => entry.servingSize.unit, 'unit').equals(cup)
      ..has((entry) => entry.date, 'date').equals(day)
      ..has((entry) => entry.mealName, 'meal').equals(breakfast);

    await _tap(tester, 'Annuler');
    check(backends.entries).isEmpty();
    check(_count('Ajout annulé')).equals(1);
  });

  testWidgets('returns to Mémoire with the confirmation when the add replaced '
      'the food by an own copy', (tester) async {
    final backends = _riceBackends();
    await _openMemory(tester, backends);
    await _tap(tester, rice);
    await _tap(tester, 'Ajouter');

    await tester.tap(find.textContaining('Ekklo : '));
    await tester.pumpAndSettle();
    await _tap(tester, 'Aliment perso');
    await _tap(tester, "Créer l'aliment perso");
    await _tap(tester, 'Ajouter à MFP et Ekklo');

    check(_count('Oublier cet aliment')).equals(0);
    check(_count('Aliments (2)')).equals(1);
    check(_count('$_thaiRiceName ajouté')).equals(1);
    check(backends.entries.single.servingSize.unit).equals(cup);
  });

  testWidgets('comes back to the food screen when the fiche is left', (
    tester,
  ) async {
    final backends = _riceBackends();
    await _openMemory(tester, backends);
    await _tap(tester, rice);
    await _tap(tester, 'Ajouter');
    check(_count('Ajouter à MFP et Ekklo')).equals(1);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    check(_count('Oublier cet aliment')).equals(1);
    check(backends.entries).isEmpty();
  });

  testWidgets('greys out Ajouter while adding is not possible', (
    tester,
  ) async {
    final backends = _riceBackends();
    await pumpFujin(tester, backends, units: memory.units);
    backends
      ..mfpReachable = false
      ..ekkloReachable = false;
    await tester.fling(
      find.byType(CustomScrollView),
      const Offset(0, 1000),
      1000,
    );
    await tester.pumpAndSettle();
    await _tap(tester, 'Mémoire');
    await _tap(tester, rice);

    check(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Ajouter'))
          .onPressed,
    ).isNull();
  });

  testWidgets('closes the open meal menu on back and stays on Mémoire', (
    tester,
  ) async {
    await _openMealMenu(tester);
    check(_count(_snack)).equals(1);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    check(_count(_snack)).equals(0);
    check(_count(petitDejeuner)).equals(1);
    check(_count('Repas (2)')).equals(1);
  });
}
