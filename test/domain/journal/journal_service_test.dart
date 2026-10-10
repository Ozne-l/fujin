import 'package:checks/checks.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter_test/flutter_test.dart'
    show group, setUp, tearDown, test;
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/links/sent_link_repository.dart';
import 'package:fujin/data/memory/memory_repository.dart';
import 'package:fujin/domain/comparison/entry_status.dart';
import 'package:fujin/domain/journal/journal_read.dart';
import 'package:fujin/domain/journal/journal_service.dart';
import 'package:fujin/domain/journal/read_problem.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

import '../../support/fake_backends.dart';
import '../../support/fixtures.dart';

void main() {
  late FujinDatabase database;
  late SentLinkRepository links;
  late FakeBackends backends;

  Future<JournalService> service({EkkloClient? ekklo}) async => JournalService(
    mfp: await backends.mfp(),
    ekklo: ekklo ?? await backends.ekklo(),
    links: links,
    memory: MemoryRepository(database),
    clock: () => now,
  );

  setUp(() {
    database = FujinDatabase.inMemory();
    links = SentLinkRepository(database);
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

        final read = await journal.readJournal(day, mealNames: [breakfast]);

        check(read)
            .isA<MfpOnly>()
            .has((read) => read.ekkloProblem, 'Ekklo problem')
            .equals(ReadProblem.ekkloSessionExpired);
        check(read.diary?.entries).isNotNull().length.equals(1);
      },
    );

    test('fails as offline when MyFitnessPal cannot be reached', () async {
      backends = FakeBackends(entries: [entry('E-1')]);
      final journal = await service();
      backends.mfpReachable = false;

      await check(journal.readJournal(day)).throws<MfpNetworkException>();
    });
  });

  test('sums the kilocalories logged on each day, null when nothing is '
      'logged', () async {
    final yesterday = DateTime.utc(2026, 10, 6);
    backends = FakeBackends(
      entries: [
        entry('E-1', nutrients: nutrients(kcal: 500)),
        entry('E-2', nutrients: nutrients(kcal: 250)),
      ],
    );

    final logged = await (await service()).loggedKilocalories([
      yesterday,
      day,
    ]);

    check(logged.keys).unorderedEquals([yesterday, day]);
    check(logged[yesterday]).isNull();
    check(logged[day]).equals(750);
  });
}
