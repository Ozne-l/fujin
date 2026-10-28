import 'package:checks/checks.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter_test/flutter_test.dart'
    show group, setUp, tearDown, test;
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/memory/barcode_link.dart';
import 'package:fujin/data/memory/memory_repository.dart';
import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/domain/adding/add_draft.dart';
import 'package:fujin/domain/adding/add_outcome.dart';
import 'package:fujin/domain/adding/ekklo_side.dart';
import 'package:fujin/domain/adding/scan_outcome.dart';
import 'package:fujin/domain/comparison/entry_status.dart';
import 'package:fujin/domain/journal/read_problem.dart';
import 'package:fujin/domain/sending/own_copy_renewal.dart';
import 'package:fujin/domain/sending/send_choice.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

import '../../support/fake_backends.dart';
import '../../support/fixtures.dart';
import '../../support/write_services.dart';

const _gratin = 'mfp-gratin';
const _barcode = '3275760750398';
const _portion = 'portion';
const _hundredGrams = MfpServingSize(
  value: 100,
  unit: grams,
  nutritionMultiplier: 1,
);
const _onePot = MfpServingSize(value: 1, unit: pot, nutritionMultiplier: 1);

final MfpFood _basmati = mfpFood(
  rice,
  description: 'Riz basmati',
  brand: 'Taureau Ailé',
  nutrients: nutrients(kcal: 350, protein: 8.5, carbs: 77, fat: 0.9),
);
final MfpFood _skyr = mfpFood(
  skyr,
  description: 'Skyr nature',
  brand: 'Isey',
  servingSizes: const [_hundredGrams, _onePot],
  nutrients: nutrients(kcal: 64, protein: 10, carbs: 4, fat: 0.2),
);
final MfpFood _gratinFood = mfpFood(
  _gratin,
  description: 'Gratin dauphinois maison',
  version: '2',
  servingSizes: const [
    MfpServingSize(value: 1, unit: _portion, nutritionMultiplier: 1),
  ],
  nutrients: nutrients(kcal: 320, protein: 9, carbs: 25, fat: 20),
);

AddDraft _draft(
  MfpFood food, {
  MfpServingSize serving = _hundredGrams,
  double servings = 1.5,
  String meal = lunch,
}) => AddDraft(
  food: food,
  servingSize: serving,
  servings: servings,
  mfpMealName: meal,
  date: day,
);

void main() {
  late FujinDatabase database;
  late MemoryRepository memoryRepository;
  late FakeBackends backends;
  late DateTime clock;

  Future<WriteServices> writeServices({EkkloTokenStore? ekkloTokens}) =>
      WriteServices.over(
        backends,
        database,
        ekkloTokens: ekkloTokens,
        clock: () => clock,
      );

  setUp(() {
    database = FujinDatabase.inMemory();
    memoryRepository = MemoryRepository(database);
    memory.matches.forEach(memoryRepository.saveFood);
    memory.units.forEach(memoryRepository.saveUnit);
    memory.meals.forEach(memoryRepository.saveMeal);
    clock = now;
    backends = FakeBackends(mfpFoods: [_basmati, _skyr, _gratinFood]);
  });

  tearDown(() => database.close());

  group('adding', () {
    test(
      'writes MyFitnessPal first, then Ekklo, and links the entry',
      () async {
        final services = await writeServices();

        final outcome = await services.add(_draft(_basmati));

        check(services.writes()).deepEquals([
          'POST ${mfpApiUri.host}',
          'POST ${ekkloUri.host}',
        ]);
        final added = (outcome as Added).added;
        check(added)
          ..has((it) => it.ekkloWritten, 'Ekklo written').isTrue()
          ..has((it) => it.entry.mealName, 'meal').equals(lunch);
        check(backends.entries.single)
          ..has((it) => it.servings, 'servings').equals(1.5)
          ..has((it) => it.id, 'id').equals(added.entryId);
        check(backends.ekkloMeals.single)
          ..has((it) => it.name, 'meal').equals(dejeuner)
          ..has((it) => it.items.single.foodId, 'food').equals(riceInEkklo)
          ..has((it) => it.items.single.quantity, 'grams').equals(150);
        check((await services.find(added.entryId, day))?.status).isA<InEkklo>();
      },
    );

    test('adds once when the button is tapped twice', () async {
      final services = await writeServices();
      final draft = _draft(_basmati);
      final planned = await services.adding.plan(draft);

      await Future.wait([
        services.adding.add(draft, planned),
        services.adding.add(draft, planned),
      ]);

      check(backends.entries).length.equals(1);
      check(backends.ekkloItems).length.equals(1);
    });

    test(
      'writes nothing when the food changed in MyFitnessPal (06e)',
      () async {
        final changed = _basmati.copyWith(
          version: '2',
          nutrients: nutrients(kcal: 356, protein: 8.5, carbs: 78.5, fat: 0.9),
        );
        backends.mfpFoods = [changed];
        final services = await writeServices();

        final outcome = await services.add(_draft(_basmati));

        check(outcome).isA<FoodChanged>()
          ..has((it) => it.before.version, 'before').equals('1')
          ..has((it) => it.after, 'after').equals(changed);
        check(services.writes()).isEmpty();
        check(services.adding.recents()).isEmpty();
      },
    );

    test('checks the Ekklo session before writing MyFitnessPal', () async {
      final store = InMemoryEkkloTokenStore();
      await store.write(FakeBackends.staleEkkloTokens);
      final services = await writeServices(ekkloTokens: store);

      final outcome = await services.add(_draft(_basmati));

      check(outcome)
          .isA<NotAdded>()
          .has((it) => ReadProblem.of(it.error), 'problem')
          .equals(ReadProblem.ekkloSessionExpired);
      check(backends.entries).isEmpty();
    });

    test('writes nothing in Ekklo when MyFitnessPal refuses (06d)', () async {
      backends.mfpWritesFail = true;
      final services = await writeServices();

      final outcome = await services.add(_draft(_basmati));

      check(outcome)
          .isA<NotAdded>()
          .has((it) => ReadProblem.of(it.error), 'problem')
          .equals(ReadProblem.mfpUnavailable);
      check(backends.ekkloMeals).isEmpty();
      check(services.adding.recents()).isEmpty();
    });

    test(
      'keeps the MyFitnessPal entry when Ekklo fails and retries Ekklo only '
      '(06b)',
      () async {
        backends.failingMeals.add(dejeuner);
        final services = await writeServices();

        final failed = await services.add(_draft(_basmati));

        final added = (failed as EkkloFailed).added;
        check(added.ekkloWritten).isFalse();
        check((await services.find(added.entryId, day))?.status).isA<ToSend>();

        backends.failingMeals.clear();
        final retried = await services.adding.retryEkklo(added);

        check(retried)
            .isA<Added>()
            .has((it) => it.added.ekkloWritten, 'Ekklo written')
            .isTrue();
        check(backends.entries).length.equals(1);
        check(backends.ekkloItems).length.equals(1);
        check((await services.find(added.entryId, day))?.status).isA<InEkklo>();
      },
    );

    test('never writes Ekklo twice after a lost reply', () async {
      backends.lostReplies.add(dejeuner);
      final services = await writeServices();

      final failed = await services.add(_draft(_basmati));
      backends.lostReplies.clear();
      final retried = await services.adding.retryEkklo(
        (failed as EkkloFailed).added,
      );

      check(retried).isA<Added>();
      check(backends.ekkloItems).length.equals(1);
      check(
        (await services.find(failed.added.entryId, day))?.status,
      ).isA<InEkklo>();
    });

    test(
      'makes a new own copy when the remembered one has an older version',
      () async {
        memoryRepository.saveFood(
          const OwnCopy(
            mfpFoodId: _gratin,
            mfpDescription: 'Gratin dauphinois maison',
            ekkloFoodId: 'own-old',
            ekkloFoodName: 'Gratin dauphinois maison',
            mfpUnit: _portion,
            mfpFoodVersion: '1',
          ),
        );
        final services = await writeServices();
        final draft = _draft(
          _gratinFood,
          serving: _gratinFood.servingSizes.single,
          servings: 1,
        );
        final planned = await services.adding.plan(draft);

        check(planned.choice)
            .isA<SendAsOwnCopy>()
            .has((it) => it.renewal, 'renewal')
            .equals(OwnCopyRenewal.foodChanged);

        await services.adding.add(draft, planned);

        check(backends.ekkloItems.single.foodId).not(
          (it) => it.equals('own-old'),
        );
        check(
          memoryRepository.load().food(_gratin, _portion),
        ).isA<OwnCopy>().has((it) => it.mfpFoodVersion, 'version').equals('2');
      },
    );

    test('remembers the Ekklo food it found for the next add', () async {
      backends.ekkloSearches = {
        'skyr': [isey],
      };
      final services = await writeServices();
      final draft = _draft(_skyr, servings: 2);

      check(
        EkkloSide.of(await services.adding.plan(draft)),
      ).equals(EkkloSide.foundAutomatically);
      await services.add(draft);

      check(
        EkkloSide.of(await services.adding.plan(draft)),
      ).equals(EkkloSide.remembered);
      check(backends.ekkloItems.single)
        ..has((it) => it.foodId, 'food').equals(isey.id)
        ..has((it) => it.quantity, 'grams').equals(200);
    });
  });

  group('the Ekklo side of the fiche', () {
    test('names each case', () async {
      backends.ekkloSearches = {
        'skyr': [isey],
      };
      final services = await writeServices();

      final inPots = await services.adding.plan(
        _draft(_skyr, serving: _onePot),
      );
      final candidate = inPots.candidates.first;

      check({
        for (final (name, draft) in [
          ('rice', _draft(_basmati)),
          ('skyr', _draft(_skyr)),
          (
            'gratin',
            _draft(_gratinFood, serving: _gratinFood.servingSizes.single),
          ),
        ])
          name: EkkloSide.of(await services.adding.plan(draft)),
        'pots': EkkloSide.of(inPots),
        'chosen': EkkloSide.of(inPots.choose(candidate).weighing(150)),
      }).deepEquals({
        'rice': EkkloSide.remembered,
        'skyr': EkkloSide.foundAutomatically,
        'gratin': EkkloSide.willBeCreated,
        'pots': EkkloSide.toChoose,
        'chosen': EkkloSide.chosen,
      });
    });

    test(
      'keeps an estimated unit weight to choose until it is weighed',
      () async {
        backends.ekkloSearches = {
          'skyr': [isey],
        };
        final services = await writeServices();

        final inPots = await services.adding.plan(
          _draft(_skyr, serving: _onePot),
        );
        final picked = inPots.choose(inPots.candidates.first);

        check(EkkloSide.of(picked)).equals(EkkloSide.toChoose);
        check(EkkloSide.of(picked.weighing(150))).equals(EkkloSide.chosen);
      },
    );

    test(
      'follows a new number of portions without searching Ekklo again',
      () async {
        backends.ekkloSearches = {
          'skyr': [isey],
        };
        final services = await writeServices();
        final once = _draft(_skyr, serving: _onePot, servings: 1);
        final planned = await services.adding.plan(once);
        final chosen = planned.choose(planned.candidates.first).weighing(150);
        final requests = backends.requests.length;

        final twice = await services.adding.plan(
          once.copyWith(servings: 2),
          previous: chosen,
        );

        check(backends.requests).length.equals(requests);
        check(EkkloSide.of(twice)).equals(EkkloSide.chosen);
        check(
          twice.choice,
        ).isA<SendToEkkloFood>().has((it) => it.grams, 'grams').equals(300);
        check(twice.candidates.first.grams).isCloseTo(
          2 * planned.candidates.first.grams,
          1e-9,
        );
      },
    );
  });

  group('finding a food', () {
    test('lists the MyFitnessPal results that can be logged', () async {
      final unverified = mfpFood('mfp-rice-2', verified: false);
      final withoutServing = mfpFood('mfp-rice-3', servingSizes: const []);
      backends.mfpSearches = {
        'riz basmati': [_basmati, unverified, withoutServing],
      };
      final services = await writeServices();

      check(
        await services.adding.search('riz basmati', verifiedOnly: true),
      ).deepEquals([_basmati]);
      check(
        await services.adding.search('riz basmati', verifiedOnly: false),
      ).deepEquals([_basmati, unverified]);
    });
  });

  group('scanning a barcode', () {
    List<String> syncs() => [
      for (final request in backends.requests)
        if (request.url.host == mfpSyncUri.host) request.url.path,
    ];

    test('offers the MyFitnessPal food of the code', () async {
      backends.mfpBarcodes = {_barcode: _basmati};
      final services = await writeServices();

      check(await services.adding.scan(_barcode)).isA<ScanFound>()
        ..has((it) => it.food, 'food').equals(_basmati)
        ..has((it) => it.remembered, 'remembered').isFalse();
    });

    test(
      'offers the food linked to the code before asking MyFitnessPal',
      () async {
        backends.mfpBarcodes = {_barcode: _basmati};
        memoryRepository.saveBarcodeLink(
          const BarcodeLink(barcode: _barcode, mfpFoodId: skyr),
        );
        final services = await writeServices();

        check(await services.adding.scan(_barcode)).isA<ScanFound>()
          ..has((it) => it.food, 'food').equals(_skyr)
          ..has((it) => it.remembered, 'remembered').isTrue();
        check(syncs()).isEmpty();
      },
    );

    test('asks MyFitnessPal when the linked food is gone', () async {
      backends.mfpBarcodes = {_barcode: _basmati};
      memoryRepository.saveBarcodeLink(
        const BarcodeLink(barcode: _barcode, mfpFoodId: 'mfp-gone'),
      );
      final services = await writeServices();

      check(await services.adding.scan(_barcode)).isA<ScanFound>()
        ..has((it) => it.food, 'food').equals(_basmati)
        ..has((it) => it.remembered, 'remembered').isFalse();
    });

    test('names a code MyFitnessPal knows without a food card', () async {
      backends.mfpBarcodes = {
        _barcode: mfpFood(
          'mfp-unlisted',
          description: 'Riz basmati',
          brand: 'Taureau Ailé',
        ),
      };
      final services = await writeServices();

      check(await services.adding.scan(_barcode)).isA<ScanUnresolved>()
        ..has((it) => it.description, 'description').equals('Riz basmati')
        ..has((it) => it.brandName, 'brand').equals('Taureau Ailé');
    });

    test('treats a food card without serving size as no card', () async {
      final bare = mfpFood(rice, servingSizes: const []);
      backends
        ..mfpFoods = [bare]
        ..mfpBarcodes = {_barcode: bare};
      final services = await writeServices();

      check(await services.adding.scan(_barcode)).isA<ScanUnresolved>();
    });

    test('says when MyFitnessPal does not know the code', () async {
      final services = await writeServices();

      check(
        await services.adding.scan(_barcode),
      ).isA<ScanUnknown>().has((it) => it.barcode, 'barcode').equals(_barcode);
    });

    test('links the code to the food once it is in MyFitnessPal', () async {
      final services = await writeServices();
      final draft = _draft(_basmati);

      await services.adding.add(
        draft,
        await services.adding.plan(draft),
        barcodeToLink: _barcode,
      );

      check(memoryRepository.barcodeFood(_barcode)).equals(rice);
    });

    test('links nothing when MyFitnessPal refuses the add', () async {
      backends.mfpWritesFail = true;
      final services = await writeServices();
      final draft = _draft(_basmati);

      await services.adding.add(
        draft,
        await services.adding.plan(draft),
        barcodeToLink: _barcode,
      );

      check(memoryRepository.barcodeFood(_barcode)).isNull();
    });
  });

  group('recents', () {
    test('lists the foods added, newest first, once each', () async {
      final services = await writeServices();

      await services.add(_draft(_basmati));
      clock = now.add(const Duration(minutes: 1));
      await services.add(_draft(_skyr, serving: _onePot, servings: 2));
      clock = now.add(const Duration(minutes: 2));
      await services.add(_draft(_basmati, servings: 2));

      check([
        for (final recent in services.adding.recents())
          (recent.mfpFoodId, recent.servings),
      ]).deepEquals([(rice, 2.0), (skyr, 2.0)]);
    });

    test('reopens a recent food with its serving and portions', () async {
      final services = await writeServices();
      await services.add(_draft(_skyr, serving: _onePot, servings: 2));

      final draft = await services.adding.reopen(
        services.adding.recents().single,
        mfpMealName: breakfast,
        date: day,
      );

      check(draft).isNotNull()
        ..has((it) => it.servingSize, 'serving').equals(_onePot)
        ..has((it) => it.servings, 'servings').equals(2)
        ..has((it) => it.mfpMealName, 'meal').equals(breakfast)
        ..has((it) => it.entry.nutrients.energy?.value, 'kcal').equals(128);
    });
  });

  group('remembered foods', () {
    test('opens an own copy in its unit, one portion', () async {
      final services = await writeServices();
      const skyrInPots = OwnCopy(
        mfpFoodId: skyr,
        mfpDescription: 'Skyr nature',
        ekkloFoodId: 'own-skyr',
        ekkloFoodName: 'Skyr nature',
        mfpUnit: pot,
      );
      memoryRepository.saveFood(skyrInPots);

      final draft = await services.adding.openRemembered(
        skyrInPots,
        mfpMealName: breakfast,
        date: day,
      );

      check(draft).isNotNull()
        ..has((it) => it.food, 'food').equals(_skyr)
        ..has((it) => it.servingSize, 'serving').equals(_onePot)
        ..has((it) => it.servings, 'servings').equals(AddDraft.oneServing)
        ..has((it) => it.mfpMealName, 'meal').equals(breakfast);
    });

    test(
      'opens a matched food in the serving it was last added with',
      () async {
        final services = await writeServices();
        await services.add(_draft(_skyr, serving: _onePot, servings: 2));

        final draft = await services.adding.openRemembered(
          const MatchedFood(
            mfpFoodId: skyr,
            mfpDescription: 'Skyr nature',
            ekkloFoodId: 'isey',
            ekkloFoodName: 'Skyr nature 0 %',
          ),
          mfpMealName: lunch,
          date: day,
        );

        check(draft).isNotNull()
          ..has((it) => it.servingSize, 'serving').equals(_onePot)
          ..has((it) => it.servings, 'servings').equals(AddDraft.oneServing);
      },
    );

    test(
      'opens a food without a served remembered unit on its first serving',
      () async {
        final services = await writeServices();

        final draft = await services.adding.openRemembered(
          const MatchedFood(
            mfpFoodId: skyr,
            mfpDescription: 'Skyr nature',
            ekkloFoodId: 'isey',
            ekkloFoodName: 'Skyr nature 0 %',
          ),
          mfpMealName: lunch,
          date: day,
        );

        check(
              draft,
            )
            .isNotNull()
            .has((it) => it.servingSize, 'serving')
            .equals(_hundredGrams);
      },
    );
  });
}
