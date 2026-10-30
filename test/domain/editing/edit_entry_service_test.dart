import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart'
    show group, setUp, tearDown, test;
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/domain/adding/add_draft.dart';
import 'package:fujin/domain/adding/added_food.dart';
import 'package:fujin/domain/comparison/entry_status.dart';
import 'package:fujin/domain/editing/edit_opening.dart';
import 'package:fujin/domain/editing/edit_outcome.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

import '../../support/fake_backends.dart';
import '../../support/fixtures.dart';
import '../../support/repositories.dart';
import '../../support/write_services.dart';

const _hundredGrams = MfpServingSize(
  value: 100,
  unit: grams,
  nutritionMultiplier: 1,
);

final MfpFood _basmati = mfpFood(
  rice,
  description: 'Riz basmati',
  nutrients: nutrients(kcal: 350, protein: 8.5, carbs: 77, fat: 0.9),
);

final DateTime _dayBefore = day.subtract(const Duration(days: 1));

AddDraft _draft({
  double servings = 1.5,
  String meal = lunch,
  DateTime? date,
}) => AddDraft(
  food: _basmati,
  servingSize: _hundredGrams,
  servings: servings,
  mfpMealName: meal,
  date: date ?? day,
);

void main() {
  late FujinDatabase database;
  late FakeBackends backends;

  setUp(() {
    database = FujinDatabase.inMemory();
    final memoryRepository = memoryOf(database);
    memory.matches.forEach(memoryRepository.saveFood);
    memory.units.forEach(memoryRepository.saveUnit);
    memory.meals.forEach(memoryRepository.saveMeal);
    backends = FakeBackends(mfpFoods: [_basmati]);
  });

  tearDown(() => database.close());

  Future<(WriteServices, AddedFood)> added() async {
    final services = await WriteServices.over(backends, database);
    final food = await services.add(_draft());
    await services.settle();
    backends.requests.clear();
    return (services, food);
  }

  Future<EditOutcome> save(
    WriteServices services,
    AddedFood food,
    AddDraft draft,
  ) async {
    final outcome = services.editing.save(
      draft,
      await services.adding.plan(draft),
      entryId: food.entryId,
    );
    await services.settle();
    return outcome;
  }

  Iterable<double> ekkloQuantities() => [
    for (final meal in backends.ekkloMeals)
      for (final item in meal.items) item.quantity,
  ];

  String? mfpEntryIdOf(WriteServices services, String entryId) =>
      services.entries.find(entryId)?.mfpLink?.mfpEntryId;

  group('saving', () {
    test(
      'copies the entry in MyFitnessPal, removes the original, then updates '
      'the Ekklo quantity in place',
      () async {
        final (services, food) = await added();

        final outcome = await save(services, food, _draft(servings: 2));

        check(services.writes()).deepEquals([
          'POST ${mfpApiUri.host}',
          'DELETE ${mfpApiUri.host}',
          'PUT ${ekkloUri.host}',
        ]);
        final edited = (outcome as Edited).edited;
        check(edited)
          ..has((it) => it.toEkklo, 'to Ekklo').isTrue()
          ..has((it) => it.entryId, 'entry id').equals(food.entryId);
        check(backends.entries.single)
          ..has((it) => it.id, 'id').equals(
            mfpEntryIdOf(services, edited.entryId),
          )
          ..has((it) => it.servings, 'servings').equals(2);
        check(ekkloQuantities()).deepEquals([200]);
        check(
          services.entries.find(edited.entryId)?.ekkloLink?.item?.servings,
        ).equals(2);
        check(
          (await services.find(edited.entryId, day))?.status,
        ).isA<InEkklo>();
      },
    );

    test(
      'moves the Ekklo item to the new meal: removal, then append',
      () async {
        final (services, food) = await added();

        final outcome = await save(services, food, _draft(meal: breakfast));

        check(services.writes()).deepEquals([
          'POST ${mfpApiUri.host}',
          'DELETE ${mfpApiUri.host}',
          'DELETE ${ekkloUri.host}',
          'POST ${ekkloUri.host}',
        ]);
        final edited = (outcome as Edited).edited;
        check([
          for (final meal in backends.ekkloMeals)
            if (meal.items.isNotEmpty) meal.name,
        ]).deepEquals([petitDejeuner]);
        check(
          (await services.find(edited.entryId, day))?.status,
        ).isA<InEkklo>();
      },
    );

    test(
      'removes the Ekklo item before writing MyFitnessPal on a change of date',
      () async {
        final (services, food) = await added();

        final outcome = await save(services, food, _draft(date: _dayBefore));

        check(services.writes()).deepEquals([
          'DELETE ${ekkloUri.host}',
          'POST ${mfpApiUri.host}',
          'DELETE ${mfpApiUri.host}',
          'POST ${ekkloUri.host}',
        ]);
        final edited = (outcome as Edited).edited;
        check(backends.entries.single.date).equals(_dayBefore);
        check(services.entries.forDate(day).entries).isEmpty();
        check(
          (await services.find(edited.entryId, _dayBefore))?.status,
        ).isA<InEkklo>();
      },
    );

    test('writes only MyFitnessPal for an entry not in Ekklo yet', () async {
      backends.failingMeals.add(dejeuner);
      final first = await WriteServices.over(backends, database);
      final food = await first.add(_draft());
      await first.settle();
      final services = await WriteServices.over(backends, database);
      backends.requests.clear();

      final outcome = await save(services, food, _draft(servings: 2));

      check(services.writes()).deepEquals([
        'POST ${mfpApiUri.host}',
        'DELETE ${mfpApiUri.host}',
      ]);
      check(
        outcome,
      ).isA<Edited>().has((it) => it.edited.toEkklo, 'to Ekklo').isFalse();
    });

    test(
      'keeps the Fūjin id and moves its MyFitnessPal link to the copy',
      () async {
        final (services, food) = await added();
        final before = services.entries.find(food.entryId)?.mfpLink;

        await save(services, food, _draft(servings: 2));

        check(services.entries.entries()).length.equals(1);
        check(services.entries.forDate(day).entries.single)
          ..has((it) => it.entry.id, 'Fūjin id').equals(food.entryId)
          ..has((it) => it.entry.servings, 'servings').equals(2)
          ..has((it) => it.mfpLink?.id, 'link row').equals(before?.id)
          ..has(
            (it) => it.mfpLink?.mfpEntryId,
            'MyFitnessPal id',
          ).equals(backends.entries.single.id);
      },
    );

    test(
      'keeps the link on the edited entry when the meal holds the same food '
      'twice',
      () async {
        final (services, food) = await added();
        final unsent = entry(
          'mfp-unsent-rice',
          food: rice,
          meal: lunch,
          servings: 0.5,
          version: '1',
        );
        backends.entries = [unsent, ...backends.entries];

        final outcome = await save(services, food, _draft(servings: 2));

        final edited = (outcome as Edited).edited;
        final unsentId = services.entries
            .findByMfpEntryId(unsent.id ?? '')
            ?.entry
            .id;
        check(
          (await services.find(unsentId ?? '', day))?.status,
        ).isA<ToSend>();
        check(
          (await services.find(edited.entryId, day))?.status,
        ).isA<InEkklo>();
        check(ekkloQuantities()).deepEquals([200]);
      },
    );

    test(
      'saves an entry not yet in MyFitnessPal, and the writer then writes it '
      'once with the new values',
      () async {
        backends.mfpWritesFail = true;
        final services = await WriteServices.over(backends, database);
        final food = await services.add(_draft());
        await services.settle();

        final outcome = services.editing.save(
          _draft(servings: 2),
          await services.adding.plan(_draft(servings: 2)),
          entryId: food.entryId,
        );

        check(outcome).isA<Edited>();
        check(services.entries.find(food.entryId))
          ..has((it) => it?.entry.servings, 'servings').equals(2)
          ..has((it) => it?.mfpLink, 'link').isNull();

        backends
          ..mfpWritesFail = false
          ..requests.clear();
        await services.settle();

        check(
          services.writes().where((it) => it == 'POST ${mfpApiUri.host}'),
        ).length.equals(1);
        check(backends.entries.single.servings).equals(2);
        check(ekkloQuantities()).deepEquals([200]);
      },
    );
  });

  test(
    'puts the original values back on Annuler without reading MyFitnessPal',
    () async {
      final (services, food) = await added();
      final edited =
          ((await save(services, food, _draft(servings: 2))) as Edited).edited;
      backends.mfpReachable = false;

      final reverted = await services.editing.revert(edited);

      final back = (reverted as Edited).edited;
      check(back.entryId).equals(food.entryId);
      check(services.entries.find(food.entryId)?.entry.servings).equals(1.5);

      backends.mfpReachable = true;
      await services.settle();

      check(backends.entries.single)
        ..has((it) => it.id, 'id').equals(mfpEntryIdOf(services, back.entryId))
        ..has((it) => it.servings, 'servings').equals(1.5);
      check(ekkloQuantities()).deepEquals([150]);
      check((await services.find(back.entryId, day))?.status).isA<InEkklo>();
    },
  );

  test(
    'puts the entry back on its day on Annuler after a change of date',
    () async {
      final (services, food) = await added();
      final edited =
          ((await save(services, food, _draft(date: _dayBefore))) as Edited)
              .edited;

      final reverted = await services.editing.revert(edited);
      await services.settle();

      final back = (reverted as Edited).edited;
      check(back.entryId).equals(food.entryId);
      check(backends.entries.single)
        ..has((it) => it.id, 'id').equals(mfpEntryIdOf(services, back.entryId))
        ..has((it) => it.date, 'date').equals(day);
      check(ekkloQuantities()).deepEquals([150]);
      check(services.entries.forDate(_dayBefore).entries).isEmpty();
      check((await services.find(back.entryId, day))?.status).isA<InEkklo>();
    },
  );

  group('opening', () {
    test('drafts the logged serving and servings', () async {
      final services = await WriteServices.over(backends, database);
      final logged = loggedEntry(
        entry('e1', food: rice, servings: 2.5, version: '1'),
      );

      final opening = await services.editing.open(logged);

      check(opening).isA<Opened>().has((it) => it.draft, 'draft')
        ..has((it) => it.servings, 'servings').equals(2.5)
        ..has((it) => it.servingSize, 'serving').equals(_hundredGrams)
        ..has((it) => it.mfpMealName, 'meal').equals(breakfast);
    });

    test('says when the food has a newer version', () async {
      final services = await WriteServices.over(backends, database);

      final opening = await services.editing.open(
        loggedEntry(entry('e1', food: rice, version: '0')),
      );

      check(opening).isA<OpenedOnNewVersion>();
    });

    test('refuses a food MyFitnessPal does not give back', () async {
      final services = await WriteServices.over(backends, database);

      final opening = await services.editing.open(loggedEntry(entry('e1')));

      check(opening).isA<FoodUnreadable>();
    });

    test('refuses a serving the food no longer has', () async {
      final services = await WriteServices.over(backends, database);

      final opening = await services.editing.open(
        loggedEntry(entry('e1', food: rice, unit: cup, servingValue: 1)),
      );

      check(opening).isA<ServingMissing>();
    });
  });
}
