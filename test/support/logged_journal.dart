import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart'
    show WidgetTester, addTearDown, find;
import 'package:fujin/app/app_environment.dart';
import 'package:fujin/data/links/sent_link.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

import 'fake_backends.dart';
import 'fixtures.dart';
import 'pump_fujin.dart';

abstract final class LoggedJournal {
  static const basmatiId = 'e-basmati';
  static const oatsId = 'e-oats';
  static const skyrId = 'e-skyr';
  static const basmatiItem = 'i-basmati';
  static const lunchMeal = 'm-lunch';
  static const basmati = 'Riz basmati';
  static const oatFlakes = 'Flocons d’avoine';
  static const skyrNature = 'Skyr nature';

  static final MfpFood basmatiFood = mfpFood(rice, description: basmati);
  static final MfpFood skyrFood = mfpFood(skyr, description: skyrNature);
  static const _pull = Offset(0, 400);
  static const _pullSpeed = 1000.0;
  static const _scrollStep = 200.0;

  static FakeBackends backends({List<MfpFood>? foods}) => FakeBackends(
    mealNames: [breakfast, lunch],
    mfpFoods: foods ?? [basmatiFood, skyrFood],
    entries: [
      entry(oatsId, description: oatFlakes, version: '1'),
      entry(
        basmatiId,
        food: rice,
        meal: lunch,
        servings: 1.5,
        description: basmati,
        version: '1',
      ),
      entry(
        skyrId,
        food: skyr,
        meal: lunch,
        description: skyrNature,
        version: '1',
      ),
    ],
    ekkloMeals: [
      meal(lunchMeal, [
        item(basmatiItem, food: riceInEkklo, quantity: 150),
      ], name: dejeuner),
    ],
  );

  static SentLink basmatiLink({
    String entryId = basmatiId,
    double servings = 1.5,
  }) => link(
    entryId,
    basmatiItem,
    food: rice,
    meal: lunch,
    ekkloMeal: lunchMeal,
    servings: servings,
  );

  static Future<void> pump(
    WidgetTester tester,
    FakeBackends backends, {
    SentLink? linked,
    AppEnvironment environment = AppEnvironment.production,
    MyFitnessPalClient? mfp,
    EkkloClient? ekklo,
  }) async {
    addTearDown(tester.view.reset);
    tester.view
      ..physicalSize = const Size(800, 1800)
      ..devicePixelRatio = 1;
    await pumpFujin(
      tester,
      backends,
      mfp: mfp,
      ekklo: ekklo,
      environment: environment,
      links: [linked ?? basmatiLink()],
    );
  }

  static Future<void> goOffline(
    WidgetTester tester,
    FakeBackends backends, {
    required String showing,
  }) async {
    tester.view.reset();
    await tester.pumpAndSettle();
    backends
      ..mfpReachable = false
      ..ekkloReachable = false;
    await tester.fling(find.byType(CustomScrollView), _pull, _pullSpeed);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text(showing),
      _scrollStep,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
  }
}
