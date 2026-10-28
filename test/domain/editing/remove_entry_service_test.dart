import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart' show setUp, tearDown, test;
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/memory/memory_repository.dart';
import 'package:fujin/domain/adding/add_draft.dart';
import 'package:fujin/domain/adding/add_outcome.dart';
import 'package:fujin/domain/adding/added_food.dart';
import 'package:fujin/domain/comparison/entry_status.dart';
import 'package:fujin/domain/editing/edit_outcome.dart';
import 'package:fujin/domain/editing/remove_outcome.dart';
import 'package:fujin/domain/journal/read_problem.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

import '../../support/fake_backends.dart';
import '../../support/fixtures.dart';
import '../../support/write_services.dart';

final MfpFood _basmati = mfpFood(
  rice,
  description: 'Riz basmati',
  nutrients: nutrients(kcal: 350, protein: 8.5, carbs: 77, fat: 0.9),
);

AddDraft _draft() => AddDraft(
  food: _basmati,
  servingSize: const MfpServingSize(
    value: 100,
    unit: grams,
    nutritionMultiplier: 1,
  ),
  servings: 1.5,
  mfpMealName: lunch,
  date: day,
);

void main() {
  late FujinDatabase database;
  late FakeBackends backends;

  setUp(() {
    database = FujinDatabase.inMemory();
    final memoryRepository = MemoryRepository(database);
    memory.matches.forEach(memoryRepository.saveFood);
    memory.units.forEach(memoryRepository.saveUnit);
    memory.meals.forEach(memoryRepository.saveMeal);
    backends = FakeBackends(mfpFoods: [_basmati]);
  });

  tearDown(() => database.close());

  Future<(WriteServices, AddedFood)> added() async {
    final services = await WriteServices.over(backends, database);
    final outcome = await services.add(_draft());
    backends.requests.clear();
    return (services, (outcome as Added).added);
  }

  test('removes the Ekklo item, then the MyFitnessPal entry', () async {
    final (services, food) = await added();

    final outcome = await services.removing.remove(
      entryId: food.entryId,
      date: day,
    );

    check(
      outcome,
    ).isA<Removed>().has((it) => it.ekkloRemoved, 'Ekklo removed').isTrue();
    check(services.writes()).deepEquals([
      'DELETE ${ekkloUri.host}',
      'DELETE ${mfpApiUri.host}',
    ]);
    check(backends.entries).isEmpty();
    check(backends.ekkloMeals.expand((meal) => meal.items)).isEmpty();
    check(services.links.forDate(day)).isEmpty();
  });

  test('removes the Ekklo item of an entry to update', () async {
    final (services, food) = await added();
    backends.ekkloItemWritesFail = true;
    final draft = _draft().copyWith(servings: 2);
    final edit = await services.editing.save(
      draft,
      await services.adding.plan(draft),
      entryId: food.entryId,
      date: day,
    );
    final edited = (edit as EkkloNotUpdated).edited;
    backends.ekkloItemWritesFail = false;
    check(
      (await services.find(edited.entryId, day))?.status,
    ).isA<ToUpdate>();

    final outcome = await services.removing.remove(
      entryId: edited.entryId,
      date: day,
    );

    check(
      outcome,
    ).isA<Removed>().has((it) => it.ekkloRemoved, 'Ekklo removed').isTrue();
    check(backends.entries).isEmpty();
    check(backends.ekkloMeals.expand((meal) => meal.items)).isEmpty();
    check(services.links.forDate(day)).isEmpty();
  });

  test('removes once when asked twice at the same time', () async {
    final (services, food) = await added();

    await Future.wait([
      services.removing.remove(entryId: food.entryId, date: day),
      services.removing.remove(entryId: food.entryId, date: day),
    ]);

    check(services.writes()).deepEquals([
      'DELETE ${ekkloUri.host}',
      'DELETE ${mfpApiUri.host}',
    ]);
  });

  test(
    'leaves the entry to send when MyFitnessPal refuses, and a retry '
    'removes only the MyFitnessPal entry',
    () async {
      final (services, food) = await added();
      backends.mfpRemoveFails = true;

      final partial = await services.removing.remove(
        entryId: food.entryId,
        date: day,
      );

      check(partial).isA<StillInMfp>();
      check(backends.ekkloMeals.expand((meal) => meal.items)).isEmpty();
      check(services.links.forDate(day)).isEmpty();
      check(
        (await services.find(food.entryId, day))?.status,
      ).isA<ToSend>();

      backends
        ..mfpRemoveFails = false
        ..requests.clear();
      final retried = await services.removing.remove(
        entryId: food.entryId,
        date: day,
      );

      check(
        retried,
      ).isA<Removed>().has((it) => it.ekkloRemoved, 'Ekklo removed').isFalse();
      check(services.writes()).deepEquals(['DELETE ${mfpApiUri.host}']);
      check(backends.entries).isEmpty();
    },
  );

  test('removes nothing when Ekklo cannot be reached', () async {
    final (services, food) = await added();
    backends.ekkloReachable = false;

    final outcome = await services.removing.remove(
      entryId: food.entryId,
      date: day,
    );

    check(outcome)
        .isA<NotRemoved>()
        .has((it) => ReadProblem.of(it.error), 'problem')
        .equals(ReadProblem.offline);
    check(backends.entries).length.equals(1);
    check(backends.ekkloMeals.expand((meal) => meal.items)).length.equals(1);
  });

  test('removes nothing when Ekklo refuses the item removal', () async {
    final (services, food) = await added();
    backends.ekkloItemWritesFail = true;

    final outcome = await services.removing.remove(
      entryId: food.entryId,
      date: day,
    );

    check(outcome).isA<NotRemoved>();
    check(services.writes()).deepEquals(['DELETE ${ekkloUri.host}']);
    check(backends.entries).length.equals(1);
    check(
      (await services.find(food.entryId, day))?.status,
    ).isA<InEkklo>();
  });

  test('removes only the MyFitnessPal entry of a food not in Ekklo', () async {
    backends.failingMeals.add(dejeuner);
    final services = await WriteServices.over(backends, database);
    final failed = await services.add(_draft());
    backends.requests.clear();

    final outcome = await services.removing.remove(
      entryId: (failed as EkkloFailed).added.entryId,
      date: day,
    );

    check(
      outcome,
    ).isA<Removed>().has((it) => it.ekkloRemoved, 'Ekklo removed').isFalse();
    check(services.writes()).deepEquals(['DELETE ${mfpApiUri.host}']);
    check(backends.entries).isEmpty();
  });

  test('writes nothing for an entry already gone', () async {
    final (services, food) = await added();
    backends.entries = [];

    final outcome = await services.removing.remove(
      entryId: food.entryId,
      date: day,
    );

    check(outcome).isA<Removed>();
    check(services.writes()).isEmpty();
  });
}
