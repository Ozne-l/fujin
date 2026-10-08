import 'dart:convert';

import 'package:checks/checks.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter_test/flutter_test.dart' show setUp, tearDown, test;
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/links/sent_link_repository.dart';
import 'package:fujin/data/memory/memory_repository.dart';
import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/domain/comparison/entry_status.dart';
import 'package:fujin/domain/journal/journal_service.dart';
import 'package:fujin/domain/sending/send_interruption.dart';
import 'package:fujin/domain/sending/send_plan.dart';
import 'package:fujin/domain/sending/send_report.dart';
import 'package:fujin/domain/sending/send_service.dart';
import 'package:fujin/domain/sending/step_state.dart';
import 'package:http/http.dart' as http;

import '../../support/fake_backends.dart';
import '../../support/fixtures.dart';

const collations = 'Collations';
const _dailyMeals = '/api/v1/nutritions/daily-meals';

void main() {
  late FujinDatabase database;
  late SentLinkRepository links;
  late MemoryRepository memoryRepository;
  late FakeBackends backends;

  Future<(JournalService, SendService)> services() async {
    final ekklo = await backends.ekklo();
    final journal = JournalService(
      mfp: await backends.mfp(),
      ekklo: ekklo,
      links: links,
      memory: memoryRepository,
      clock: () => now,
    );
    return (
      journal,
      SendService(
        journal: journal,
        ekklo: ekklo,
        memory: memoryRepository,
        links: links,
        clock: () => now,
      ),
    );
  }

  Future<SendPlan> planDay(SendService sending) =>
      sending.plan(day, onProgress: (_) {});

  Future<SendReport> send(SendService sending, SendPlan plan) =>
      sending.send(plan, onProgress: (_) {});

  List<http.Request> writes(String method, [String path = _dailyMeals]) => [
    for (final request in backends.requests)
      if (request.method == method && request.url.path.startsWith(path))
        request,
  ];

  List<String> appendedMeals() => [
    for (final request in writes('POST'))
      (jsonDecode(request.body) as Map<String, Object?>)['name'].toString(),
  ];

  setUp(() {
    database = FujinDatabase.inMemory();
    links = SentLinkRepository(database);
    memoryRepository = MemoryRepository(database);
    memory.foods.forEach(memoryRepository.saveFood);
    memory.units.forEach(memoryRepository.saveUnit);
    memory.meals.forEach(memoryRepository.saveMeal);
  });

  tearDown(() => database.close());

  test('sends each Ekklo meal once and links every new item', () async {
    backends = FakeBackends(
      entries: [
        entry('E-1'),
        entry('E-2', food: rice, meal: lunch, unit: cup, servingValue: 1),
        entry('E-3', meal: lunch, servings: 0.5),
      ],
    );
    final (journal, sending) = await services();

    final report = await send(sending, await planDay(sending));

    check(appendedMeals()).deepEquals([petitDejeuner, dejeuner]);
    check(
      [for (final item in backends.ekkloItems) item.quantity],
    ).deepEquals([100, 180, 50]);
    check(links.forDate(day)).length.equals(3);
    check((await journal.readDay(day)).counts.inEkklo).equals(3);
    check(report)
      ..has((it) => it.sent, 'sent').equals(3)
      ..has((it) => it.reused, 'reused').equals(3);
  });

  test('remembers a new association, its unit weight and the meal', () async {
    final pots = entry(
      'E-1',
      food: skyr,
      description: 'Skyr nature',
      brand: 'Isey',
      meal: collations,
      unit: 'pot',
      servingValue: 1,
      servings: 2,
      nutrients: nutrients(kcal: 160, protein: 25, carbs: 10, fat: 0.5),
    );
    backends = FakeBackends(
      entries: [pots],
      ekkloSearches: {
        'skyr': [isey],
      },
    );
    final (journal, sending) = await services();

    final report = await send(sending, await planDay(sending));

    final remembered = memoryRepository.load();
    check(
      remembered.food(skyr),
    ).isA<MatchedFood>().has((it) => it.ekkloFoodId, 'food').equals('isey');
    check(
      remembered.gramsPerUnit(skyr, 'pot'),
    ).isNotNull().isCloseTo(80 * 100 / 62, 1e-9);
    check(remembered.ekkloMealName(collations)).equals(collations);
    check(appendedMeals()).deepEquals([collations]);
    check((await journal.readDay(day)).counts.inEkklo).equals(1);
    check(report)
      ..has((it) => it.newAssociations, 'associations').deepEquals([
        'Skyr nature',
      ])
      ..has((it) => it.weights.length, 'weights').equals(1)
      ..has((it) => it.reused, 'reused').equals(0);
  });

  test(
    'creates an own copy before sending it in portions of its unit',
    () async {
      final gratin = entry(
        'E-1',
        food: 'mfp-gratin',
        description: 'Gratin dauphinois maison',
        unit: 'portion',
        servingValue: 1,
        servings: 1.5,
        nutrients: nutrients(kcal: 465, protein: 10.5),
      );
      backends = FakeBackends(entries: [gratin]);
      final (journal, sending) = await services();

      final report = await send(sending, await planDay(sending));

      final copy = backends.ekkloFoods.single;
      check(copy)
        ..has((it) => it.name, 'name').equals('Gratin dauphinois maison')
        ..has((it) => it.quantityType, 'type').equals(EkkloQuantityType.portion)
        ..has((it) => it.calories, 'kcal').equals(310)
        ..has((it) => it.proteins, 'protein').equals(7);
      check(backends.ekkloItems.single)
        ..has((it) => it.foodId, 'food').equals(copy.id)
        ..has((it) => it.quantity, 'quantity').equals(1.5)
        ..has(
          (it) => it.quantityType,
          'type',
        ).equals(EkkloQuantityType.portion);
      check(memoryRepository.load().food('mfp-gratin')).isA<OwnCopy>()
        ..has((it) => it.ekkloFoodId, 'food').equals(copy.id)
        ..has((it) => it.mfpUnit, 'unit').equals('portion');
      check((await journal.readDay(day)).counts.inEkklo).equals(1);
      check(report.ownCopies).deepEquals(['Gratin dauphinois maison']);
    },
  );

  test('changes only the quantity of an item whose servings changed', () async {
    links.add(link('E-1', 'I-1'));
    backends = FakeBackends(
      entries: [entry('E-2', servings: 2)],
      ekkloMeals: [
        meal('meal-1', [item('I-1')]),
      ],
    );
    final (journal, sending) = await services();

    final plan = await planDay(sending);
    final report = await send(sending, plan);

    check(plan.updatesOnly).isTrue();
    check(writes('POST')).isEmpty();
    check(backends.ekkloItems.single)
      ..has((it) => it.id, 'id').equals('I-1')
      ..has((it) => it.quantity, 'quantity').equals(200);
    check(
      [for (final sent in links.forDate(day)) sent.mfpEntryId],
    ).deepEquals(['E-2']);
    check((await journal.readDay(day)).counts.inEkklo).equals(1);
    check(report.updated).equals(1);
  });

  test('moves an item to the Ekklo meal of an entry moved in '
      'MyFitnessPal', () async {
    links.add(link('E-1', 'I-1'));
    backends = FakeBackends(
      entries: [entry('E-2', meal: lunch)],
      ekkloMeals: [
        meal('meal-1', [item('I-1')]),
      ],
    );
    final (journal, sending) = await services();

    await send(sending, await planDay(sending));

    check(writes('DELETE')).length.equals(1);
    check(appendedMeals()).deepEquals([dejeuner]);
    check(backends.ekkloItems.single.id).not((it) => it.equals('I-1'));
    final read = await journal.readDay(day);
    check(read.comparison.entries.single.status).isA<InEkklo>();
  });

  test('never sends twice a meal whose reply was lost', () async {
    backends = FakeBackends(
      entries: [
        entry('E-1'),
        entry('E-2', meal: lunch),
      ],
    );
    backends.lostReplies.add(dejeuner);
    final (journal, sending) = await services();
    final plan = await planDay(sending);

    await check(send(sending, plan)).throws<SendInterruption>(
      (interruption) => interruption.has((it) => it.progress, 'progress')
        ..has(
          (it) => [for (final step in it.steps) step.state],
          'steps',
        ).deepEquals([StepState.done, StepState.failed])
        ..has((it) => it.remainingEntries, 'remaining').equals(1),
    );

    backends.lostReplies.clear();
    await send(sending, plan);

    check(appendedMeals()).deepEquals([petitDejeuner, dejeuner]);
    check(backends.ekkloItems).length.equals(2);
    check((await journal.readDay(day)).counts.inEkklo).equals(2);
  });

  test('sends again only the meal that failed', () async {
    backends = FakeBackends(
      entries: [
        entry('E-1'),
        entry('E-2', meal: lunch),
      ],
    );
    backends.failingMeals.add(dejeuner);
    final (journal, sending) = await services();
    final plan = await planDay(sending);
    await check(send(sending, plan)).throws<SendInterruption>();

    backends.failingMeals.clear();
    await send(sending, plan);

    check(appendedMeals()).deepEquals([petitDejeuner, dejeuner, dejeuner]);
    check(backends.ekkloItems).length.equals(2);
    check(links.forDate(day)).length.equals(2);
  });
}
