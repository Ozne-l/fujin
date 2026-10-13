import 'dart:convert';
import 'dart:typed_data';

import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart'
    show addTearDown, group, setUp, tearDown, test;
import 'package:fujin/data/backup/backup.dart';
import 'package:fujin/data/backup/backup_repository.dart';
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/goals/goals.dart';
import 'package:fujin/data/goals/goals_repository.dart';
import 'package:fujin/data/links/sent_link_repository.dart';
import 'package:fujin/data/memory/barcode_link.dart';
import 'package:fujin/data/memory/memory_repository.dart';
import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/domain/backup/backup_service.dart';

import '../../support/fake_backup_files.dart';
import '../../support/fixtures.dart';

const _fileName = 'fujin-backup-2026-10-07.json';
const _skyrBarcode = '3033490004521';
const _barcodeLinks = 'barcode_links';
const _versionWithoutBarcodeLinks = 1;
const _goals = Goals(kilocalories: 3000, protein: 160, fat: 70);
const _ownCopy = OwnCopy(
  mfpFoodId: skyr,
  mfpDescription: skyr,
  ekkloFoodId: 'own-skyr',
  ekkloFoodName: skyr,
  mfpUnit: pot,
  mfpFoodVersion: 'v1',
);

Uint8List _json(Object value) => utf8.encode(jsonEncode(value));

void main() {
  late FujinDatabase database;
  late MemoryRepository memories;
  late SentLinkRepository links;
  late GoalsRepository goals;
  late FakeBackupFiles files;
  late BackupService backups;

  setUp(() {
    database = FujinDatabase.inMemory();
    memories = MemoryRepository(database)
      ..remember(
        meals: memory.meals,
        foods: [...memory.matches, _ownCopy],
        units: memory.units,
      )
      ..saveBarcodeLink(
        const BarcodeLink(barcode: _skyrBarcode, mfpFoodId: skyr),
      );
    links = SentLinkRepository(database)..add(link('E-1', 'I-1'));
    goals = GoalsRepository(database)..save(_goals);
    files = FakeBackupFiles();
    backups = BackupService(
      backups: BackupRepository(
        database: database,
        memory: memories,
        links: links,
        goals: goals,
      ),
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
    final freshMemories = MemoryRepository(fresh);
    BackupRepository(
      database: fresh,
      memory: freshMemories,
      links: SentLinkRepository(fresh),
      goals: GoalsRepository(fresh),
    ).restore(file ?? (throw StateError('file is unreadable')));
    return freshMemories;
  }

  Future<Backup?> exported() async {
    await backups.export();
    return switch (files.saved[_fileName]) {
      final file? => backups.read(file),
      null => null,
    };
  }

  test('exports the memory, links and goals to a file named after the '
      'day', () async {
    final file = await exported();

    check(file?.exportedAt).equals(now);
    check(file?.memory).equals(memories.load());
    check(file?.links).isNotNull().deepEquals([link('E-1', 'I-1')]);
    check(file?.goals).equals(_goals);
    check(file?.foodCount).equals(memory.matches.length + 1);
  });

  test('imports a file in place of everything recorded since', () async {
    final file = await exported();
    final before = memories.load();
    memories.clear();
    links
      ..remove('E-1')
      ..add(link('E-9', 'I-9'));
    goals.replace(null);

    backups.restore(file ?? (throw StateError('export is unreadable')));

    check(memories.load()).equals(before);
    check(links.all()).deepEquals([link('E-1', 'I-1')]);
    check(goals.load()).equals(_goals);
  });

  test('carries the barcode links into a fresh database', () async {
    final restored = restoredInFreshDatabase(await exported());

    check(restored.barcodeFood(_skyrBarcode)).equals(skyr);
    check(restored.load()).equals(memories.load());
  });

  test('imports a version 1 file, which has no barcode link', () async {
    await backups.export();
    final versionOne = {
      ...exportedJson(),
      'version': _versionWithoutBarcodeLinks,
    }..remove(_barcodeLinks);

    final before = memories.load();

    final file = backups.read(_json(versionOne));
    backups.restore(file ?? (throw StateError('version 1 is unreadable')));

    check(memories.barcodeFood(_skyrBarcode)).isNull();
    check(memories.load()).equals(before.copyWith(barcodeLinks: const []));
  });

  group('refuses', () {
    test('a file of another format or version, or missing a table', () async {
      await backups.export();
      final file = exportedJson();

      for (final changed in [
        {...file, 'format': 'other-backup'},
        {...file, 'version': Backup.currentVersion + 1},
        {...file}..remove('links'),
        {...file}..remove(_barcodeLinks),
        {...file, 'links': 'all of them'},
      ]) {
        check(backups.read(_json(changed))).isNull();
      }
      check(backups.read(utf8.encode('not json'))).isNull();
      check(backups.read(Uint8List.fromList(const [0xff, 0xfe]))).isNull();
    });

    test('a whole file with a broken link and keeps what was there', () {
      final before = memories.load();
      final broken = Backup(
        exportedAt: now,
        matches: const [],
        ownCopies: const [],
        units: const [],
        meals: const [],
        links: [link('E-7', 'I-7'), link('E-8', 'I-7')],
        barcodeLinks: const [],
      );

      check(() => backups.restore(broken)).throws<Exception>();

      check(memories.load()).equals(before);
      check(links.all()).deepEquals([link('E-1', 'I-1')]);
      check(goals.load()).equals(_goals);
    });
  });
}
