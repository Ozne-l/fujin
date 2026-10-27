import 'package:flutter_test/flutter_test.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/fujin_switch.dart';
import 'package:fujin/pages/tabs/tab_plate.dart';
import 'package:integration_test/integration_test.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

import '../test/support/fake_backends.dart';
import '../test/support/fixtures.dart';
import '../test/support/pump_fujin.dart';

enum _Scenario { tabSwitch, sendReview, journalScroll, settingsSwitch }

const _rounds = 3;
const _entriesPerMeal = 6;
const _journal = 'Journal';
const _settings = 'Réglages';
const _slide = Duration(milliseconds: 600);
const _flingDistance = 1200.0;
const _flingSpeed = 2400.0;

final List<MfpFoodEntry> _day = [
  for (var index = 0; index < _entriesPerMeal; index++) ...[
    entry('B-$index'),
    entry('L-$index', food: rice, meal: lunch, unit: cup),
    entry(
      'S-$index',
      food: skyr,
      description: 'Skyr nature',
      brand: 'Isey',
      meal: snacks,
      servingValue: 250,
      nutrients: nutrients(kcal: 160, protein: 25, carbs: 10, fat: 0.5),
    ),
  ],
];

FakeBackends _backends() => FakeBackends(
  mealNames: [breakfast, lunch, snacks],
  entries: _day,
  ekkloSearches: {
    'skyr': [isey, siggis],
  },
);

Finder _tab(String label) => find.descendant(
  of: find.byType(TabPlate),
  matching: find.text(label),
);

Offset _screenCentre(WidgetTester tester) =>
    (tester.view.physicalSize / tester.view.devicePixelRatio).center(
      Offset.zero,
    );

Future<void> _slideTab(WidgetTester tester, String from, String to) async {
  final start = tester.getCenter(_tab(from));
  await tester.timedDragFrom(start, tester.getCenter(_tab(to)) - start, _slide);
  await tester.pumpAndSettle();
}

Future<void> _flingDownAndUp(WidgetTester tester) async {
  final centre = _screenCentre(tester);
  await tester.flingFrom(centre, const Offset(0, -_flingDistance), _flingSpeed);
  await tester.pumpAndSettle();
  await tester.flingFrom(centre, const Offset(0, _flingDistance), _flingSpeed);
  await tester.pumpAndSettle();
}

Future<void> _openSettings(WidgetTester tester) async {
  await tester.tap(_tab(_settings));
  await tester.pumpAndSettle();
  await tester.ensureVisible(find.byType(FujinSwitch));
  await tester.pumpAndSettle();
}

Future<void> _toggleSwitch(WidgetTester tester) async {
  final centre = tester.getCenter(find.byType(FujinSwitch));
  for (final direction in const [1, -1]) {
    await tester.timedDragFrom(
      centre,
      Offset(direction * FujinSize.switchWidth, 0),
      _slide,
    );
    await tester.pumpAndSettle();
  }
}

Future<void> _reviewAndBack(WidgetTester tester) async {
  await tester.tap(find.text('Envoyer ${_day.length} aliments vers Ekklo'));
  await tester.pumpAndSettle();
  await _flingDownAndUp(tester);
  await tester.binding.handlePopRoute();
  await tester.pumpAndSettle();
}

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
    ..framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.benchmarkLive;

  Future<void> measure(
    _Scenario scenario,
    Future<void> Function() round,
  ) async {
    await round();
    await binding.traceAction(() async {
      for (var index = 0; index < _rounds; index++) {
        await round();
      }
    }, reportKey: scenario.name);
  }

  testWidgets('switches tabs with the lens over the tab plate', (tester) async {
    await pumpFujin(tester, _backends());
    await measure(_Scenario.tabSwitch, () async {
      await _slideTab(tester, _journal, _settings);
      await _slideTab(tester, _settings, _journal);
    });
  });

  testWidgets('opens and scrolls the send review', (tester) async {
    await pumpFujin(tester, _backends());
    await measure(_Scenario.sendReview, () => _reviewAndBack(tester));
  });

  testWidgets('scrolls the journal under its blurred header', (tester) async {
    await pumpFujin(tester, _backends());
    await measure(_Scenario.journalScroll, () => _flingDownAndUp(tester));
  });

  testWidgets('slides a settings switch on and off', (tester) async {
    await pumpFujin(tester, _backends());
    await _openSettings(tester);
    await measure(_Scenario.settingsSwitch, () => _toggleSwitch(tester));
  });
}
