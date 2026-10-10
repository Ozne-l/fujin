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
import 'package:fujin/domain/sending/review_reason.dart';
import 'package:fujin/domain/sending/send_choice.dart';
import 'package:fujin/domain/sending/send_interruption.dart';
import 'package:fujin/domain/sending/send_plan.dart';
import 'package:fujin/domain/sending/send_report.dart';
import 'package:fujin/domain/sending/send_service.dart';
import 'package:fujin/domain/sending/step_state.dart';
import 'package:http/http.dart' as http;

import '../../support/fake_backends.dart';
import '../../support/fixtures.dart';

const _gratin = 'mfp-gratin';
const _gratinName = 'Gratin dauphinois maison';
const _portion = 'portion';

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

  List<http.Request> writes(String method) => [
    for (final request in backends.requests)
      if (request.method == method &&
          request.url.path.startsWith(FakeBackends.dailyMealsPath))
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
    memory.matches.forEach(memoryRepository.saveFood);
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
      meal: snacks,
      unit: pot,
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
      remembered.food(skyr, pot),
    ).isA<MatchedFood>().has((it) => it.ekkloFoodId, 'food').equals('isey');
    check(
      remembered.gramsPerUnit(skyr, pot),
    ).isNotNull().isCloseTo(80 * 100 / 62, 1e-9);
    check(remembered.ekkloMealName(snacks)).equals(snacks);
    check(appendedMeals()).deepEquals([snacks]);
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
      final gratinEntry = entry(
        'E-1',
        food: _gratin,
        description: _gratinName,
        unit: _portion,
        servingValue: 1,
        servings: 1.5,
        nutrients: nutrients(kcal: 465, protein: 10.5),
      );
      backends = FakeBackends(entries: [gratinEntry]);
      final (journal, sending) = await services();

      final report = await send(sending, await planDay(sending));

      final copy = backends.ekkloFoods.single;
      check(copy)
        ..has((it) => it.name, 'name').equals(_gratinName)
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
      check(memoryRepository.load().food(_gratin, _portion)).isA<OwnCopy>()
        ..has((it) => it.ekkloFoodId, 'food').equals(copy.id)
        ..has((it) => it.mfpUnit, 'unit').equals(_portion);
      check((await journal.readDay(day)).counts.inEkklo).equals(1);
      check(report.ownCopies).deepEquals([_gratinName]);
    },
  );

  test('creates one own copy per unit of a food logged in two units', () async {
    backends = FakeBackends(
      entries: [
        entry(
          'E-1',
          food: _gratin,
          description: _gratinName,
          unit: _portion,
          servingValue: 1,
          servings: 1.5,
          nutrients: nutrients(kcal: 465, protein: 10.5),
        ),
        entry(
          'E-2',
          food: _gratin,
          description: _gratinName,
          servingValue: 200,
          nutrients: nutrients(kcal: 300, protein: 7),
        ),
      ],
    );
    final (journal, sending) = await services();

    final report = await send(sending, await planDay(sending));

    final copies = {
      for (final food in backends.ekkloFoods) food.id: food.quantityType,
    };
    check(copies).length.equals(2);
    check([
      for (final item in backends.ekkloItems)
        (copies[item.foodId], item.quantityType, item.quantity),
    ]).deepEquals([
      (EkkloQuantityType.portion, EkkloQuantityType.portion, 1.5),
      (EkkloQuantityType.grams, EkkloQuantityType.grams, 200),
    ]);
    check(report.ownCopies).length.equals(2);
    check({
      for (final copy in memoryRepository.load().ownCopies)
        copy.mfpUnit: copies[copy.ekkloFoodId],
    }).deepEquals({
      _portion: EkkloQuantityType.portion,
      grams: EkkloQuantityType.grams,
    });
    for (final link in links.forDate(day)) {
      links.remove(link.mfpEntryId);
    }
    check((await journal.readDay(day)).counts.inEkklo).equals(2);
  });

  test('reuses the own copy created before an interruption', () async {
    backends = FakeBackends(
      entries: [
        entry(
          'E-1',
          food: _gratin,
          description: _gratinName,
          unit: _portion,
          servingValue: 1,
          nutrients: nutrients(kcal: 310, protein: 7),
        ),
      ],
    );
    backends.failingMeals.add(petitDejeuner);
    final (journal, sending) = await services();
    final plan = await planDay(sending);
    await check(send(sending, plan)).throws<SendInterruption>();

    backends.failingMeals.clear();
    final report = await send(sending, plan);

    final copy = backends.ekkloFoods.single;
    check(backends.ekkloItems.single.foodId).equals(copy.id);
    check(report.ownCopies).isEmpty();
    check((await journal.readDay(day)).counts.inEkklo).equals(1);
  });

  test('reads the remembered Ekklo food to weigh a new unit', () async {
    backends = FakeBackends(
      entries: [
        entry(
          'E-1',
          food: rice,
          unit: bowl,
          servingValue: 1,
          nutrients: nutrients(kcal: 260, carbs: 56),
        ),
      ],
      ekkloFoods: [ekkloFood(riceInEkklo, calories: 130, carbs: 28)],
    );
    final (_, sending) = await services();

    final plan = await planDay(sending);
    await send(sending, plan);

    check(plan.entries.single)
      ..has((it) => it.reason, 'reason').equals(ReviewReason.weightToConfirm)
      ..has((it) => it.choice, 'choice')
          .isA<SendToEkkloFood>()
          .has(
            (it) => it.grams,
            'grams',
          )
          .equals(200);
    check(memoryRepository.load().gramsPerUnit(rice, bowl)).equals(200);
    check(backends.ekkloItems.single)
      ..has((it) => it.foodId, 'food').equals(riceInEkklo)
      ..has((it) => it.quantity, 'quantity').equals(200);
  });

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
