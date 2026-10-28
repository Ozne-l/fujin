import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart'
    show group, setUp, tearDown, test;
import 'package:fujin/app/app_environment.dart';
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/http/read_only_http_client.dart';
import 'package:fujin/data/memory/memory_repository.dart';
import 'package:fujin/domain/adding/add_draft.dart';
import 'package:fujin/domain/adding/add_outcome.dart';
import 'package:fujin/domain/adding/added_food.dart';
import 'package:fujin/domain/comparison/entry_status.dart';
import 'package:fujin/domain/editing/edit_opening.dart';
import 'package:fujin/domain/editing/edit_outcome.dart';
import 'package:fujin/domain/editing/remove_outcome.dart';
import 'package:fujin/pages/sending/send_failure.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

import '../../support/fake_backends.dart';
import '../../support/fixtures.dart';
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

  Future<EditOutcome> save(
    WriteServices services,
    AddedFood food,
    AddDraft draft,
  ) async => services.editing.save(
    draft,
    await services.adding.plan(draft),
    entryId: food.entryId,
    date: food.entry.date,
  );

  Iterable<double> ekkloQuantities() => [
    for (final meal in backends.ekkloMeals)
      for (final item in meal.items) item.quantity,
  ];

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
          ..has((it) => it.ekkloWritten, 'Ekklo written').isTrue()
          ..has((it) => it.entryId, 'entry id').not(
            (it) => it.equals(food.entryId),
          );
        check(backends.entries.single)
          ..has((it) => it.id, 'id').equals(edited.entryId)
          ..has((it) => it.servings, 'servings').equals(2);
        check(ekkloQuantities()).deepEquals([200]);
        check(
          services.links.forDate(day).single.mfpEntryId,
        ).equals(edited.entryId);
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
        check(services.links.forDate(day)).isEmpty();
        check(
          (await services.find(edited.entryId, _dayBefore))?.status,
        ).isA<InEkklo>();
      },
    );

    test(
      'leaves the entry to send on its day when MyFitnessPal refuses a '
      'change of date after the Ekklo removal',
      () async {
        final (services, food) = await added();
        backends.mfpWritesFail = true;

        final outcome = await save(services, food, _draft(date: _dayBefore));

        check(outcome).isA<NotEdited>();
        check(ekkloQuantities()).isEmpty();
        check((await services.find(food.entryId, day))?.status).isA<ToSend>();
      },
    );

    test('writes only MyFitnessPal for an entry not in Ekklo yet', () async {
      backends.failingMeals.add(dejeuner);
      final services = await WriteServices.over(backends, database);
      final food = ((await services.add(_draft())) as EkkloFailed).added;
      backends.requests.clear();

      final outcome = await save(services, food, _draft(servings: 2));

      check(services.writes()).deepEquals([
        'POST ${mfpApiUri.host}',
        'DELETE ${mfpApiUri.host}',
      ]);
      check(outcome)
          .isA<Edited>()
          .has((it) => it.edited.ekkloWritten, 'Ekklo written')
          .isFalse();
    });

    test('writes nothing when the food changed in MyFitnessPal', () async {
      final (services, food) = await added();
      final newer = mfpFood(rice, description: 'Riz basmati', version: '2');
      backends.mfpFoods = [newer];

      final outcome = await save(services, food, _draft(servings: 2));

      check(outcome)
          .isA<EditFoodChanged>()
          .has((it) => it.after.version, 'version')
          .equals('2');
      check(services.writes()).isEmpty();
    });

    test('writes nothing more when MyFitnessPal refuses the copy', () async {
      final (services, food) = await added();
      backends.mfpWritesFail = true;

      final outcome = await save(services, food, _draft(servings: 2));

      check(outcome).isA<NotEdited>();
      check(services.writes()).deepEquals(['POST ${mfpApiUri.host}']);
      check(backends.entries.single.id).equals(food.entryId);
      check(
        (await services.find(food.entryId, day))?.status,
      ).isA<InEkklo>();
    });

    test('saves once when Enregistrer is tapped twice', () async {
      final (services, food) = await added();
      final draft = _draft(servings: 2);
      final planned = await services.adding.plan(draft);

      await Future.wait([
        for (var tap = 0; tap < 2; tap++)
          services.editing.save(
            draft,
            planned,
            entryId: food.entryId,
            date: day,
          ),
      ]);

      check(
        services.writes().where((write) => write == 'POST ${mfpApiUri.host}'),
      ).length.equals(1);
    });
  });

  group('a save stopped halfway', () {
    test(
      'keeps both entries when MyFitnessPal refuses the removal, and finish '
      'removes the original without a second copy',
      () async {
        final (services, food) = await added();
        backends.mfpRemoveFails = true;

        final outcome = await save(services, food, _draft(servings: 2));

        final edited = (outcome as OldEntryKept).edited;
        check(backends.entries).length.equals(2);
        check(
          (await services.find(food.entryId, day))?.status,
        ).isA<InEkklo>();
        check(
          (await services.find(edited.entryId, day))?.status,
        ).isA<ToSend>();

        backends
          ..mfpRemoveFails = false
          ..requests.clear();
        final finished = await services.editing.finish(edited);
        final again = await services.editing.finish(edited);

        check(finished).isA<Edited>();
        check(again).isA<Edited>();
        check(services.writes()).deepEquals([
          'DELETE ${mfpApiUri.host}',
          'PUT ${ekkloUri.host}',
        ]);
        check(backends.entries.single.id).equals(edited.entryId);
        check(ekkloQuantities()).deepEquals([200]);
      },
    );

    test(
      'leaves the copy to update when Ekklo refuses, and a retry writes only '
      'Ekklo',
      () async {
        final (services, food) = await added();
        backends.ekkloItemWritesFail = true;

        final outcome = await save(services, food, _draft(servings: 2));

        final edited = (outcome as EkkloNotUpdated).edited;
        check(
          (await services.find(edited.entryId, day))?.status,
        ).isA<ToUpdate>();
        check(ekkloQuantities()).deepEquals([150]);

        backends
          ..ekkloItemWritesFail = false
          ..requests.clear();
        final retried = await services.editing.retryEkklo(edited);

        check(retried).isA<Edited>();
        check(services.writes()).deepEquals(['PUT ${ekkloUri.host}']);
        check(ekkloQuantities()).deepEquals([200]);
        check(
          services.links.forDate(day).single.mfpEntryId,
        ).equals(edited.entryId);
      },
    );
  });

  test('puts the original values back on Annuler', () async {
    final (services, food) = await added();
    final edited =
        ((await save(services, food, _draft(servings: 2))) as Edited).edited;

    final reverted = await services.editing.revert(edited);

    final back = (reverted as Edited).edited;
    check(backends.entries.single)
      ..has((it) => it.id, 'id').equals(back.entryId)
      ..has((it) => it.servings, 'servings').equals(1.5);
    check(ekkloQuantities()).deepEquals([150]);
    check((await services.find(back.entryId, day))?.status).isA<InEkklo>();
  });

  test(
    'sends to the new day on a retry after a change of date, and writes '
    'nothing on a second retry',
    () async {
      final (services, food) = await added();
      backends.failingMeals.add(dejeuner);
      final outcome = await save(services, food, _draft(date: _dayBefore));
      final edited = (outcome as EkkloNotUpdated).edited;
      backends
        ..failingMeals.clear()
        ..requests.clear();

      final retried = await services.editing.retryEkklo(edited);
      final again = await services.editing.retryEkklo(edited);

      check(retried).isA<Edited>();
      check(again).isA<Edited>();
      check(services.writes()).deepEquals(['POST ${ekkloUri.host}']);
      check(ekkloQuantities()).deepEquals([150]);
      check(services.links.forDate(day)).isEmpty();
      check(
        services.links.forDate(_dayBefore).single.mfpEntryId,
      ).equals(edited.entryId);
    },
  );

  test('writes nothing on Annuler when the food is unreadable', () async {
    final (services, food) = await added();
    final edited =
        ((await save(services, food, _draft(servings: 2))) as Edited).edited;
    backends
      ..mfpFoods = []
      ..requests.clear();

    final reverted = await services.editing.revert(edited);

    check(reverted).isA<NotEdited>();
    check(services.writes()).isEmpty();
    check(backends.entries.single.servings).equals(2);
    check(ekkloQuantities()).deepEquals([200]);
  });

  test(
    'puts the entry back on its day on Annuler after a change of date',
    () async {
      final (services, food) = await added();
      final edited =
          ((await save(services, food, _draft(date: _dayBefore))) as Edited)
              .edited;

      final reverted = await services.editing.revert(edited);

      final back = (reverted as Edited).edited;
      check(backends.entries.single)
        ..has((it) => it.id, 'id').equals(back.entryId)
        ..has((it) => it.date, 'date').equals(day);
      check(ekkloQuantities()).deepEquals([150]);
      check(services.links.forDate(_dayBefore)).isEmpty();
      check((await services.find(back.entryId, day))?.status).isA<InEkklo>();
    },
  );

  test(
    'pairs the orphan link with the first unlinked rice of the meal when the '
    'meal holds the same food twice',
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
      check(
        (await services.find(unsent.id ?? '', day))?.status,
      ).isA<ToUpdate>();
      check(
        (await services.find(edited.entryId, day))?.status,
      ).isA<InEkklo>();
      check(ekkloQuantities()).deepEquals([150, 200]);
    },
  );

  group('opening', () {
    test('drafts the logged serving and servings', () async {
      final services = await WriteServices.over(backends, database);
      final logged = entry('e1', food: rice, servings: 2.5, version: '1');

      final opening = await services.editing.open(logged);

      check(opening).isA<Opened>().has((it) => it.draft, 'draft')
        ..has((it) => it.servings, 'servings').equals(2.5)
        ..has((it) => it.servingSize, 'serving').equals(_hundredGrams)
        ..has((it) => it.mfpMealName, 'meal').equals(breakfast);
    });

    test('says when the food has a newer version', () async {
      final services = await WriteServices.over(backends, database);

      final opening = await services.editing.open(
        entry('e1', food: rice, version: '0'),
      );

      check(opening).isA<OpenedOnNewVersion>();
    });

    test('refuses a food MyFitnessPal does not give back', () async {
      final services = await WriteServices.over(backends, database);

      final opening = await services.editing.open(entry('e1'));

      check(opening).isA<FoodUnreadable>();
    });

    test('refuses a serving the food no longer has', () async {
      final services = await WriteServices.over(backends, database);

      final opening = await services.editing.open(
        entry('e1', food: rice, unit: cup, servingValue: 1),
      );

      check(opening).isA<ServingMissing>();
    });
  });

  group('in Fujin DEV', () {
    Future<(WriteServices, AddedFood)> readOnly() async {
      final (_, food) = await added();
      final services = await WriteServices.over(
        backends,
        database,
        httpClient: ReadOnlyHttpClient(
          backends.httpClient,
          ekkloBaseUri: ekkloUri,
          mfpSyncUri: mfpSyncUri,
        ),
      );
      return (services, food);
    }

    test('an edit writes nothing and reads as blocked', () async {
      final (services, food) = await readOnly();
      final before = backends.entries;

      final outcome = await save(services, food, _draft(servings: 2));

      final error = (outcome as NotEdited).error;
      check(backends.entries).deepEquals(before);
      check(ekkloQuantities()).deepEquals([150]);
      check(
        SendFailure.of(error, AppEnvironment.dev),
      ).equals(SendFailure.blockedInDev);
      check(
        SendFailure.of(error, AppEnvironment.production),
      ).not((it) => it.equals(SendFailure.blockedInDev));
    });

    test('a removal writes nothing and reads as blocked', () async {
      final (services, food) = await readOnly();

      final outcome = await services.removing.remove(
        entryId: food.entryId,
        date: day,
      );

      check(
        SendFailure.of((outcome as NotRemoved).error, AppEnvironment.dev),
      ).equals(SendFailure.blockedInDev);
      check(backends.entries).length.equals(1);
      check(ekkloQuantities()).deepEquals([150]);
    });
  });
}
