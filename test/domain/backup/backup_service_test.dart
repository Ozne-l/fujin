import 'dart:convert';
import 'dart:typed_data';

import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart'
    show addTearDown, group, setUp, tearDown, test;
import 'package:fujin/data/backup/backup.dart';
import 'package:fujin/data/backup/backup_repository.dart';
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/entries/entry_repository.dart';
import 'package:fujin/data/goals/goals.dart';
import 'package:fujin/data/goals/goals_repository.dart';
import 'package:fujin/data/links/sent_link_repository.dart';
import 'package:fujin/data/memory/barcode_link.dart';
import 'package:fujin/data/memory/meal_mapping.dart';
import 'package:fujin/data/memory/memory.dart';
import 'package:fujin/data/memory/memory_repository.dart';
import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/data/memory/remembered_unit.dart';
import 'package:fujin/data/recents/recent_food.dart';
import 'package:fujin/data/recents/recent_food_repository.dart';
import 'package:fujin/domain/backup/backup_service.dart';

import '../../support/fake_backends.dart';
import '../../support/fake_backup_files.dart';
import '../../support/fixtures.dart';
import '../../support/repositories.dart';

const _fileName = 'fujin-backup-2026-10-07.json';
const _skyrBarcode = '3033490004521';
const _barcodeLinks = 'barcode_links';
const _goals = Goals(kilocalories: 3000, protein: 160, fat: 70);
const _ownCopy = OwnCopy(
  mfpFoodId: skyr,
  mfpDescription: skyr,
  ekkloFoodId: 'own-skyr',
  ekkloFoodName: skyr,
  mfpUnit: pot,
  mfpFoodVersion: 'v1',
);
const _oatsInRecents = 'Flocons d’avoine complète';
final _recentOats = RecentFood(
  mfpFoodId: oats,
  description: _oatsInRecents,
  brandName: 'Quaker',
  servingValue: 40,
  servingUnit: grams,
  servings: 1,
  kilocalories: 150,
  addedAt: now,
);
final _recentOil = RecentFood(
  mfpFoodId: oil,
  description: oil,
  servingValue: 1,
  servingUnit: tablespoon,
  servings: 2,
  addedAt: now,
);

Map<String, Object?> _fileOfRelease040(int version) => {
  'format': Backup.formatName,
  'version': version,
  'exported_at': '2026-10-07T20:00:00.000Z',
  'matches': [
    {
      'kind': 'ekklo',
      'mfp_food_id': oats,
      'mfp_description': 'Flocons avoine',
      'ekklo_food_id': oatsInEkklo,
      'ekklo_food_name': 'Flocons d’avoine',
    },
    {
      'kind': 'ekklo',
      'mfp_food_id': rice,
      'mfp_description': 'Riz basmati',
      'ekklo_food_id': riceInEkklo,
      'ekklo_food_name': 'Riz basmati cuit',
    },
  ],
  'own_copies': [
    {
      'kind': 'own_copy',
      'mfp_food_id': skyr,
      'mfp_description': 'Skyr nature',
      'ekklo_food_id': 'own-skyr',
      'ekklo_food_name': 'Skyr nature',
      'mfp_unit': pot,
      'mfp_food_version': 'v1',
    },
  ],
  'units': [
    {'mfp_food_id': rice, 'mfp_unit': cup, 'grams': 180},
  ],
  'meals': [
    {'mfp_meal_name': lunch, 'ekklo_meal_name': dejeuner},
    {'mfp_meal_name': breakfast, 'ekklo_meal_name': petitDejeuner},
  ],
  'links': [link('E-1', 'I-1').toMap()],
  _barcodeLinks: [
    {'barcode': _skyrBarcode, 'mfp_food_id': skyr},
  ],
  'goals': {'kilocalories': 3000, 'protein': 160, 'fat': 70},
};

const _memoryOfRelease040 = Memory(
  matches: [
    MatchedFood(
      mfpFoodId: oats,
      mfpDescription: _oatsInRecents,
      ekkloFoodId: oatsInEkklo,
      ekkloFoodName: 'Flocons d’avoine',
    ),
    MatchedFood(
      mfpFoodId: rice,
      mfpDescription: 'Riz basmati',
      ekkloFoodId: riceInEkklo,
      ekkloFoodName: 'Riz basmati cuit',
    ),
  ],
  ownCopies: [
    OwnCopy(
      mfpFoodId: skyr,
      mfpDescription: 'Skyr nature',
      ekkloFoodId: 'own-skyr',
      ekkloFoodName: 'Skyr nature',
      mfpUnit: pot,
      mfpFoodVersion: 'v1',
    ),
  ],
  units: [RememberedUnit(mfpFoodId: rice, mfpUnit: cup, grams: 180)],
  meals: [
    MealMapping(mfpMealName: breakfast, ekkloMealName: petitDejeuner),
    MealMapping(mfpMealName: lunch, ekkloMealName: dejeuner),
  ],
  barcodeLinks: [BarcodeLink(barcode: _skyrBarcode, mfpFoodId: skyr)],
);

Uint8List _json(Object value) => utf8.encode(jsonEncode(value));

BackupRepository _backupsOf(FujinDatabase database) => BackupRepository(
  database: database,
  foods: foodsOf(database),
  meals: mealsOf(database),
  entries: entriesOf(database),
  memory: memoryOf(database),
  recents: recentsOf(database),
  links: SentLinkRepository(database),
  goals: goalsOf(database),
);

void main() {
  late FujinDatabase database;
  late MemoryRepository memories;
  late RecentFoodRepository recents;
  late SentLinkRepository links;
  late EntryRepository entries;
  late GoalsRepository goals;
  late FakeBackupFiles files;
  late BackupService backups;

  setUp(() {
    database = FujinDatabase.inMemory();
    memories = memoryOf(database)
      ..remember(
        meals: memory.meals,
        foods: [...memory.matches, _ownCopy],
        units: memory.units,
      )
      ..saveBarcodeLink(
        const BarcodeLink(barcode: _skyrBarcode, mfpFoodId: skyr),
      );
    recents = recentsOf(database);
    links = SentLinkRepository(database)..replaceAll([link('E-3', 'I-3')]);
    entries = entriesOf(database);
    storeEntry(database, entry('M-1'), 'e-1');
    entries
      ..linkItem('e-1', ekkloMealId: 'meal-1', ekkloItemId: 'I-1')
      ..expect({'e-1': expectation()});
    storeEntry(database, entry('M-2', food: rice), 'e-2');
    entries.remove('e-2');
    goals = goalsOf(database)..save(_goals);
    files = FakeBackupFiles();
    backups = BackupService(
      backups: _backupsOf(database),
      files: files,
      clock: () => now,
    );
  });

  tearDown(() => database.close());

  Map<String, Object?> exportedJson() => switch (jsonDecode(
    utf8.decode(files.saved[_fileName] ?? Uint8List(0)),
  )) {
    final Map<String, Object?> file => file,
    _ => throw StateError('export is not an object'),
  };

  MemoryRepository restoredInFreshDatabase(Backup? file) {
    final fresh = FujinDatabase.inMemory();
    addTearDown(fresh.close);
    _backupsOf(
      fresh,
    ).restore(file ?? (throw StateError('file is unreadable')));
    return memoryOf(fresh);
  }

  Future<Backup?> exported() async {
    await backups.export();
    return switch (files.saved[_fileName]) {
      final file? => backups.read(file),
      null => null,
    };
  }

  test('exports the foods, meals, entries, links and goals in a version 4 '
      'file named after the day', () async {
    final file = await exported();

    check(file).isA<BackupV4>()
      ..has((file) => file.version, 'version').equals(BackupV4.currentVersion)
      ..has((file) => file.entries, 'entries').deepEquals(entries.entries())
      ..has((file) => file.entries.length, 'entry count').equals(2)
      ..has((file) => file.mfpLinks, 'mfpLinks').deepEquals(entries.mfpLinks())
      ..has(
        (file) => file.ekkloLinks,
        'ekkloLinks',
      ).deepEquals(entries.ekkloLinks())
      ..has(
        (file) => [for (final link in file.ekkloLinks) link.unattended],
        'expectations',
      ).deepEquals([expectation()])
      ..has((file) => file.exportedAt, 'exportedAt').equals(now)
      ..has((file) => file.foods, 'foods').deepEquals(foodsOf(database).foods())
      ..has(
        (file) => file.mealMappings,
        'mealMappings',
      ).deepEquals(mealsOf(database).connectorMeals());
    check(file?.links).isNotNull().deepEquals([link('E-3', 'I-3')]);
    check(file?.linkCount).equals(2);
    check(file?.goals).equals(_goals);
    check(file?.foodCount).equals(memory.matches.length + 1);
    check(file?.mealCount).equals(memory.meals.length);
  });

  test('reads a version 4 file whose foods store verified as a number, '
      'as written by an earlier build', () async {
    await backups.export();
    final json = exportedJson();
    final foods = switch (json['foods']) {
      final List<Object?> foods => foods,
      _ => throw StateError('export has no foods'),
    };
    switch (foods.first) {
      case final Map<String, Object?> food:
        food['verified'] = 1;
      default:
        throw StateError('food is not an object');
    }

    final file = backups.read(_json(json));

    check(file)
        .isA<BackupV4>()
        .has(
          (file) => file.foods.first.verified,
          'verified',
        )
        .equals(true);
  });

  test('imports a version 4 file in place of everything recorded '
      'since', () async {
    final file = await exported();
    final before = memories.load();
    final foodsBefore = foodsOf(database).foods();
    final entriesBefore = entries.entries();
    final mfpLinksBefore = entries.mfpLinks();
    final ekkloLinksBefore = entries.ekkloLinks();
    entries.remove('e-1');
    storeEntry(database, entry('M-9', food: skyr), 'e-9');
    memories.clear();
    links.replaceAll([link('E-9', 'I-9')]);
    goals.replace(null);

    backups.restore(file ?? (throw StateError('export is unreadable')));

    check(memories.load()).equals(before);
    check(foodsOf(database).foods()).deepEquals(foodsBefore);
    check(entries.entries()).deepEquals(entriesBefore);
    check(entries.mfpLinks()).deepEquals(mfpLinksBefore);
    check(entries.ekkloLinks()).deepEquals(ekkloLinksBefore);
    check(links.all()).deepEquals([link('E-3', 'I-3')]);
    check(goals.load()).equals(_goals);
  });

  test('imports a version 3 file, which leaves no entry and its links '
      'waiting for the next read of their day', () async {
    await backups.export();
    final versionThree = exportedJson()
      ..remove('entries')
      ..remove('mfp_links')
      ..remove('ekklo_links');
    final foodsBefore = foodsOf(database).foods();
    links.replaceAll(const []);

    final file = backups.read(
      _json({
        ...versionThree,
        'version': BackupV3.foodsVersion,
        'links': [link('E-1', 'I-1').toMap()],
      }),
    );
    backups.restore(file ?? (throw StateError('version 3 is unreadable')));

    check(file).isA<BackupV3>();
    check(file.linkCount).equals(1);
    check(foodsOf(database).foods()).deepEquals(foodsBefore);
    check(entries.entries()).isEmpty();
    check(entries.ekkloLinks()).isEmpty();
    check(links.all()).deepEquals([link('E-1', 'I-1')]);
    check(goals.load()).equals(_goals);

    final backends = FakeBackends(
      entries: [entry('E-1')],
      ekkloMeals: [
        meal('meal-1', [item('I-1')]),
      ],
    );
    await journalOver(
      database,
      mfp: await backends.mfp(),
      ekklo: await backends.ekklo(),
    ).readDay(day);

    check(
      entries.findByMfpEntryId('E-1')?.ekkloLink?.item?.ekkloItemId,
    ).equals('I-1');
    check(links.forDate(day)).isEmpty();
  });

  test('carries the barcode links into a fresh database', () async {
    final restored = restoredInFreshDatabase(await exported());

    check(restored.barcodeFood(_skyrBarcode)).equals(skyr);
    check(restored.load()).equals(memories.load());
  });

  test('keeps the recent foods recorded before an import', () async {
    recents.record(_recentOats);
    final before = memories.load();
    final file = await exported();
    recents.record(_recentOil);

    backups.restore(file ?? (throw StateError('export is unreadable')));

    check(recents.latest()).unorderedEquals([_recentOats, _recentOil]);
    check(memories.load()).equals(before);
  });

  test('imports a version 2 file of 0.4.0, naming its foods after the '
      'recent ones and ordering its meals by name', () {
    recents.record(_recentOats);

    final file = backups.read(_json(_fileOfRelease040(BackupV2.memoryVersion)));
    backups.restore(file ?? (throw StateError('version 2 is unreadable')));

    check(memories.load()).equals(_memoryOfRelease040);
    check([
      for (final meal in mealsOf(database).meals()) (meal.position, meal.name),
    ]).unorderedEquals([(0, breakfast), (1, lunch)]);
    check(recents.latest()).deepEquals([_recentOats]);
    check(links.all()).deepEquals([link('E-1', 'I-1')]);
    check(goals.load()).equals(_goals);
  });

  test('imports a version 1 file, which has no barcode link', () {
    recents.record(_recentOats);
    final versionOne = _fileOfRelease040(BackupV2.versionWithoutBarcodeLinks)
      ..remove(_barcodeLinks);

    final file = backups.read(_json(versionOne));
    backups.restore(file ?? (throw StateError('version 1 is unreadable')));

    check(memories.barcodeFood(_skyrBarcode)).isNull();
    check(
      memories.load(),
    ).equals(_memoryOfRelease040.copyWith(barcodeLinks: const []));
  });

  group('refuses', () {
    test('a file of another format or version, or missing a table', () async {
      await backups.export();
      final file = exportedJson();
      final versionTwo = _fileOfRelease040(BackupV2.memoryVersion);

      for (final changed in [
        {...file, 'format': 'other-backup'},
        {...file, 'version': BackupV4.currentVersion + 1},
        {...file}..remove('entries'),
        {...file}..remove('links'),
        {...file}..remove('food_references'),
        {...file}..remove(_barcodeLinks),
        {...file, 'links': 'all of them'},
        {...versionTwo}..remove(_barcodeLinks),
        {...versionTwo}..remove('matches'),
      ]) {
        check(backups.read(_json(changed))).isNull();
      }
      check(backups.read(utf8.encode('not json'))).isNull();
      check(backups.read(Uint8List.fromList(const [0xff, 0xfe]))).isNull();
    });

    test('a whole file with two Ekklo links on one item and keeps what was '
        'there', () async {
      final before = memories.load();
      final entriesBefore = entries.entries();
      final ekkloLinksBefore = entries.ekkloLinks();
      final file = await exported();
      final rice = switch (file) {
        BackupV4(:final entries) => entries.last,
        _ => throw StateError('export is not version 4'),
      };
      final broken = file.copyWith(
        ekkloLinks: [
          ...file.ekkloLinks,
          ekkloLinkRow(
            'l-broken',
            entryId: rice.id,
            item: linkedItem('I-1', mealId: rice.mealId, foodId: rice.foodId),
          ),
        ],
      );

      check(() => backups.restore(broken)).throws<Exception>();

      check(memories.load()).equals(before);
      check(entries.entries()).deepEquals(entriesBefore);
      check(entries.ekkloLinks()).deepEquals(ekkloLinksBefore);
      check(links.all()).deepEquals([link('E-3', 'I-3')]);
      check(goals.load()).equals(_goals);
    });
  });
}
