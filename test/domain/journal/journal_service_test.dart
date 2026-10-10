import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart' show setUp, tearDown, test;
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/links/sent_link_repository.dart';
import 'package:fujin/data/memory/memory_repository.dart';
import 'package:fujin/domain/comparison/entry_status.dart';
import 'package:fujin/domain/journal/journal_service.dart';

import '../../support/fake_backends.dart';
import '../../support/fixtures.dart';

void main() {
  late FujinDatabase database;
  late SentLinkRepository links;
  late FakeBackends backends;

  Future<JournalService> service() async => JournalService(
    mfp: await backends.mfp(),
    ekklo: await backends.ekklo(),
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
}
