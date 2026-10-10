import 'dart:convert';

import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fujin/data/backup/backup.dart';
import 'package:fujin/data/backup/backup_codec.dart';
import 'package:fujin/data/goals/goals.dart';

import '../support/fake_backends.dart';
import '../support/fake_backup_files.dart';
import '../support/fixtures.dart';
import '../support/pump_fujin.dart';

const _space = '\u202f';

Future<void> _tap(WidgetTester tester, String text) async {
  final target = find.text(text).last;
  await tester.ensureVisible(target);
  await tester.pumpAndSettle();
  await tester.tap(target);
  await tester.pumpAndSettle();
}

int _count(String text) => find.text(text).evaluate().length;

Future<void> _fill(WidgetTester tester, List<String> values) async {
  for (final (index, value) in values.indexed) {
    await tester.enterText(find.byType(TextField).at(index), value);
  }
  await tester.pumpAndSettle();
}

FakeBackends _diary() => FakeBackends(
  mealNames: [breakfast],
  entries: [
    entry('E-1'),
    entry('E-2', food: rice),
  ],
  ekkloMeals: [
    meal('meal-1', [item('I-1')]),
  ],
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

  testWidgets('opens on the Réglages tab with both sessions, what Memory '
      'holds and the app version', (tester) async {
    await pumpFujin(tester, FakeBackends(mealNames: [breakfast]));
    await _tap(tester, 'Réglages');

    check(_count('Connecté · session active')).equals(2);
    check(_count('Aucun objectif')).equals(1);
    check(_count('2 aliments et 2 repas')).equals(1);
    check(_count('Fūjin · $appVersion')).equals(1);
  });

  testWidgets('saves the goals and sums them up in the OBJECTIFS card', (
    tester,
  ) async {
    await pumpFujin(tester, FakeBackends(mealNames: [breakfast]));
    await _tap(tester, 'Réglages');
    await _tap(tester, 'Tous les jours');

    await _fill(tester, ['3000', '160', '', '70', '']);
    check(_count('P et L font 1${_space}270 kcal.')).equals(1);
    check(
      _count('Glucides sans objectif : pas de comparaison.'),
    ).equals(1);

    await _fill(tester, ['3000', '160', '400', '70', '40']);
    check(_count('Tes macros font 2${_space}870 kcal.')).equals(1);
    check(
      _count('Pour un objectif de 3${_space}000 kcal. À titre indicatif.'),
    ).equals(1);

    await _tap(tester, 'Enregistrer');
    check(_count('✓ Objectifs enregistrés')).equals(1);
    check(_count('Enregistré')).equals(1);

    await tester.tap(find.byIcon(Icons.chevron_left));
    await tester.pumpAndSettle();
    check(
      _count('3${_space}000 kcal · P 160 · G 400 · L 70 · F 40'),
    ).equals(1);
  });

  testWidgets('clears the memory but keeps the sent links, so the Journal '
      'still shows what is in Ekklo', (tester) async {
    await pumpFujin(tester, _diary(), links: [link('E-1', 'I-1')]);
    check(_count('1/2 dans Ekklo')).equals(1);

    await _tap(tester, 'Réglages');
    await _tap(tester, 'Effacer la mémoire');
    check(_count('Effacer la mémoire ?')).equals(1);
    await _tap(tester, 'Effacer la mémoire');

    check(_count('0 aliment et 0 repas')).equals(1);
    await _tap(tester, 'Mémoire');
    check(_count('Aucun aliment mémorisé')).equals(1);
    await _tap(tester, 'Journal');
    check(_count('1/2 dans Ekklo')).equals(1);
  });

  testWidgets('signs out of MyFitnessPal, forgets the web view cookies and '
      'lands on the welcome screen', (tester) async {
    final backends = FakeBackends(mealNames: [breakfast]);
    final mfp = await backends.mfp();
    var cookiesCleared = false;
    await pumpFujin(
      tester,
      backends,
      mfp: mfp,
      clearWebCookies: () async => cookiesCleared = true,
    );

    await _tap(tester, 'Réglages');
    await tester.tap(find.text('Déconnecter').first);
    await tester.pumpAndSettle();
    check(_count('Te déconnecter de MyFitnessPal ?')).equals(1);
    await _tap(tester, 'Déconnecter');

    check(await mfp.isSignedIn).isFalse();
    check(cookiesCleared).isTrue();
    check(_count('Note une fois,\nton coach voit tout.')).equals(1);
  });

  testWidgets('exports a backup file named after the day', (tester) async {
    final files = FakeBackupFiles();
    await pumpFujin(
      tester,
      FakeBackends(mealNames: [breakfast]),
      backupFiles: files,
    );

    await _tap(tester, 'Réglages');
    await _tap(tester, 'Exporter une sauvegarde');

    check(files.saved.keys).deepEquals(['fujin-backup-2026-10-07.json']);
    check(_count('Sauvegarde exportée')).equals(1);
  });

  testWidgets('shows the date and counts of a backup before replacing '
      'everything with it', (tester) async {
    final files = FakeBackupFiles()
      ..picked = BackupCodec.encode(
        Backup(
          exportedAt: DateTime(day.year, day.month, day.day, 12),
          matches: [memory.matches.first],
          ownCopies: const [],
          units: const [],
          meals: [memory.meals.first],
          links: [link('E-1', 'I-1')],
          goals: const Goals(kilocalories: 2500),
        ),
      );
    await pumpFujin(
      tester,
      FakeBackends(mealNames: [breakfast]),
      backupFiles: files,
    );

    await _tap(tester, 'Réglages');
    await _tap(tester, 'Importer une sauvegarde');
    check(_count('Importer cette sauvegarde ?')).equals(1);
    check(
      _count(
        'Sauvegarde du 7 octobre 2026 : 1 aliment, 1 repas et 1 lien '
        'd’envoi. Elle remplace la mémoire de ce téléphone.',
      ),
    ).equals(1);
    check(_count('2 aliments et 2 repas')).equals(1);

    await _tap(tester, 'Importer et remplacer');

    check(_count('Sauvegarde importée')).equals(1);
    check(_count('1 aliment et 1 repas')).equals(1);
    check(_count('2${_space}500 kcal')).equals(1);
  });

  testWidgets('refuses an unreadable file and changes nothing', (
    tester,
  ) async {
    final files = FakeBackupFiles()..picked = utf8.encode('{"format": "x"}');
    await pumpFujin(
      tester,
      FakeBackends(mealNames: [breakfast]),
      backupFiles: files,
    );

    await _tap(tester, 'Réglages');
    await _tap(tester, 'Importer une sauvegarde');

    check(_count("Fichier illisible, rien n'a changé")).equals(1);
    check(_count('Importer cette sauvegarde ?')).equals(0);
    check(_count('2 aliments et 2 repas')).equals(1);
  });
}
