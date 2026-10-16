import 'dart:async';

import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fujin/app/fujin_app.dart';
import 'package:fujin/app/fujin_route.dart';
import 'package:fujin/app/router.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/data/goals/goals.dart';
import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/domain/adding/added_food.dart';
import 'package:fujin/pages/adding/add_search_notifier.dart';
import 'package:fujin/pages/common/day_picker_sheet.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

import '../../support/fake_backends.dart';
import '../../support/fixtures.dart';
import '../../support/pump_fujin.dart';

const _query = 'flocons';
const _oatsName = 'Flocons d’avoine';
const _addToBoth = 'Ajouter à MFP et Ekklo';
const _barcode = '3275760750398';
const _skyrName = 'Skyr nature';
const _chosenPot = 'choisi, poids d’une pot retenu';

final MfpFood _oats = mfpFood(
  oats,
  description: _oatsName,
  brand: 'Quaker',
  nutrients: nutrients(kcal: 370, protein: 13, carbs: 60, fat: 7, fiber: 10),
);

final MfpFood _oatsChanged = mfpFood(
  oats,
  description: _oatsName,
  brand: 'Quaker',
  version: '2',
  nutrients: nutrients(kcal: 380, protein: 13, carbs: 62, fat: 7, fiber: 10),
);

FakeBackends _backends({List<MfpFood>? stored}) => FakeBackends(
  mealNames: [breakfast, lunch],
  mfpFoods: stored ?? [_oats],
  mfpSearches: {
    _query: [_oats],
  },
);

Future<Future<AddedFood?>> _openAdd(WidgetTester tester) async {
  final container = ProviderScope.containerOf(
    tester.element(find.byType(FujinApp)),
  );
  final result = container
      .read(routerProvider)
      .push<AddedFood>(FujinRoute.addFood.forMeal(day, breakfast));
  await tester.pumpAndSettle();
  return result;
}

Future<void> _search(WidgetTester tester, String text) async {
  await tester.enterText(find.byType(TextField).first, text);
  await tester.pump(AddSearchNotifier.typingPause);
  await tester.pumpAndSettle();
}

Future<void> _tap(WidgetTester tester, String text) async {
  final target = find.text(text);
  await tester.ensureVisible(target);
  await tester.pumpAndSettle();
  await tester.tap(target);
  await tester.pumpAndSettle();
}

Future<void> _openOats(WidgetTester tester) async {
  await _search(tester, _query);
  await _tap(tester, _oatsName);
}

void _sees(String text) => check(find.text(text).evaluate()).length.equals(1);

final MfpFood _skyrInPots = mfpFood(
  skyr,
  description: _skyrName,
  brand: 'Isey',
  servingSizes: const [
    MfpServingSize(value: 1, unit: pot, nutritionMultiplier: 1),
  ],
  nutrients: nutrients(kcal: 64, protein: 10, carbs: 4, fat: 0.2),
);

final MfpFood _skyrInGrams = mfpFood(
  skyr,
  description: _skyrName,
  nutrients: nutrients(kcal: 60, protein: 10, carbs: 4, fat: 0.2),
);

const _skyrInPotsCopy = OwnCopy(
  mfpFoodId: skyr,
  mfpDescription: _skyrName,
  ekkloFoodId: 'own-skyr',
  ekkloFoodName: _skyrName,
  mfpUnit: pot,
);

const _otherSkyrNames = ['Skyr vanille', 'Skyr myrtille'];

final List<MfpFood> _otherSkyrs = [
  for (final name in _otherSkyrNames) mfpFood('$skyr-$name', description: name),
];

FakeBackends _skyrBackends(MfpFood food) => FakeBackends(
  mealNames: [breakfast, lunch],
  mfpFoods: [food],
  mfpSearches: {
    'skyr': [food],
  },
  ekkloSearches: {
    'skyr': [isey],
  },
);

Future<void> _openSkyr(WidgetTester tester) async {
  await _search(tester, 'skyr');
  await _tap(tester, _skyrName);
}

Future<void> _chooseIseyWeighing(WidgetTester tester, String grams) async {
  await _tap(tester, 'Choisir l’aliment Ekklo');
  await _tap(tester, isey.name);
  await _tap(tester, 'Associer et mémoriser');
  await tester.enterText(find.byType(TextField).last, grams);
  await tester.pump();
  await _tap(tester, 'Valider');
}

Future<void> _signInToEkklo(WidgetTester tester) async {
  await _tap(tester, 'Se reconnecter à Ekklo');
  await tester.enterText(find.byType(TextField).first, FakeBackends.ekkloEmail);
  await tester.enterText(
    find.byType(TextField).last,
    FakeBackends.ekkloPassword,
  );
  await tester.pump();
  await _tap(tester, 'Se connecter');
}

Future<void> _signInToMfp(
  WidgetTester tester,
  InMemoryMfpSessionStore store,
) async {
  await tester.tap(find.text('Se reconnecter à MyFitnessPal'));
  await tester.pump();
  tester.takeException();
  await store.write(FakeBackends.mfpSession);
  ProviderScope.containerOf(
    tester.element(find.byType(FujinApp)),
  ).read(routerProvider).pop(true);
  await tester.pumpAndSettle();
}

Iterable<Object> _ekkloSearches(FakeBackends backends) => backends.requests
    .where((request) => request.url.path.endsWith('/food-items/search'));

void _seesPart(String text) =>
    check(find.textContaining(text).evaluate()).length.equals(1);

int _requestIndex(FakeBackends backends, String method, String path) =>
    backends.requests.indexWhere(
      (request) => request.method == method && request.url.path == path,
    );

void main() {
  setUp(() {
    final view =
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    addTearDown(view.reset);
    view
      ..physicalSize = const Size(800, 1800)
      ..devicePixelRatio = 1;
  });

  testWidgets('adds a searched food to MyFitnessPal, then Ekklo, and returns '
      'it to the Journal', (tester) async {
    final backends = _backends();
    await pumpFujin(tester, backends);
    final result = await _openAdd(tester);

    await _openOats(tester);
    _sees('Ajouter à Breakfast');
    _sees('Ekklo : $oatsInEkklo, 100 g');
    _sees('mémorisé');

    await _tap(tester, _addToBoth);

    final added = await result;
    check(
      added,
    ).isNotNull().has((added) => added.ekkloWritten, 'ekklo').isTrue();
    check(backends.entries).length.equals(1);
    check(backends.ekkloItems).length.equals(1);
    check(
      _requestIndex(backends, 'POST', '/v2/diary'),
    ).isLessThan(_requestIndex(backends, 'POST', FakeBackends.dailyMealsPath));
  });

  testWidgets('adds once when the button is tapped twice', (tester) async {
    final backends = _backends();
    await pumpFujin(tester, backends);
    await _openAdd(tester);
    await _openOats(tester);

    final button = find.text(_addToBoth);
    await tester.ensureVisible(button);
    await tester.pumpAndSettle();
    await tester.tap(button);
    await tester.tap(button);
    await tester.pumpAndSettle();

    check(backends.entries).length.equals(1);
    check(
      backends.requests.where(
        (request) =>
            request.method == 'POST' && request.url.path == '/v2/diary',
      ),
    ).length.equals(1);
  });

  testWidgets('reloads a food changed in MyFitnessPal and adds it only once '
      'confirmed', (tester) async {
    final backends = _backends(stored: [_oatsChanged]);
    await pumpFujin(tester, backends);
    final result = await _openAdd(tester);
    await _openOats(tester);

    await _tap(tester, _addToBoth);
    _sees('Cet aliment a changé dans MyFitnessPal');
    check(backends.entries).isEmpty();

    await _tap(tester, 'Confirmer et ajouter');
    check(await result).isNotNull();
    check(backends.entries.single.nutrients.energy?.value).equals(380);
  });

  testWidgets('keeps the entry when MyFitnessPal does not answer', (
    tester,
  ) async {
    final backends = _backends()..mfpWritesFail = true;
    await pumpFujin(tester, backends);
    await _openAdd(tester);
    await _openOats(tester);

    await _tap(tester, _addToBoth);
    _sees('MyFitnessPal n’a pas répondu');
    _sees('Pas envoyé');
    check(backends.ekkloItems).isEmpty();

    await _tap(tester, 'Modifier la saisie');
    _sees(_addToBoth);
    _sees(_oatsName);
  });

  testWidgets('keeps the MyFitnessPal entry when Ekklo fails, and undoes it '
      'on request', (tester) async {
    final backends = _backends();
    backends.failingMeals.add(petitDejeuner);
    await pumpFujin(tester, backends);
    await _openAdd(tester);
    await _openOats(tester);

    await _tap(tester, _addToBoth);
    _sees('Ekklo n’a pas répondu');
    _sees('Non écrit');
    check(backends.entries).length.equals(1);

    await _tap(tester, "Annuler l'entrée MFP");
    check(backends.entries).isEmpty();
    _sees(_addToBoth);
  });

  testWidgets('retries Ekklo without writing MyFitnessPal twice', (
    tester,
  ) async {
    final backends = _backends();
    backends.failingMeals.add(petitDejeuner);
    await pumpFujin(tester, backends);
    final result = await _openAdd(tester);
    await _openOats(tester);
    await _tap(tester, _addToBoth);

    backends.failingMeals.clear();
    await _tap(tester, 'Réessayer Ekklo');

    check(
      await result,
    ).isNotNull().has((added) => added.ekkloWritten, 'ekklo').isTrue();
    check(backends.entries).length.equals(1);
    check(backends.ekkloItems).length.equals(1);
  });

  testWidgets('lists a food added through Fūjin among the recents', (
    tester,
  ) async {
    final backends = _backends();
    await pumpFujin(tester, backends);
    final first = await _openAdd(tester);
    await _openOats(tester);
    await _tap(tester, _addToBoth);
    await first;

    await _openAdd(tester);
    _sees('RÉCENTS');
    await _tap(tester, _oatsName);
    _sees('Ajouter à Breakfast');
  });

  testWidgets('proposes an own copy for a food Ekklo does not know', (
    tester,
  ) async {
    final unknown = mfpFood(
      skyr,
      description: 'Skyr nature',
      nutrients: nutrients(kcal: 60, protein: 10, carbs: 4, fat: 0.2),
    );
    final backends = FakeBackends(
      mealNames: [breakfast],
      mfpFoods: [unknown],
      mfpSearches: {
        'skyr': [unknown],
      },
    );
    await pumpFujin(tester, backends);
    await _openAdd(tester);
    await _search(tester, 'skyr');
    await _tap(tester, 'Skyr nature');

    _sees('Ekklo : sera créé depuis MFP');
  });

  testWidgets('looks up a typed barcode', (tester) async {
    final backends = _backends()..mfpBarcodes = {_barcode: _oats};
    await pumpFujin(tester, backends);
    await _openAdd(tester);

    await _search(tester, _barcode);
    _sees('Code-barres · EAN-13');
    await _tap(tester, 'Chercher ce code-barres');

    _sees('EAN $_barcode');
    _sees(_oatsName);
  });

  testWidgets('suggests a shorter search when nothing matches', (
    tester,
  ) async {
    final backends = _backends();
    await pumpFujin(tester, backends);
    await _openAdd(tester);

    await _search(tester, '$_query sans gluten');
    _sees('Aucun résultat');
    await _tap(tester, 'Raccourcir : « $_query sans »');
    await _tap(tester, 'Raccourcir : « $_query »');
    _sees(_oatsName);
  });

  testWidgets('keeps the recents on screen when offline', (tester) async {
    final backends = _backends();
    await pumpFujin(tester, backends);
    await _openAdd(tester);
    backends.mfpReachable = false;

    await _search(tester, _query);
    _sees('Pas de connexion');
    _sees('RÉCENTS');
  });

  testWidgets('lists the remembered foods under the recents, without the '
      'foods already recent (A02a)', (tester) async {
    final backends = _backends();
    await pumpFujin(tester, backends, ownCopies: [_skyrInPotsCopy]);
    final first = await _openAdd(tester);
    await _openOats(tester);
    await _tap(tester, _addToBoth);
    await first;

    await _openAdd(tester);

    _sees('MÉMORISÉS');
    _sees('liés à Ekklo');
    _sees('Fūjin les envoie vers Ekklo sans rien te demander.');
    _sees('→ $riceInEkklo');
    _sees('→ Aliment perso · « $pot »');
    check(find.text(oats).evaluate()).isEmpty();
    check(
      tester.getTopLeft(find.text('RÉCENTS')).dy,
    ).isLessThan(tester.getTopLeft(find.text('MÉMORISÉS')).dy);
  });

  testWidgets('lists the remembered foods matching the search at once, above '
      'the MyFitnessPal results that drop them (A02b)', (tester) async {
    final others = [
      for (var index = 1; index < MfpFoods.defaultMaxResults; index++)
        mfpFood('$skyr-$index', description: 'Skyr $index'),
    ];
    final backends = _skyrBackends(_skyrInPots)
      ..mfpSearches = {
        'skyr': [_skyrInPots, ...others],
      };
    await pumpFujin(tester, backends, ownCopies: [_skyrInPotsCopy]);
    await _openAdd(tester);

    await tester.enterText(find.byType(TextField).first, 'skyr');
    await tester.pump();
    _sees('1 trouvé');
    _sees('recherche…');

    await tester.pump(AddSearchNotifier.typingPause);
    await tester.pumpAndSettle();
    _sees(_skyrName);
    _sees('25 premiers');
    check(find.text(rice).evaluate()).isEmpty();
    check(
      tester.getTopLeft(find.text('MÉMORISÉS')).dy,
    ).isLessThan(tester.getTopLeft(find.text('RÉSULTATS MYFITNESSPAL')).dy);
  });

  testWidgets('counts the MyFitnessPal rows left beside the remembered foods '
      'when MyFitnessPal returned less than a page (A02b)', (tester) async {
    final backends = _skyrBackends(_skyrInPots)
      ..mfpSearches = {
        'skyr': [_skyrInPots, ..._otherSkyrs],
      };
    await pumpFujin(tester, backends, ownCopies: [_skyrInPotsCopy]);
    await _openAdd(tester);

    await _search(tester, 'skyr');

    _sees('2 résultats');
    _sees(_skyrName);
    _otherSkyrNames.forEach(_sees);
  });

  testWidgets('comes back from a remembered food to the results it left '
      '(A02b)', (tester) async {
    final backends = _skyrBackends(_skyrInPots)
      ..mfpSearches = {
        'skyr': [_skyrInPots, ..._otherSkyrs],
      };
    await pumpFujin(tester, backends, ownCopies: [_skyrInPotsCopy]);
    await _openAdd(tester);
    await _search(tester, 'skyr');

    await _tap(tester, _skyrName);
    _sees(_addToBoth);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    _sees('1 trouvé');
    _sees('2 résultats');
    _otherSkyrNames.forEach(_sees);
    check(find.text(rice).evaluate()).isEmpty();
  });

  testWidgets('opens a remembered food touched while MyFitnessPal is still '
      'searching', (tester) async {
    final searching = Completer<void>();
    final reading = Completer<void>();
    final backends = _skyrBackends(_skyrInPots)
      ..mfpSearchGate = searching
      ..mfpFoodGate = reading;
    await pumpFujin(tester, backends, ownCopies: [_skyrInPotsCopy]);
    await _openAdd(tester);
    await tester.enterText(find.byType(TextField).first, 'skyr');
    await tester.pump(AddSearchNotifier.typingPause);

    await tester.tap(find.text(_skyrName));
    await tester.pump();
    searching.complete();
    await tester.pump();
    reading.complete();
    await tester.pumpAndSettle();

    _sees(_addToBoth);
  });

  testWidgets('opens a remembered food in its remembered unit', (
    tester,
  ) async {
    final basmati = mfpFood(
      rice,
      description: 'Riz basmati',
      servingSizes: const [
        MfpServingSize(value: 100, unit: grams, nutritionMultiplier: 1),
        MfpServingSize(value: 1, unit: cup, nutritionMultiplier: 1.8),
      ],
      nutrients: nutrients(kcal: 350),
    );
    final backends = _backends(stored: [basmati]);
    await pumpFujin(tester, backends, units: memory.units);
    final result = await _openAdd(tester);

    await _tap(tester, rice);
    _sees('Ajouter à Breakfast');
    await _tap(tester, _addToBoth);

    check(await result).isNotNull();
    check(
      backends.entries.single,
    ).has((entry) => entry.servingSize.unit, 'unit').equals(cup);
  });

  testWidgets('keeps the remembered foods on screen when offline', (
    tester,
  ) async {
    final backends = _backends();
    await pumpFujin(tester, backends);
    await _openAdd(tester);
    backends.mfpReachable = false;

    await _search(tester, 'rice');
    _sees('Pas de connexion');
    _sees('MÉMORISÉS');
    _sees(rice);
  });

  testWidgets('keeps the Ekklo choice when the meal changes', (tester) async {
    await pumpFujin(tester, _skyrBackends(_skyrInPots));
    await _openAdd(tester);
    await _openSkyr(tester);
    await _chooseIseyWeighing(tester, '150');
    _seesPart(_chosenPot);

    await _tap(tester, breakfast);
    await _tap(tester, lunch);

    _sees('Ajouter à $lunch');
    _seesPart(_chosenPot);
  });

  testWidgets('asks to choose the Ekklo food before adding', (tester) async {
    final backends = _skyrBackends(_skyrInPots);
    await pumpFujin(tester, backends);
    await _openAdd(tester);
    await _openSkyr(tester);
    _sees('Ekklo : à choisir');
    check(find.text(_addToBoth).evaluate()).isEmpty();

    await _chooseIseyWeighing(tester, '150');

    _seesPart(_chosenPot);
    _sees(_addToBoth);
    check(backends.entries).isEmpty();
  });

  testWidgets('rescales the Ekklo grams without a second Ekklo search when '
      'the servings change', (tester) async {
    final backends = _skyrBackends(_skyrInPots);
    await pumpFujin(tester, backends);
    await _openAdd(tester);
    await _openSkyr(tester);
    await _chooseIseyWeighing(tester, '150');
    final searches = _ekkloSearches(backends).length;

    await tester.enterText(find.widgetWithText(TextField, 'Autre'), '1,5');
    await tester.pumpAndSettle();

    check(_ekkloSearches(backends)).length.equals(searches);
    _seesPart('225');
    _seesPart(_chosenPot);
  });

  testWidgets('says how much the day will exceed its goal', (tester) async {
    await pumpFujin(
      tester,
      _backends(),
      goals: const Goals(kilocalories: 300),
    );
    await _openAdd(tester);
    await _openOats(tester);

    _sees('Dépassera de 70 kcal');
  });

  testWidgets('reconnects Ekklo from the fiche when its session expired', (
    tester,
  ) async {
    final backends = _skyrBackends(_skyrInGrams);
    final store = await backends.ekkloTokenStore();
    await pumpFujin(tester, backends, ekklo: backends.ekkloWith(store));
    await _openAdd(tester);
    await store.write(FakeBackends.staleEkkloTokens);
    await _openSkyr(tester);
    _sees('Ta session Ekklo a expiré.');

    await _signInToEkklo(tester);

    _seesPart('trouvé automatiquement');
    _sees(_addToBoth);
    check(backends.entries).isEmpty();
  });

  testWidgets('re-runs the add after reconnecting MyFitnessPal', (
    tester,
  ) async {
    final backends = _backends();
    final store = InMemoryMfpSessionStore();
    await store.write(FakeBackends.mfpSession);
    await pumpFujin(tester, backends, mfp: backends.mfpWith(store));
    final result = await _openAdd(tester);
    await _openOats(tester);
    await store.write(FakeBackends.refusedMfpSession);

    await _tap(tester, _addToBoth);
    _sees('Session MyFitnessPal expirée');
    check(backends.entries).isEmpty();

    await _signInToMfp(tester, store);

    check(await result).isNotNull();
    check(backends.entries).length.equals(1);
  });

  testWidgets('retries Ekklo after reconnecting it once MyFitnessPal has the '
      'entry', (tester) async {
    final backends = _backends();
    final store = await backends.ekkloTokenStore();
    await pumpFujin(tester, backends, ekklo: backends.ekkloWith(store));
    final result = await _openAdd(tester);
    await _openOats(tester);
    final gate = Completer<void>();
    backends.diaryGate = gate;

    final button = find.text(_addToBoth);
    await tester.ensureVisible(button);
    await tester.pumpAndSettle();
    await tester.tap(button);
    await tester.pump();
    await store.write(FakeBackends.staleEkkloTokens);
    gate.complete();
    await tester.pumpAndSettle();
    _sees('Session Ekklo expirée');
    check(find.text('Réessayer Ekklo').evaluate()).isEmpty();

    await _signInToEkklo(tester);

    check(
      await result,
    ).isNotNull().has((added) => added.ekkloWritten, 'ekklo').isTrue();
    check(backends.entries).length.equals(1);
    check(backends.ekkloItems).length.equals(1);
  });

  testWidgets('does not blame MyFitnessPal when Ekklo cannot be read before '
      'the write', (tester) async {
    final backends = _backends();
    await pumpFujin(tester, backends);
    await _openAdd(tester);
    await _openOats(tester);
    backends.ekkloReachable = false;

    await _tap(tester, _addToBoth);

    _sees('Pas de connexion internet.');
    check(find.text('MyFitnessPal n’a pas répondu').evaluate()).isEmpty();
    check(find.text('Non écrit').evaluate()).isEmpty();
    check(backends.entries).isEmpty();
  });

  testWidgets('names the side that kept an undo from finishing', (
    tester,
  ) async {
    final backends = _backends();
    backends.failingMeals.add(petitDejeuner);
    await pumpFujin(tester, backends);
    await _openAdd(tester);
    await _openOats(tester);
    await _tap(tester, _addToBoth);
    backends.ekkloReachable = false;

    await _tap(tester, "Annuler l'entrée MFP");

    _sees('Pas de connexion internet.');
    check(find.text('MyFitnessPal ne répond pas.').evaluate()).isEmpty();
  });

  testWidgets('shows the status code when MyFitnessPal answers a server '
      'error', (tester) async {
    final backends = _backends()..mfpSearchStatus = 503;
    await pumpFujin(tester, backends);
    await _openAdd(tester);

    await _search(tester, _query);

    _sees('MyFitnessPal ne répond pas');
    _sees('Code 503 · pour le support');
  });

  testWidgets('retries a failed barcode lookup as a barcode', (tester) async {
    final backends = _backends()..mfpBarcodes = {_barcode: _oats};
    await pumpFujin(tester, backends);
    await _openAdd(tester);
    await _search(tester, _barcode);
    backends.mfpReachable = false;
    await _tap(tester, 'Chercher ce code-barres');
    _sees('Pas de connexion');

    backends.mfpReachable = true;
    await _tap(tester, 'Réessayer');

    _sees('EAN $_barcode');
  });

  testWidgets('lists a food recorded by an add when coming back to search', (
    tester,
  ) async {
    final backends = _backends();
    backends.failingMeals.add(petitDejeuner);
    await pumpFujin(tester, backends);
    await _openAdd(tester);
    await _openOats(tester);
    await _tap(tester, _addToBoth);
    await _tap(tester, "Annuler l'entrée MFP");

    await tester.tap(find.byTooltip('Retour'));
    await tester.pumpAndSettle();
    await _search(tester, '');

    _sees('RÉCENTS');
    _seesPart('ce soir');
  });

  testWidgets('releases the search field when the fiche opens', (
    tester,
  ) async {
    await pumpFujin(tester, _backends());
    await _openAdd(tester);
    await tester.showKeyboard(find.byType(TextField).first);

    await _openOats(tester);

    check(tester.testTextInput.isVisible).isFalse();
  });

  testWidgets('says a scanned food has no serving size instead of doing '
      'nothing', (tester) async {
    final bare = mfpFood(oats, description: _oatsName, servingSizes: const []);
    final backends = _backends(stored: [bare])..mfpBarcodes = {_barcode: bare};
    await pumpFujin(tester, backends);
    await _openAdd(tester);

    await _search(tester, _barcode);
    await _tap(tester, 'Chercher ce code-barres');

    _sees('Produit reconnu, sans fiche');
  });

  testWidgets('drafts the serving and the meal chosen in their menus', (
    tester,
  ) async {
    final twoServings = mfpFood(
      oats,
      description: _oatsName,
      servingSizes: const [
        MfpServingSize(value: 100, unit: grams, nutritionMultiplier: 1),
        MfpServingSize(value: 40, unit: grams, nutritionMultiplier: 0.4),
      ],
    );
    final backends = _backends(stored: [twoServings])
      ..mfpSearches = {
        _query: [twoServings],
      };
    await pumpFujin(tester, backends);
    await _openAdd(tester);
    await _openOats(tester);

    await _tap(tester, '100 g');
    await _tap(tester, '40 g');
    await _tap(tester, breakfast);
    await _tap(tester, lunch);
    await _tap(tester, _addToBoth);

    check(backends.entries).length.equals(1);
    check(backends.entries.single)
      ..has((entry) => entry.mealName, 'meal').equals(lunch)
      ..has((entry) => entry.servingSize.value, 'serving').equals(40);
  });

  testWidgets('closes the open meal menu on back and stays on the fiche', (
    tester,
  ) async {
    await pumpFujin(tester, _backends());
    await _openAdd(tester);
    await _openOats(tester);
    await _tap(tester, breakfast);
    _sees(lunch);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    check(find.text(lunch).evaluate()).isEmpty();
    _sees('Ajouter à $breakfast');
    _sees(_addToBoth);
  });

  testWidgets('adds to the day tapped in the day picker', (tester) async {
    final backends = _backends();
    await pumpFujin(tester, backends);
    await _openAdd(tester);
    await _openOats(tester);

    await _openDayPicker(tester);
    await tester.tap(_dayInPicker('6'));
    await tester.pumpAndSettle();
    check(find.byType(DayPickerSheet).evaluate()).isEmpty();
    await _tap(tester, _addToBoth);

    check(
      backends.entries.single,
    ).has((entry) => entry.date, 'date').equals(DateTime.utc(2026, 10, 6));
  });

  testWidgets('greys out the days more than a year away and ignores them', (
    tester,
  ) async {
    await pumpFujin(tester, _backends());
    await _openAdd(tester);
    await _openOats(tester);
    await _openDayPicker(tester);

    for (var month = 0; month < 12; month++) {
      await tester.tap(find.byTooltip('Mois précédent'));
      await tester.pumpAndSettle();
    }
    _sees('Octobre 2025');
    check(
      _dayColor(tester, '6'),
    ).equals(FujinColorRole.textDisabled);
    check(_dayColor(tester, '7')).equals(FujinColorRole.textPrimary);

    await tester.tap(_dayInPicker('6'));
    await tester.pumpAndSettle();

    check(find.byType(DayPickerSheet).evaluate()).length.equals(1);
  });
}

Future<void> _openDayPicker(WidgetTester tester) async {
  final pill = find.byIcon(Icons.calendar_today_outlined);
  await tester.ensureVisible(pill);
  await tester.pumpAndSettle();
  await tester.tap(pill);
  await tester.pumpAndSettle();
}

Finder _dayInPicker(String date) =>
    find.descendant(of: find.byType(DayPickerSheet), matching: find.text(date));

Color? _dayColor(WidgetTester tester, String date) =>
    tester.widget<Text>(_dayInPicker(date)).style?.color;
