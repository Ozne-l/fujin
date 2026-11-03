import 'package:checks/checks.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter_test/flutter_test.dart'
    show group, setUp, tearDown, test;
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/database/fujin_table.dart';
import 'package:fujin/data/entries/entry_repository.dart';
import 'package:fujin/data/entries/unattended_expectation.dart';
import 'package:fujin/data/links/sent_link_repository.dart';
import 'package:fujin/data/unattended/unattended_item_repository.dart';
import 'package:fujin/domain/comparison/entry_status.dart';
import 'package:fujin/domain/journal/fetch.dart';
import 'package:fujin/domain/journal/journal_read.dart';
import 'package:fujin/domain/journal/journal_service.dart';
import 'package:fujin/domain/journal/logged_kilocalories.dart';
import 'package:fujin/domain/journal/read_problem.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

import '../../support/fake_backends.dart';
import '../../support/fixtures.dart';
import '../../support/repositories.dart';

void main() {
  late FujinDatabase database;
  late EntryRepository entries;
  late FakeBackends backends;

  Future<JournalService> service({EkkloClient? ekklo}) async => journalOver(
    database,
    mfp: await backends.mfp(),
    ekklo: ekklo ?? await backends.ekklo(),
  );

  Future<(Fetch<MfpDiaryDay>, Fetch<List<EkkloDailyMeal>>)> fetch(
    JournalService journal,
  ) async {
    final diary = Fetch.of(journal.fetchDiary(day));
    final meals = Fetch.of(journal.fetchEkkloMeals(day));
    return (await diary, await meals);
  }

  Future<JournalRead> readJournal(
    JournalService journal, {
    List<String> mealNames = const [],
  }) async {
    final (diary, meals) = await fetch(journal);
    return journal.journalOf(
      day,
      diary: diary,
      meals: meals,
      mealNames: mealNames,
    );
  }

  String stored(
    String mfpEntryId, {
    String? itemId,
    UnattendedExpectation? unattended,
  }) {
    final id = storeEntry(database, entry(mfpEntryId), 'e-$mfpEntryId');
    if (itemId case final itemId?) {
      entries.linkItem(id, ekkloMealId: 'meal-1', ekkloItemId: itemId);
    }
    if (unattended case final unattended?) entries.expect({id: unattended});
    return id;
  }

  String? linkedItemOf(String mfpEntryId) =>
      entries.findByMfpEntryId(mfpEntryId)?.ekkloLink?.item?.ekkloItemId;

  List<String> liveLinkEntries() => [
    for (final link in entries.ekkloLinks())
      if (link.deletedAt == null) link.entryId,
  ];

  setUp(() {
    database = FujinDatabase.inMemory();
    entries = entriesOf(database);
    final repository = memoryOf(database);
    memory.matches.forEach(repository.saveFood);
    memory.units.forEach(repository.saveUnit);
    memory.meals.forEach(repository.saveMeal);
  });

  tearDown(() => database.close());

  test('keeps the item of an interrupted send instead of sending it '
      'twice', () async {
    backends = FakeBackends(
      entries: [entry('E-1')],
      ekkloMeals: [
        meal('meal-1', [item('I-1')]),
      ],
    );
    final journal = await service();

    final first = await journal.readDay(day);
    final second = await journal.readDay(day);

    check(first.entries.single.status)
        .isA<InEkklo>()
        .has((status) => status.link.item?.ekkloItemId, 'item')
        .equals('I-1');
    check(linkedItemOf('E-1')).equals('I-1');
    check(second.comparison.changes.addedEkkloLinks).isEmpty();
    check(second.counts().inEkklo).equals(1);
  });

  test('forgets the link of an item deleted in Ekklo', () async {
    final id = stored('E-1', itemId: 'I-1');
    backends = FakeBackends(
      entries: [entry('E-1')],
      ekkloMeals: [meal('meal-1', [])],
    );

    final read = await (await service()).readDay(day);

    check(read.entries.single.status).isA<ToSend>();
    check(entries.find(id)?.ekkloLink).isNull();
  });

  test('moves a link to the new id of an entry re-saved in '
      'MyFitnessPal', () async {
    final id = stored('E-1', itemId: 'I-1');
    backends = FakeBackends(
      entries: [entry('E-2')],
      ekkloMeals: [
        meal('meal-1', [item('I-1')]),
      ],
    );

    await (await service()).readDay(day);

    check(entries.find(id)).isNull();
    check(linkedItemOf('E-2')).equals('I-1');
    check(liveLinkEntries()).deepEquals([
      ?entries.findByMfpEntryId('E-2')?.entry.id,
    ]);
  });

  test('forgets the unattended item of an entry that left the day', () async {
    final kept = stored('E-1', unattended: expectation());
    stored('E-9', unattended: expectation());
    backends = FakeBackends(entries: [entry('E-1')]);

    await (await service()).readDay(day);

    check(liveLinkEntries()).deepEquals([kept]);
  });

  test('moves the unattended item of an entry re-saved in MyFitnessPal '
      'to its new id', () async {
    stored('E-1', itemId: 'I-1', unattended: expectation());
    backends = FakeBackends(
      entries: [entry('E-2')],
      ekkloMeals: [
        meal('meal-1', [item('I-1')]),
      ],
    );

    await (await service()).readDay(day);

    check(
      entries.findByMfpEntryId('E-2')?.ekkloLink?.unattended,
    ).equals(expectation());
    check(linkedItemOf('E-2')).equals('I-1');
  });

  test('stores entries, links and no waiting row on the first read of a '
      'day after the upgrade', () async {
    database
      ..insert(FujinTable.sentLink, link('E-1', 'I-1').toMap())
      ..insert(FujinTable.unattendedItem, unattendedItem('E-2').toMap());
    backends = FakeBackends(
      entries: [
        entry('E-1'),
        entry('E-2', food: rice),
      ],
      ekkloMeals: [
        meal('meal-1', [item('I-1')]),
      ],
    );

    final read = await (await service()).readDay(day);

    check(read.entries.map((compared) => compared.entryId)).deepEquals([
      entries.findByMfpEntryId('E-1')?.entry.id,
      entries.findByMfpEntryId('E-2')?.entry.id,
    ]);
    check(linkedItemOf('E-1')).equals('I-1');
    check(entries.findByMfpEntryId('E-2')?.ekkloLink)
        .isNotNull()
        .has((link) => link.unattended, 'expectation')
        .equals(expectation());
    check(SentLinkRepository(database).forDate(day)).isEmpty();
    check(UnattendedItemRepository(database).forDate(day)).isEmpty();
  });

  group('the Journal read', () {
    test(
      'keeps the MyFitnessPal side when the Ekklo session expired',
      () async {
        backends = FakeBackends(
          mealNames: [breakfast],
          entries: [entry('E-1')],
        );
        final store = InMemoryEkkloTokenStore();
        await store.write(FakeBackends.staleEkkloTokens);
        final journal = await service(ekklo: backends.ekkloWith(store));

        final read = await readJournal(journal, mealNames: [breakfast]);

        check(read)
            .isA<MfpOnly>()
            .has((read) => read.ekkloProblem, 'Ekklo problem')
            .equals(ReadProblem.ekkloSessionExpired);
        check(
          read.diaryMeals.map((meal) => (meal.name, meal.entries.length)),
        ).deepEquals([(breakfast, 1)]);
      },
    );

    test('still stores the MyFitnessPal side when Ekklo fails', () async {
      database.insert(FujinTable.sentLink, link('E-1', 'I-1').toMap());
      backends = FakeBackends(entries: [entry('E-1')]);
      final store = InMemoryEkkloTokenStore();
      await store.write(FakeBackends.staleEkkloTokens);
      final journal = await service(ekklo: backends.ekkloWith(store));
      final (diary, meals) = await fetch(journal);

      journal.settleDay(day, diary: diary, meals: meals);
      final read = journal.journalOf(day, diary: diary, meals: meals);

      final id = entries.findByMfpEntryId('E-1')?.entry.id;
      check(id).isNotNull();
      check(linkedItemOf('E-1')).equals('I-1');
      check(SentLinkRepository(database).forDate(day)).isEmpty();
      check(read)
          .isA<MfpOnly>()
          .has(
            (read) => [
              for (final meal in read.meals)
                for (final logged in meal.entries) logged.entry.id,
            ],
            'entries',
          )
          .deepEquals([id]);
    });

    test('leaves the entries and links alone when composed from reads made '
        'before a send', () async {
      backends = FakeBackends(entries: [entry('E-1'), entry('E-2')]);
      final journal = await service();
      final (diary, meals) = await fetch(journal);
      final id = stored('E-1', itemId: 'I-1');

      final read = journal.journalOf(day, diary: diary, meals: meals);

      check(read).isA<BothSides>();
      check(entries.find(id)?.ekkloLink?.item?.ekkloItemId).equals('I-1');
      check(entries.findByMfpEntryId('E-2')).isNull();
    });

    test('stores the entries and links only once settled from a fresh '
        'read', () async {
      backends = FakeBackends(
        entries: [entry('E-1')],
        ekkloMeals: [
          meal('meal-1', [item('I-1')]),
        ],
      );
      final journal = await service();
      final (diary, meals) = await fetch(journal);

      final read = journal.journalOf(day, diary: diary, meals: meals);
      check(read)
          .isA<BothSides>()
          .has((read) => read.day.counts().inEkklo, 'in Ekklo')
          .equals(1);
      check(entries.entries()).isEmpty();

      journal.settleDay(day, diary: diary, meals: meals);
      check(linkedItemOf('E-1')).equals('I-1');
    });

    test('shows the entries a held diary would copy in without a '
        'fiche, and stores nothing', () async {
      backends = FakeBackends(entries: [entry('E-1')]);
      final journal = await service();

      final read = await readJournal(journal);

      check(read)
          .isA<BothSides>()
          .has(
            (read) => [for (final row in read.day.entries) row.entryId],
            'ids',
          )
          .deepEquals([null]);
      check(entries.entries()).isEmpty();
    });

    test(
      'shows the entries stored in Fūjin when MyFitnessPal cannot be reached',
      () async {
        backends = FakeBackends(entries: [entry('E-1')]);
        final id = stored('E-1');
        final journal = await service();
        backends.mfpReachable = false;

        final read = await readJournal(journal);

        check(read).isA<FujinOnly>();
        check([
          for (final meal in read.diaryMeals)
            for (final logged in meal.entries) logged.entry.id,
        ]).deepEquals([id]);
      },
    );

    test(
      'shows the entries stored in Fūjin when only Ekklo cannot be reached',
      () async {
        backends = FakeBackends(entries: [entry('E-1')]);
        final id = stored('E-1');
        final journal = await service();
        backends.ekkloReachable = false;

        final read = await readJournal(journal);

        check(read).isA<FujinOnly>();
        check([
          for (final meal in read.diaryMeals)
            for (final logged in meal.entries) logged.entry.id,
        ]).deepEquals([id]);
      },
    );
  });

  test('sums the kilocalories logged on a day, null when nothing is '
      'logged', () async {
    final yesterday = DateTime.utc(2026, 10, 6);
    backends = FakeBackends(
      entries: [
        entry('E-1', nutrients: nutrients(kcal: 500)),
        entry('E-2', nutrients: nutrients(kcal: 250)),
      ],
    );
    final journal = await service();

    final before = await journal.fetchDiary(yesterday);
    final logged = await journal.fetchDiary(day);

    check(loggedKilocalories(before.value)).isNull();
    check(loggedKilocalories(logged.value)).equals(750);
  });
}
