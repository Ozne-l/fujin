import 'package:checks/checks.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter_test/flutter_test.dart'
    show group, setUp, tearDown, test;
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/links/sent_link_repository.dart';
import 'package:fujin/data/memory/memory_repository.dart';
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

void main() {
  late FujinDatabase database;
  late SentLinkRepository links;
  late UnattendedItemRepository unattended;
  late FakeBackends backends;

  Future<JournalService> service({EkkloClient? ekklo}) async => JournalService(
    mfp: await backends.mfp(),
    ekklo: ekklo ?? await backends.ekklo(),
    links: links,
    unattended: unattended,
    memory: MemoryRepository(database),
    database: database,
    clock: () => now,
  );

  Future<JournalRead> readJournal(
    JournalService journal, {
    List<String> mealNames = const [],
  }) async {
    final diary = Fetch.of(journal.fetchDiary(day));
    final meals = Fetch.of(journal.fetchEkkloMeals(day));
    return journal.journalOf(
      day,
      diary: await diary,
      meals: await meals,
      mealNames: mealNames,
    );
  }

  setUp(() {
    database = FujinDatabase.inMemory();
    links = SentLinkRepository(database);
    unattended = UnattendedItemRepository(database);
    final repository = MemoryRepository(database);
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

    check(
          first.comparison.entries.single.status,
        )
        .isA<InEkklo>()
        .has((status) => status.link.ekkloItemId, 'item')
        .equals(
          'I-1',
        );
    check(links.forDate(day)).length.equals(1);
    check(second.comparison.linksToAdopt).isEmpty();
    check(second.counts.inEkklo).equals(1);
  });

  test('forgets the link of an item deleted in Ekklo', () async {
    links.add(link('E-1', 'I-1'));
    backends = FakeBackends(
      entries: [entry('E-1')],
      ekkloMeals: [meal('meal-1', [])],
    );

    final read = await (await service()).readDay(day);

    check(read.comparison.entries.single.status).isA<ToSend>();
    check(links.forDate(day)).isEmpty();
  });

  test('moves a link to the new id of an entry re-saved in '
      'MyFitnessPal', () async {
    links.add(link('E-1', 'I-1'));
    backends = FakeBackends(
      entries: [entry('E-2')],
      ekkloMeals: [
        meal('meal-1', [item('I-1')]),
      ],
    );

    await (await service()).readDay(day);

    check(
      links.forDate(day).map((link) => (link.mfpEntryId, link.ekkloItemId)),
    ).deepEquals([('E-2', 'I-1')]);
  });

  test('forgets the unattended item of an entry that left the day', () async {
    unattended.record([unattendedItem('E-1'), unattendedItem('E-9')]);
    backends = FakeBackends(entries: [entry('E-1')]);

    await (await service()).readDay(day);

    check(
      unattended.forDate(day).map((item) => item.mfpEntryId),
    ).deepEquals(['E-1']);
  });

  test('moves the unattended item of an entry re-saved in MyFitnessPal '
      'to its new id', () async {
    links.add(link('E-1', 'I-1'));
    unattended.record([unattendedItem('E-1')]);
    backends = FakeBackends(
      entries: [entry('E-2')],
      ekkloMeals: [
        meal('meal-1', [item('I-1')]),
      ],
    );

    await (await service()).readDay(day);

    check(unattended.forDate(day)).deepEquals([unattendedItem('E-2')]);
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
        check(read.diary?.entries).isNotNull().length.equals(1);
      },
    );

    test('leaves the links alone when composed from reads made before a '
        'send', () async {
      backends = FakeBackends(entries: [entry('E-1')]);
      final journal = await service();
      final diary = await journal.fetchDiary(day);
      final meals = await journal.fetchEkkloMeals(day);
      links.add(link('E-1', 'I-1'));

      final read = journal.journalOf(day, diary: diary, meals: meals);

      check(read).isA<BothSides>();
      check(
        links.forDate(day).map((link) => (link.mfpEntryId, link.ekkloItemId)),
      ).deepEquals([('E-1', 'I-1')]);
    });

    test('stores the links only once settled from a fresh read', () async {
      backends = FakeBackends(
        entries: [entry('E-1')],
        ekkloMeals: [
          meal('meal-1', [item('I-1')]),
        ],
      );
      final journal = await service();
      final diary = await journal.fetchDiary(day);
      final meals = await journal.fetchEkkloMeals(day);

      final read = journal.journalOf(day, diary: diary, meals: meals);
      check(read)
          .isA<BothSides>()
          .has((read) => read.day.counts.inEkklo, 'in Ekklo')
          .equals(1);
      check(links.forDate(day)).isEmpty();

      journal.settleLinks(day, diary: diary.value, meals: meals.value);
      check(
        links.forDate(day).map((link) => (link.mfpEntryId, link.ekkloItemId)),
      ).deepEquals([('E-1', 'I-1')]);
    });

    test('fails as offline when MyFitnessPal cannot be reached', () async {
      backends = FakeBackends(entries: [entry('E-1')]);
      final journal = await service();
      backends.mfpReachable = false;

      await check(readJournal(journal)).throws<MfpNetworkException>();
    });
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
