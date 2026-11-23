import 'package:checks/checks.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart' hide expect;
import 'package:fujin/app/app_environment.dart';
import 'package:fujin/data/connectors/connector.dart';
import 'package:fujin/pages/common/code_keypad.dart';
import 'package:fujin/pages/common/connector_pill.dart';

import '../support/fake_backends.dart';
import '../support/fixtures.dart';
import '../support/in_memory_preferences.dart';
import '../support/pump_fujin.dart';

const _today = 'Aujourd’hui, mer. 7 oct.';
const _mfpNotWritten = 'Pas écrit dans MyFitnessPal';
const _range = 'Entre 20 et 300 kg';

Future<void> _frames(WidgetTester tester) async {
  for (var frame = 0; frame < 10; frame++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

Future<void> _tap(WidgetTester tester, Finder target) async {
  await tester.ensureVisible(target);
  await _frames(tester);
  await tester.tap(target);
  await _frames(tester);
}

Future<void> _openWeighIns(WidgetTester tester) async {
  await _tap(tester, find.text('Réglages').last);
  await _tap(tester, find.text('Nouvelle pesée et historique'));
}

Future<void> _type(WidgetTester tester, String typed) async {
  for (final key in typed.characters) {
    await tester.tap(
      find.descendant(of: find.byType(CodeKeypad), matching: find.text(key)),
    );
    await tester.pump();
  }
}

Future<void> _erase(WidgetTester tester, int times) async {
  for (var press = 0; press < times; press++) {
    await tester.tap(find.byIcon(Icons.backspace_outlined));
    await tester.pump();
  }
}

Future<void> _save(WidgetTester tester, String typed) async {
  await _tap(tester, find.text('Nouvelle pesée').last);
  await _type(tester, typed);
  await _tap(tester, find.text('Enregistrer'));
}

bool _enabled(WidgetTester tester, String label) =>
    tester
        .widget<FilledButton>(
          find.ancestor(
            of: find.text(label),
            matching: find.byType(FilledButton),
          ),
        )
        .onPressed !=
    null;

Finder _pill(Connector connector) => find.byWidgetPredicate(
  (widget) => widget is ConnectorPill && widget.connector == connector,
);

Finder _turning(Connector connector) =>
    find.descendant(of: _pill(connector), matching: find.byType(Transform));

int _count(String text) => find.text(text).evaluate().length;

Finder get _retry => find.descendant(
  of: find.byType(SnackBar),
  matching: find.text('Réessayer'),
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

  testWidgets('saves a weigh-in typed with a comma, writes it to both apps '
      'and gives it on the Réglages card', (tester) async {
    final backends = FakeBackends();
    await pumpFujin(tester, backends);
    await _tap(tester, find.text('Réglages').last);
    check(_count('Pas encore de pesée aujourd’hui')).equals(1);
    await _tap(tester, find.text('Nouvelle pesée et historique'));
    check(_count('Pas encore de pesée')).equals(1);

    await _save(tester, '68,9');

    check(_count('Pesée enregistrée')).equals(1);
    check(_count('68,9 kg · aujourd’hui')).equals(1);
    check(_count('Annuler')).equals(0);
    check([
      for (final measurement in backends.mfpMeasurements) measurement.value,
    ]).deepEquals([68.9]);
    check([
      for (final weight in backends.ekkloWeights) weight.kilograms,
    ]).deepEquals([68.9]);
    check(_count(_today)).equals(1);
    check(_count('68,9 kg')).equals(1);
    check(find.byType(ConnectorPill).evaluate()).isEmpty();

    await _tap(tester, find.byIcon(Icons.chevron_left));

    check(_count('Aujourd’hui · 68,9 kg')).equals(1);
  });

  testWidgets('accepts 20 to 300 kg only, and waits for more digits before '
      'saying so', (tester) async {
    await pumpFujin(tester, FakeBackends());
    await _openWeighIns(tester);
    await _tap(tester, find.text('Nouvelle pesée').last);

    await _type(tester, '1');
    check(_count(_range)).equals(0);
    check(_enabled(tester, 'Enregistrer')).isFalse();

    await _type(tester, ',');
    check(_count(_range)).equals(1);
    check(_enabled(tester, 'Enregistrer')).isFalse();

    await _erase(tester, 2);
    await _type(tester, '301');
    check(_count(_range)).equals(1);
    check(_enabled(tester, 'Enregistrer')).isFalse();

    await _erase(tester, 1);
    await _type(tester, '0');
    check(_count('300')).equals(1);
    check(_count(_range)).equals(0);
    check(_enabled(tester, 'Enregistrer')).isTrue();

    await _type(tester, ',1');
    check(_count('300,1')).equals(1);
    check(_count(_range)).equals(1);
    check(_enabled(tester, 'Enregistrer')).isFalse();
  });

  testWidgets('replaces the weigh-in of a day that has one, in both '
      'apps', (tester) async {
    final backends = FakeBackends(
      ekkloWeights: [
        EkkloWeightEntry(
          id: 'w-1',
          date: day,
          kilograms: 69.2,
          createdAt: now,
          updatedAt: now,
        ),
      ],
    );
    await pumpFujin(
      tester,
      backends,
      preferences: await inMemoryPreferences(reached: const []),
    );
    await _frames(tester);
    await _openWeighIns(tester);
    check(_count('69,2 kg')).equals(1);

    await _tap(tester, find.text('Nouvelle pesée').last);
    check(_count('Ce jour a déjà une pesée : 69,2 kg.')).equals(1);
    await _type(tester, '68,7');
    await _tap(tester, find.text('Remplacer la pesée'));

    check(_count('68,7 kg')).equals(1);
    check(_count('69,2 kg')).equals(0);
    check([
      for (final measurement in backends.mfpMeasurements) measurement.value,
    ]).deepEquals([68.7]);
    check([
      for (final weight in backends.ekkloWeights) weight.kilograms,
    ]).deepEquals([68.7]);
  });

  testWidgets('keeps a deleted weigh-in greyed while MyFitnessPal still owes '
      'its deletion, with Réessayer, and lets it go once deleted', (
    tester,
  ) async {
    final backends = FakeBackends();
    await pumpFujin(tester, backends);
    await _openWeighIns(tester);
    await _save(tester, '68,9');
    backends.mfpMeasurementWritesFail = true;

    await _tap(tester, find.text(_today));
    check(_count('Modifier la pesée')).equals(1);
    check(_count('Mercredi 7 octobre')).equals(1);
    await _tap(tester, find.text('Supprimer la pesée'));
    check(_count('Supprimer 68,9 kg ?')).equals(1);
    await _tap(tester, find.text('Supprimer de MFP'));

    check(_count(_today)).equals(1);
    check(_count('Supprimé dans Fūjin · reste dans Ekklo')).equals(1);
    check(_pill(Connector.mfp).evaluate()).length.equals(1);
    check(_turning(Connector.mfp).evaluate()).isEmpty();
    check(_count(_mfpNotWritten)).equals(1);
    check(_count('La pesée d’aujourd’hui reste en attente')).equals(1);
    check(backends.mfpMeasurements).length.equals(1);
    check(backends.ekkloWeights).length.equals(1);

    backends.mfpMeasurementWritesFail = false;
    await _tap(tester, _retry);

    check(backends.mfpMeasurements).isEmpty();
    check(backends.ekkloWeights).length.equals(1);
    check(_count(_today)).equals(0);
    check(_count('Pas encore de pesée')).equals(1);
  });

  testWidgets('says the weigh-in was not written with the DEV sentence and '
      'no Réessayer in Fūjin DEV', (tester) async {
    final backends = FakeBackends();
    await pumpFujin(tester, backends, environment: AppEnvironment.dev);
    await _openWeighIns(tester);

    await _save(tester, '68,9');

    check(_count(_mfpNotWritten)).equals(1);
    check(
      _count(
        'Fūjin DEV n’écrit ni dans MyFitnessPal ni dans Ekklo : '
        'rien n’a changé.',
      ),
    ).equals(1);
    check(_retry.evaluate()).isEmpty();
    check(_pill(Connector.mfp).evaluate()).length.equals(1);
    check(_pill(Connector.ekklo).evaluate()).length.equals(1);
    check(_turning(Connector.mfp).evaluate()).isEmpty();
    check(_turning(Connector.ekklo).evaluate()).isEmpty();
    check(backends.mfpMeasurements).isEmpty();
    check(backends.ekkloWeights).isEmpty();
  });

  testWidgets('shows no failure offline and keeps both clocks '
      'turning', (tester) async {
    final backends = FakeBackends();
    await pumpFujin(tester, backends);
    await _openWeighIns(tester);
    backends
      ..mfpReachable = false
      ..ekkloReachable = false;

    await _save(tester, '68,9');

    check(_count('Pesée enregistrée')).equals(1);
    check(_count(_mfpNotWritten)).equals(0);
    check(_count('Pas écrit dans Ekklo')).equals(0);
    check(_turning(Connector.mfp).evaluate()).length.equals(1);
    check(_turning(Connector.ekklo).evaluate()).length.equals(1);
  });
}
