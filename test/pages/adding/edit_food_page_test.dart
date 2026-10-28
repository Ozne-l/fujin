import 'dart:async';

import 'package:checks/checks.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fujin/app/app_environment.dart';
import 'package:fujin/app/fujin_route.dart';
import 'package:fujin/pages/common/day_picker_sheet.dart';
import 'package:go_router/go_router.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

import '../../support/fake_backends.dart';
import '../../support/fixtures.dart';
import '../../support/logged_journal.dart';

const _title = 'Modifier l’aliment';
const _saveBoth = 'Enregistrer dans MFP et Ekklo';
const _saveMfp = 'Enregistrer dans MFP';
const _deleteBoth = 'Supprimer de MFP et Ekklo';
const _deleteMfp = 'Supprimer de MFP';
const _other = 'Autre';
const _edited = 'Riz basmati modifié';
const _retry = 'Réessayer';
const _oldRice = 'ekklo-old-rice';
const _resavedBasmati = 'e-basmati-before';
const _reloaded =
    'Valeurs rechargées : 200 → 210 kcal / 100 g. Ce qui a '
    'bougé est surligné en jaune.';
const _blockedInDev =
    'Fūjin DEV n’écrit ni dans MyFitnessPal ni dans Ekklo : rien n’a changé.';

Future<void> _open(
  WidgetTester tester,
  FakeBackends backends,
  String row,
) async {
  await LoggedJournal.pump(tester, backends);
  await tester.tap(find.text(row));
  await tester.pumpAndSettle();
}

Future<void> _servings(WidgetTester tester, String servings) async {
  await tester.enterText(find.widgetWithText(TextField, _other), servings);
  await tester.pumpAndSettle();
}

Future<void> _tap(WidgetTester tester, String label) async {
  final target = find.text(label);
  await tester.ensureVisible(target);
  await tester.pumpAndSettle();
  await tester.tap(target);
  await tester.pumpAndSettle();
}

bool _enabled(WidgetTester tester, String label) => tester
    .widget<ButtonStyleButton>(
      find.ancestor(
        of: find.text(label),
        matching: find.bySubtype<ButtonStyleButton>(),
      ),
    )
    .enabled;

FakeBackends _newerBasmati() {
  final backends = LoggedJournal.backends(
    foods: [
      mfpFood(
        rice,
        description: LoggedJournal.basmati,
        version: '2',
        servingSizes: const [
          MfpServingSize(value: 100, unit: grams, nutritionMultiplier: 1),
          MfpServingSize(value: 1, unit: cup, nutritionMultiplier: 3),
        ],
        nutrients: nutrients(kcal: 210),
      ),
    ],
  );
  backends.entries = [
    for (final logged in backends.entries)
      switch (logged.id) {
        LoggedJournal.basmatiId => entry(
          LoggedJournal.basmatiId,
          food: rice,
          meal: lunch,
          servings: 1.5,
          description: LoggedJournal.basmati,
          version: '1',
          nutrients: nutrients(kcal: 300),
        ),
        _ => logged,
      },
  ];
  return backends;
}

FakeBackends _replacedBasmati({String? oldName}) =>
    LoggedJournal.backends()
      ..ekkloMeals = [
        meal(LoggedJournal.lunchMeal, [
          EkkloDailyMealItem(
            id: LoggedJournal.basmatiItem,
            itemType: EkkloMealItemType.food,
            quantity: 150,
            quantityType: EkkloQuantityType.grams,
            foodId: _oldRice,
            food: switch (oldName) {
              final name? => ekkloFood(_oldRice, name: name),
              null => null,
            },
          ),
        ], name: dejeuner),
      ];

void _sees(String text) => check(find.text(text).evaluate()).isNotEmpty();

void _missing(String text) => check(find.text(text).evaluate()).isEmpty();

void main() {
  testWidgets('greys Enregistrer until something changes', (tester) async {
    await _open(tester, LoggedJournal.backends(), LoggedJournal.basmati);

    _sees(_title);
    check(_enabled(tester, _saveBoth)).isFalse();

    await _servings(tester, '2');

    check(_enabled(tester, _saveBoth)).isTrue();
  });

  testWidgets('says the Ekklo quantity it will update', (tester) async {
    await _open(tester, LoggedJournal.backends(), LoggedJournal.basmati);

    await _servings(tester, '2');

    _sees('Ekklo : $riceInEkklo, 150 g → 200 g');
    _sees('même aliment, quantité mise à jour');
  });

  testWidgets('saves the new quantity in both apps and says so on the '
      'Journal', (tester) async {
    final backends = LoggedJournal.backends();
    await _open(tester, backends, LoggedJournal.basmati);
    await _servings(tester, '2');

    await _tap(tester, _saveBoth);

    _missing(_title);
    _sees(_edited);
    _sees('MyFitnessPal et Ekklo · 2 × 100 g');
    check(
      backends.entries.where((entry) => entry.food.id == rice).single.servings,
    ).equals(2);
    check(backends.ekkloItems.single.quantity).equals(200);
  });

  testWidgets('puts the original quantity back on Annuler', (tester) async {
    final backends = LoggedJournal.backends();
    await _open(tester, backends, LoggedJournal.basmati);
    await _servings(tester, '2');
    await _tap(tester, _saveBoth);

    await _tap(tester, 'Annuler');

    check(
      backends.entries.where((entry) => entry.food.id == rice).single.servings,
    ).equals(1.5);
    check(backends.ekkloItems.single.quantity).equals(150);
  });

  testWidgets('says Ekklo was not updated, and finishes on Réessayer', (
    tester,
  ) async {
    final backends = LoggedJournal.backends()..ekkloItemWritesFail = true;
    await _open(tester, backends, LoggedJournal.basmati);
    await _servings(tester, '2');

    await _tap(tester, _saveBoth);

    _sees('Ekklo pas mis à jour');
    _sees('À mettre à jour');

    backends.ekkloItemWritesFail = false;
    await _tap(tester, _retry);

    _sees(_edited);
    check(backends.ekkloItems.single.quantity).equals(200);
  });

  testWidgets('says the food is twice in MyFitnessPal when the original '
      'stayed, and removes it on Réessayer', (tester) async {
    final backends = LoggedJournal.backends()..mfpRemoveFails = true;
    await _open(tester, backends, LoggedJournal.basmati);
    await _servings(tester, '2');

    await _tap(tester, _saveBoth);

    _sees('Riz basmati en double dans MyFitnessPal');
    _sees('L’ancienne entrée n’a pas pu être retirée.');
    check(find.text(LoggedJournal.basmati).evaluate()).length.equals(2);

    backends.mfpRemoveFails = false;
    await _tap(tester, _retry);

    _sees(_edited);
    check(
      backends.entries.where((entry) => entry.food.id == rice),
    ).length.equals(1);
  });

  testWidgets('offers MyFitnessPal only for a food not in Ekklo yet', (
    tester,
  ) async {
    await _open(tester, LoggedJournal.backends(), LoggedJournal.skyrNature);

    _sees('Pas encore dans Ekklo');
    _sees('le prochain envoi prendra 100 g');
    _sees(_saveMfp);
    _sees(_deleteMfp);
    _missing(_saveBoth);
  });

  testWidgets('deletes the food from the fiche after the sheet', (
    tester,
  ) async {
    final backends = LoggedJournal.backends();
    await _open(tester, backends, LoggedJournal.basmati);

    await _tap(tester, _deleteBoth);
    _sees('Supprimer Riz basmati ?');
    await tester.tap(find.text(_deleteBoth).last);
    await tester.pumpAndSettle();

    _missing(_title);
    _sees('Riz basmati supprimé');
    check(backends.ekkloItems).isEmpty();
  });

  testWidgets('refuses a food MyFitnessPal no longer gives', (tester) async {
    await _open(
      tester,
      LoggedJournal.backends(foods: const []),
      LoggedJournal.basmati,
    );

    _sees(
      'MyFitnessPal ne donne plus cet aliment : Fūjin ne peut pas le '
      'modifier. Tu peux toujours le supprimer depuis le Journal.',
    );
    _missing(_saveBoth);
  });

  testWidgets('refuses a serving the food no longer has', (tester) async {
    await _open(
      tester,
      LoggedJournal.backends(
        foods: [
          mfpFood(
            rice,
            description: LoggedJournal.basmati,
            servingSizes: const [
              MfpServingSize(value: 1, unit: cup, nutritionMultiplier: 1),
            ],
          ),
        ],
      ),
      LoggedJournal.basmati,
    );

    _sees(
      'Cette portion n’existe plus pour cet aliment dans MyFitnessPal : '
      'Fūjin ne peut pas le modifier. Tu peux toujours le supprimer depuis '
      'le Journal.',
    );
    _missing(_saveBoth);
  });

  testWidgets('says why it cannot edit when the connection dropped since '
      'the Journal was read', (tester) async {
    final backends = LoggedJournal.backends();
    await LoggedJournal.pump(tester, backends);
    backends
      ..mfpReachable = false
      ..ekkloReachable = false;

    await tester.tap(find.text(LoggedJournal.basmati));
    await tester.pumpAndSettle();

    _sees('Hors ligne : modifier ou supprimer attendra le réseau.');
    _missing(_saveBoth);
    _missing(_deleteBoth);
  });

  testWidgets('returns to the Journal when the food is no longer in the day '
      'read', (tester) async {
    final backends = LoggedJournal.backends();
    await LoggedJournal.pump(tester, backends);

    unawaited(
      GoRouter.of(
        tester.element(find.text(LoggedJournal.basmati)),
      ).push<void>(FujinRoute.editFood.forEntry(now, 'e-gone')),
    );
    await tester.pumpAndSettle();

    _missing(_title);
    _sees(LoggedJournal.basmati);
  });

  testWidgets('moves the food to another day and says where', (tester) async {
    final backends = LoggedJournal.backends();
    await _open(tester, backends, LoggedJournal.basmati);
    await tester.tap(find.byIcon(Icons.calendar_today_outlined));
    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(
        of: find.byType(DayPickerSheet),
        matching: find.text('6'),
      ),
    );
    await tester.pumpAndSettle();
    _sees('jour : 7 oct. → 6 oct.');
    await _tap(tester, _saveBoth);

    _sees('Riz basmati déplacé');
    _sees('$lunch, 6 octobre');
    _sees('Voir');
    check(
      backends.entries.where((entry) => entry.food.id == rice).single.date,
    ).equals(DateTime.utc(2026, 10, 6));
    check(backends.ekkloMeals.where((meal) => meal.date == day)).every(
      (it) => it.has((meal) => meal.items, 'items').isEmpty(),
    );
    _missing(LoggedJournal.basmati);

    await _tap(tester, 'Voir');

    _sees('1/1 · ${LoggedJournal.basmati}');
  });

  testWidgets('stops the day picker at today', (tester) async {
    await _open(tester, LoggedJournal.backends(), LoggedJournal.basmati);
    await tester.tap(find.byIcon(Icons.calendar_today_outlined));
    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(
        of: find.byType(DayPickerSheet),
        matching: find.text('8'),
      ),
    );
    await tester.pumpAndSettle();

    check(find.byType(DayPickerSheet).evaluate()).length.equals(1);
  });

  testWidgets('says nothing changes in Ekklo while nothing changed (A08a)', (
    tester,
  ) async {
    await _open(tester, LoggedJournal.backends(), LoggedJournal.basmati);

    _sees('Ekklo : $riceInEkklo, 150 g');
    _sees('déjà dans Ekklo');
  });

  testWidgets('moves the Ekklo item to the meal chosen (A08c)', (
    tester,
  ) async {
    final backends = LoggedJournal.backends();
    await _open(tester, backends, LoggedJournal.basmati);

    await _tap(tester, lunch);
    await _tap(tester, breakfast);

    _sees('repas : $dejeuner → $petitDejeuner');

    await _tap(tester, _saveBoth);

    check(
      backends.entries.where((entry) => entry.food.id == rice).single.mealName,
    ).equals(breakfast);
    check(
      backends.ekkloMeals
          .where((meal) => meal.items.isNotEmpty)
          .map((meal) => meal.name),
    ).deepEquals([petitDejeuner]);
  });

  testWidgets('shows the values reloaded from a newer food version (A06e)', (
    tester,
  ) async {
    await LoggedJournal.pump(tester, _newerBasmati());
    await tester.tap(find.text(LoggedJournal.basmati));
    await tester.pumpAndSettle();

    _sees(_reloaded);
  });

  testWidgets('keeps the reloaded values per the serving opened when the '
      'serving changes (A06e)', (tester) async {
    await LoggedJournal.pump(tester, _newerBasmati());
    await tester.tap(find.text(LoggedJournal.basmati));
    await tester.pumpAndSettle();

    await _tap(tester, '100 g');
    await _tap(tester, '1 cup');

    _sees(_reloaded);
  });

  testWidgets('names the Ekklo food it replaces', (tester) async {
    await LoggedJournal.pump(tester, _replacedBasmati(oldName: 'Riz rond'));
    await tester.tap(find.text(LoggedJournal.basmati));
    await tester.pumpAndSettle();

    await _servings(tester, '2');

    _sees('Ekklo : Riz rond remplacé par $riceInEkklo, 200 g');
  });

  testWidgets('says it replaces the Ekklo food without a name Ekklo did not '
      'give', (tester) async {
    await LoggedJournal.pump(tester, _replacedBasmati());
    await tester.tap(find.text(LoggedJournal.basmati));
    await tester.pumpAndSettle();

    await _servings(tester, '2');

    _sees('Ekklo : remplacé par $riceInEkklo, 200 g');
  });

  testWidgets('opens read-only when the MyFitnessPal session expired since '
      'the Journal was read (A08g)', (tester) async {
    final backends = LoggedJournal.backends();
    final store = InMemoryMfpSessionStore();
    final mfp = backends.mfpWith(store);
    await mfp.signIn(FakeBackends.mfpSession);
    await LoggedJournal.pump(tester, backends, mfp: mfp);
    await store.clear();

    await tester.tap(find.text(LoggedJournal.basmati));
    await tester.pumpAndSettle();

    _sees(
      'Session MyFitnessPal expirée : modifier ou supprimer attendra la '
      'reconnexion.',
    );
    _missing(_saveBoth);
    _missing(_deleteBoth);
  });

  testWidgets('turns read-only when the Ekklo session expires while the '
      'fiche is open (A08g)', (tester) async {
    final backends = LoggedJournal.backends();
    final store = await backends.ekkloTokenStore();
    await LoggedJournal.pump(
      tester,
      backends,
      ekklo: backends.ekkloWith(store),
    );
    await tester.tap(find.text(LoggedJournal.basmati));
    await tester.pumpAndSettle();
    await _servings(tester, '2');

    await store.write(FakeBackends.staleEkkloTokens);
    tester.binding
      ..handleAppLifecycleStateChanged(AppLifecycleState.inactive)
      ..handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();

    _sees(
      'Session Ekklo expirée : modifier ou supprimer attendra la '
      'reconnexion.',
    );
    check(_enabled(tester, _saveBoth)).isFalse();
    _missing(_deleteBoth);
  });

  testWidgets('updates a food À mettre à jour in Ekklo with the edit', (
    tester,
  ) async {
    final backends = LoggedJournal.backends()
      ..ekkloMeals = [
        meal(LoggedJournal.lunchMeal, [
          item(LoggedJournal.basmatiItem, food: riceInEkklo),
        ], name: dejeuner),
      ];
    await LoggedJournal.pump(
      tester,
      backends,
      linked: LoggedJournal.basmatiLink(entryId: _resavedBasmati, servings: 1),
    );
    _sees('À mettre à jour');
    await tester.tap(find.text(LoggedJournal.basmati));
    await tester.pumpAndSettle();

    await _servings(tester, '2');
    await _tap(tester, _saveBoth);

    _sees(_edited);
    _missing('À mettre à jour');
    check(backends.ekkloItems.single.quantity).equals(200);
  });

  testWidgets('stays on the fiche and says why when MyFitnessPal refuses the '
      'edit', (tester) async {
    final backends = LoggedJournal.backends()..mfpWritesFail = true;
    await _open(tester, backends, LoggedJournal.basmati);
    await _servings(tester, '2');

    await _tap(tester, _saveBoth);

    _sees('MyFitnessPal ne répond pas.');
    _sees(_title);
    check(_enabled(tester, _saveBoth)).isTrue();
    check(backends.ekkloItems.single.quantity).equals(150);
  });

  testWidgets('says Fūjin DEV writes nothing when an edit is blocked', (
    tester,
  ) async {
    final backends = LoggedJournal.backends();
    await LoggedJournal.pump(tester, backends, environment: AppEnvironment.dev);
    await tester.tap(find.text(LoggedJournal.basmati));
    await tester.pumpAndSettle();
    await _servings(tester, '2');

    await _tap(tester, _saveBoth);

    _sees(_blockedInDev);
    _sees(_title);
    check(
      backends.entries.where((entry) => entry.food.id == rice).single.servings,
    ).equals(1.5);
  });
}
