import 'dart:async';
import 'dart:convert';

import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart'
    show group, setUp, tearDown, test;
import 'package:fujin/app/app_environment.dart';
import 'package:fujin/data/connectors/connector_roles.dart';
import 'package:fujin/data/connectors/role.dart';
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/entries/mfp_write.dart';
import 'package:fujin/data/foods/food_reference.dart';
import 'package:fujin/data/http/read_only_http_client.dart';
import 'package:fujin/data/memory/memory_repository.dart';
import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/domain/adding/add_draft.dart';
import 'package:fujin/domain/adding/added_food.dart';
import 'package:fujin/domain/comparison/compared_entry_lookup.dart';
import 'package:fujin/domain/comparison/entry_status.dart';
import 'package:fujin/domain/comparison/mfp_status.dart';
import 'package:fujin/domain/comparison/replacement.dart';
import 'package:fujin/domain/journal/fetch.dart';
import 'package:fujin/domain/sending/send_choice.dart';
import 'package:fujin/domain/sending/send_mode.dart';
import 'package:fujin/domain/sending/send_report.dart';
import 'package:fujin/domain/writing/ekklo_job.dart';
import 'package:fujin/domain/writing/write_failure.dart';
import 'package:fujin/domain/writing/writer_state.dart';
import 'package:fujin/pages/sending/send_failure.dart';
import 'package:http/http.dart' as http;
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

import '../../support/fake_backends.dart';
import '../../support/fixtures.dart';
import '../../support/repositories.dart';
import '../../support/write_services.dart';

const _gratin = 'mfp-gratin';
const _portion = 'portion';
const _onePortion = MfpServingSize(
  value: 1,
  unit: _portion,
  nutritionMultiplier: 1,
);
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
final MfpFood _gratinFood = mfpFood(
  _gratin,
  description: 'Gratin dauphinois maison',
  servingSizes: const [_onePortion],
  nutrients: nutrients(kcal: 320, protein: 9, carbs: 25, fat: 20),
);
final DateTime _nextDay = day.add(const Duration(days: 1));

AddDraft _draft({
  MfpFood? food,
  MfpServingSize serving = _hundredGrams,
  double servings = 1.5,
  String meal = lunch,
  DateTime? date,
}) => AddDraft(
  food: food ?? _basmati,
  servingSize: serving,
  servings: servings,
  mfpMealName: meal,
  date: date ?? day,
);

void main() {
  late FujinDatabase database;
  late MemoryRepository memoryRepository;
  late FakeBackends backends;
  late DateTime clock;

  setUp(() {
    database = FujinDatabase.inMemory();
    memoryRepository = memoryOf(database);
    memory.matches.forEach(memoryRepository.saveFood);
    memory.units.forEach(memoryRepository.saveUnit);
    memory.meals.forEach(memoryRepository.saveMeal);
    clock = now;
    backends = FakeBackends(mfpFoods: [_basmati, _gratinFood]);
  });

  tearDown(() => database.close());

  Future<WriteServices> services({
    http.Client? httpClient,
    ConnectorRoles Function()? roles,
  }) => WriteServices.over(
    backends,
    database,
    httpClient: httpClient,
    clock: () => clock,
    roles: roles,
  );

  Future<(WriteServices, AddedFood)> written([AddDraft? draft]) async {
    final writing = await services();
    final food = await writing.add(draft ?? _draft());
    await writing.settle();
    backends.requests.clear();
    return (writing, food);
  }

  Future<AddedFood> unwritten(WriteServices writing, AddDraft draft) async {
    backends.mfpReachable = false;
    final food = await writing.add(draft);
    await writing.settle();
    backends
      ..mfpReachable = true
      ..requests.clear();
    return food;
  }

  Iterable<http.Request> mfpAdds() => backends.requests.where(
    (request) => request.method == 'POST' && request.url.host == mfpApiUri.host,
  );

  Iterable<double> ekkloQuantities() => [
    for (final meal in backends.ekkloMeals)
      for (final item in meal.items) item.quantity,
  ];

  Future<void> sent(int count) async {
    while (mfpAdds().length < count) {
      await Future<void>.delayed(Duration.zero);
    }
  }

  String? mfpEntryIdOf(WriteServices writing, String entryId) =>
      writing.entries.find(entryId)?.mfpLink?.mfpEntryId;

  group('writing', () {
    test(
      'writes MyFitnessPal then Ekklo after an add, one at a time, oldest '
      'first',
      () async {
        final writing = await services();
        final first = await unwritten(writing, _draft());
        clock = clock.add(const Duration(seconds: 1));
        final second = await unwritten(writing, _draft(meal: breakfast));
        final writtenIds = <String>[];
        final listening = writing.background.states.listen((state) {
          if (state case WriterRunning(
            :final current?,
          ) when writtenIds.lastOrNull != current.entry.id) {
            writtenIds.add(current.entry.id);
          }
        });

        await writing.settle();
        await Future<void>.delayed(Duration.zero);
        await listening.cancel();

        check(writtenIds).deepEquals([first.entryId, second.entryId]);
        check(writing.writes()).deepEquals([
          'POST ${mfpApiUri.host}',
          'POST ${ekkloUri.host}',
          'POST ${mfpApiUri.host}',
          'POST ${ekkloUri.host}',
        ]);
        check([
          for (final request in mfpAdds())
            switch (jsonDecode(request.body)) {
              {'items': [{'meal_name': final String meal}]} => meal,
              _ => null,
            },
        ]).deepEquals([lunch, breakfast]);
        check(writing.background.state).isA<WriterIdle>();
        check(writing.background.state.failures).isEmpty();
        check(writing.entries.pendingMfp()).isEmpty();
      },
    );

    test(
      'runs once more when asked while running, never twice at once',
      () async {
        final writing = await services();
        final gate = backends.mfpAddGate = Completer<void>();
        final draft = _draft(meal: breakfast);
        final planned = await writing.adding.plan(draft);
        final first = await writing.add(_draft());
        await sent(1);

        clock = clock.add(const Duration(seconds: 1));
        final second = writing.adding.add(draft, planned);
        final runs = [writing.background.run(), writing.background.run()];
        await Future<void>.delayed(Duration.zero);

        check(mfpAdds()).length.equals(1);

        gate.complete();
        await Future.wait(runs);

        check(mfpAdds()).length.equals(2);
        check(backends.entries).length.equals(2);
        check(mfpEntryIdOf(writing, first.entryId)).isNotNull();
        check(mfpEntryIdOf(writing, second.entryId)).isNotNull();
        check(writing.entries.pendingMfp()).isEmpty();
      },
    );

    test('edits by copy then removal and moves the link', () async {
      final (writing, food) = await written();
      final before = writing.entries.find(food.entryId)?.mfpLink;

      writing.editing.save(
        _draft(servings: 2),
        await writing.adding.plan(_draft(servings: 2)),
        entryId: food.entryId,
      );
      await writing.settle();

      check(writing.writes()).deepEquals([
        'POST ${mfpApiUri.host}',
        'DELETE ${mfpApiUri.host}',
        'PUT ${ekkloUri.host}',
      ]);
      check(writing.entries.find(food.entryId)?.mfpLink).isNotNull()
        ..has<String?>((it) => it.id, 'link row').equals(before?.id)
        ..has((it) => it.servings, 'servings').equals(2)
        ..has<String?>((it) => it.mfpEntryId, 'MyFitnessPal id').equals(
          backends.entries.single.id,
        );
    });

    test('deletes in Ekklo then MyFitnessPal', () async {
      final (writing, food) = await written();

      writing.removing.remove(food.entryId);
      await writing.settle();

      check(writing.writes()).deepEquals([
        'DELETE ${ekkloUri.host}',
        'DELETE ${mfpApiUri.host}',
      ]);
      check(backends.entries).isEmpty();
      check(writing.entries.pendingMfp()).isEmpty();
    });

    test('keeps writing other entries after one fails', () async {
      final writing = await services();
      final lost = await unwritten(writing, _draft());
      clock = clock.add(const Duration(seconds: 1));
      final kept = await unwritten(
        writing,
        _draft(food: _gratinFood, serving: _onePortion, servings: 1),
      );
      backends.mfpFoods = [_gratinFood];

      await writing.settle();

      check(writing.background.state.failures.single)
          .isA<MfpNotWritten>()
          .has((it) => it.entryId, 'entry')
          .equals(lost.entryId);
      check(mfpEntryIdOf(writing, kept.entryId)).isNotNull();
      check(backends.entries.single.food.id).equals(_gratin);
    });

    test('drops a failure once its entry is no longer pending', () async {
      final writing = await services();
      final food = await unwritten(writing, _draft());
      check(writing.background.state.failures).length.equals(1);

      writing.removing.remove(food.entryId);
      await writing.settle();

      check(writing.background.state.failures).isEmpty();
    });

    test('writes nothing in Ekklo for a skipped plan', () async {
      final writing = await services();
      final draft = _draft(food: _gratinFood, serving: _onePortion);
      final planned = await writing.adding.plan(draft);

      final food = writing.adding.add(
        draft,
        planned.copyWith(choice: const SkipEntry()),
      );
      await writing.settle();

      check(writing.writes()).deepEquals(['POST ${mfpApiUri.host}']);
      check(writing.background.heldFor(food.entryId)).isNull();
      check(ekkloQuantities()).isEmpty();
    });

    test(
      'drops the held send of an add edited to a food left to choose',
      () async {
        final writing = await services();
        final gratin = _draft(food: _gratinFood, serving: _onePortion);
        final food = await unwritten(writing, gratin);
        final draft = gratin.copyWith(servings: 2);
        final planned = await writing.adding.plan(draft);

        writing.editing.save(
          draft,
          planned.copyWith(choice: const SkipEntry()),
          entryId: food.entryId,
        );
        await writing.settle();

        check(writing.background.heldFor(food.entryId)).isNull();
        check(writing.background.state.failures).isEmpty();
        check(writing.writes()).deepEquals(['POST ${mfpApiUri.host}']);
      },
    );

    test('drops a held send when the entry was deleted', () async {
      final writing = await services();
      final food = await unwritten(writing, _draft());
      writing.removing.remove(food.entryId);
      await writing.settle();
      backends.requests.clear();

      writing.background.hold(
        food.entryId,
        EkkloSend(await writing.adding.plan(_draft())),
      );
      await writing.settle();

      check(writing.background.heldFor(food.entryId)).isNull();
      check(writing.writes()).isEmpty();
      check(writing.background.state.failures).isEmpty();
    });

    test('reads a write blocked in Fūjin DEV as a failure', () async {
      final writing = await services(
        httpClient: ReadOnlyHttpClient(
          backends.httpClient,
          ekkloBaseUri: ekkloUri,
          mfpSyncUri: mfpSyncUri,
        ),
      );

      final food = await writing.add(_draft());
      await writing.settle();

      final error = writing.background.state.failures.single.error;
      check(
            writing.background.state.failures.single,
          )
          .isA<MfpNotWritten>()
          .has((it) => it.entryId, 'entry')
          .equals(
            food.entryId,
          );
      check(
        SendFailure.of(error, AppEnvironment.dev),
      ).equals(SendFailure.blockedInDev);
      check(backends.entries).isEmpty();
      check(ekkloQuantities()).isEmpty();
    });
  });

  group('deriving the Ekklo send', () {
    final gratin = _draft(food: _gratinFood, serving: _onePortion, servings: 1);

    test(
      'sends a remembered entry to Ekklo after its MyFitnessPal write, after '
      'a restart that held nothing',
      () async {
        final food = await unwritten(await services(), _draft());

        final restarted = await services();
        check(restarted.background.heldFor(food.entryId)).isNull();
        await restarted.settle();

        check(restarted.writes()).deepEquals([
          'POST ${mfpApiUri.host}',
          'POST ${ekkloUri.host}',
        ]);
        check(ekkloQuantities()).deepEquals([150]);
        check(
          (await restarted.find(food.entryId, day))?.status,
        ).isA<InEkklo>();
      },
    );

    test('leaves an entry Memory does not decide to send, with no Ekklo '
        'request', () async {
      backends.mfpFoods = [_gratinFood];
      final food = await unwritten(await services(), gratin);

      final restarted = await services();
      await restarted.settle();

      check(restarted.writes()).deepEquals(['POST ${mfpApiUri.host}']);
      check(
        backends.requests.where((request) => request.url.host == ekkloUri.host),
      ).isEmpty();
      check(restarted.background.heldFor(food.entryId)).isNull();
      check((await restarted.find(food.entryId, day))?.status).isA<ToSend>();
    });

    test('holds a derived send that failed, for the next run', () async {
      final food = await unwritten(await services(), _draft());
      backends.failingMeals.add(dejeuner);

      final restarted = await services();
      await restarted.settle();

      check(
        restarted.background.heldFor(food.entryId),
      ).isA<EkkloSend>();
      check(restarted.background.state.failures.single)
          .isA<EkkloNotWritten>()
          .has((it) => it.entryId, 'entry')
          .equals(food.entryId);

      backends.failingMeals.clear();
      await restarted.settle();

      check(restarted.background.heldFor(food.entryId)).isNull();
      check(ekkloQuantities()).deepEquals([150]);
    });
  });

  group('offline', () {
    test(
      'stops the run at the first network failure and keeps every entry '
      'pending',
      () async {
        final writing = await services();
        backends.mfpReachable = false;
        final first = await writing.add(_draft());
        clock = clock.add(const Duration(seconds: 1));
        final second = await writing.add(_draft(servings: 2));
        await writing.settle();
        backends.requests.clear();

        await writing.settle();

        check(backends.requests).length.equals(1);
        check(writing.background.state.failures.single)
          ..isA<MfpNotWritten>()
          ..has((it) => it.entryId, 'entry').equals(first.entryId);
        check([
          for (final write in writing.entries.pendingMfp())
            write.logged.entry.id,
        ]).unorderedEquals([first.entryId, second.entryId]);
      },
    );
  });

  group(
    'a row the MyFitnessPal app replaced, with no read before the write',
    () {
      List<MfpFoodEntry> replacedByTheApp() => [
        for (final row in backends.entries)
          row.copyWith(id: 'mfp-app', servings: 3),
      ];

      test('is replaced by Fūjin’s edit, one row left', () async {
        final (writing, food) = await written();
        backends.mfpReachable = false;
        writing.editing.save(
          _draft(servings: 2),
          await writing.adding.plan(_draft(servings: 2)),
          entryId: food.entryId,
        );
        await writing.settle();
        backends
          ..mfpReachable = true
          ..entries = replacedByTheApp();

        await writing.settle();

        check(backends.entries.single.servings).equals(2);
        check(writing.background.state.replaced.single).isA<ReplacedEdit>();
      });

      test('is removed under Fūjin’s deletion', () async {
        final (writing, food) = await written();
        backends
          ..mfpReachable = false
          ..ekkloReachable = false;
        writing.removing.remove(food.entryId);
        await writing.settle();
        backends
          ..mfpReachable = true
          ..ekkloReachable = true
          ..entries = replacedByTheApp();

        await writing.settle();

        check(backends.entries).isEmpty();
        check(
          writing.background.state.replaced.single,
        ).isA<ReplacedDeletion>();
      });
    },
  );

  test(
    'removes the Ekklo item of a deletion made offline before its '
    'MyFitnessPal row, and sends an add of the same food as a new item',
    () async {
      final (writing, food) = await written();
      final before = [for (final item in backends.ekkloItems) item.id];
      backends
        ..mfpReachable = false
        ..ekkloReachable = false;
      writing.removing.remove(food.entryId);
      clock = clock.add(const Duration(seconds: 1));
      final added = await writing.add(_draft(meal: breakfast));
      await writing.settle();
      backends
        ..mfpReachable = true
        ..ekkloReachable = true
        ..requests.clear();

      final restarted = await services();
      await restarted.journal.readDay(day);
      await restarted.settle();

      final writes = restarted.writes();
      check(
        writes.indexOf('DELETE ${ekkloUri.host}'),
      ).isLessThan(writes.indexOf('DELETE ${mfpApiUri.host}'));
      check(before).not((it) => it.contains(backends.ekkloItems.single.id));
      check(backends.entries.single.mealName).equals(breakfast);
      check(
        (await restarted.find(added.entryId, day))?.status,
      ).isA<InEkklo>();
    },
  );

  test(
    'removes the Ekklo item of a deletion made offline, after a restart',
    () async {
      final (writing, food) = await written();
      backends
        ..mfpReachable = false
        ..ekkloReachable = false;
      writing.removing.remove(food.entryId);
      await writing.settle();
      backends
        ..mfpReachable = true
        ..ekkloReachable = true;

      final restarted = await services();
      check(restarted.background.heldFor(food.entryId)).isNull();
      await restarted.settle();

      check(ekkloQuantities()).isEmpty();
      check(backends.entries).isEmpty();
      check(restarted.entries.pendingMfp()).isEmpty();
    },
  );

  test(
    'stops a run offline at the deletion of an entry already in Ekklo',
    () async {
      final (writing, food) = await written();
      clock = clock.add(const Duration(seconds: 1));
      backends
        ..mfpReachable = false
        ..ekkloReachable = false;
      await writing.add(_draft(meal: breakfast));
      await writing.settle();
      backends.requests.clear();

      writing.removing.remove(food.entryId);
      await writing.settle();

      check(writing.writes()).isEmpty();
      check({
        for (final request in backends.requests) request.url.path,
      }).deepEquals({'/v2/diary'});
      check(
        writing.background.state.failures.firstWhere(
          (failure) => failure.entryId == food.entryId,
        ),
      ).isA<MfpNotWritten>();
    },
  );

  group('a write stopped halfway', () {
    MfpFoodEntry row(String id, {double servings = 1.5, DateTime? date}) =>
        entry(
          id,
          food: rice,
          meal: lunch,
          servings: servings,
          version: '1',
          date: date ?? day,
        );

    test(
      'H1: links the row of an add killed before its link, without adding '
      'again, then sends its remembered Ekklo side',
      () async {
        final food = await unwritten(await services(), _draft());
        backends.entries = [row('mfp-written')];

        final restarted = await services();
        await restarted.settle();

        check(restarted.writes()).deepEquals(['POST ${ekkloUri.host}']);
        check(mfpEntryIdOf(restarted, food.entryId)).equals('mfp-written');
        check(restarted.entries.pendingMfp()).isEmpty();
        check(
          (await restarted.find(food.entryId, day))?.status,
        ).isA<InEkklo>();
      },
    );

    test('H1: a Journal read adopts that row the same way', () async {
      final food = await unwritten(await services(), _draft());
      backends.entries = [row('mfp-written')];

      final restarted = await services();
      final read = await restarted.journal.readDay(day);

      check(read.comparison.entryWithId(food.entryId)?.mfp).isNull();
      check(mfpEntryIdOf(restarted, food.entryId)).equals('mfp-written');
      check(restarted.entries.entries()).length.equals(1);
    });

    test(
      'H1: sends the remembered Ekklo side of a row a Journal read adopted '
      'first, and nothing for a row copied in',
      () async {
        final food = await unwritten(await services(), _draft());
        backends.entries = [row('mfp-written'), entry('app-row', version: '1')];

        final restarted = await services();
        final (:replaced, :adopted) = restarted.journal.settleDay(
          day,
          diary: await restarted.journal.fetchDiary(day),
          meals: await restarted.journal.fetchEkkloMeals(day),
        );
        restarted.background.settled(adopted: adopted, replaced: replaced);
        await restarted.settle();

        check(restarted.writes()).deepEquals(['POST ${ekkloUri.host}']);
        check(
          (await restarted.find(food.entryId, day))?.status,
        ).isA<InEkklo>();
      },
    );

    test(
      'H1b: adopts the row of an add whose reply was lost, then sends Ekklo',
      () async {
        final losing = _LosingMfpAdd(backends.httpClient);
        final writing = await services(httpClient: losing);
        final idle = <WriterIdle>[];
        WriterState? previous;
        final listening = writing.background.states.listen((state) {
          if ((previous, state) case (
            WriterRunning(),
            final WriterIdle ended,
          )) {
            idle.add(ended);
          }
          previous = state;
        });

        final food = await writing.add(_draft());
        await writing.settle();
        await Future<void>.delayed(Duration.zero);
        await listening.cancel();

        check(idle.first.failures.single).isA<MfpNotWritten>();
        check(idle.last.failures).isEmpty();

        check(mfpAdds()).length.equals(1);
        check(mfpEntryIdOf(writing, food.entryId)).equals(
          backends.entries.single.id,
        );
        check((await writing.find(food.entryId, day))?.status).isA<InEkklo>();
      },
    );

    test('H2: leaves an add killed before Ekklo to send', () async {
      backends.failingMeals.add(dejeuner);
      final (_, food) = await written();
      backends.failingMeals.clear();

      final restarted = await services();
      await restarted.settle();

      check(restarted.writes()).isEmpty();
      check((await restarted.find(food.entryId, day))?.status).isA<ToSend>();
    });

    test(
      'H3: removes the original of an edit whose copy was added, and links '
      'the copy',
      () async {
        final (writing, food) = await written();
        final stored = writing.entries.find(food.entryId);
        final original = stored?.mfpLink;
        if (stored case final stored?) {
          writing.entries.saveEntry(stored.entry.copyWith(servings: 2));
        }
        backends.entries = [
          ...backends.entries,
          row('mfp-copy', servings: 2),
        ];

        final restarted = await services();
        final read = await restarted.journal.readDay(day);

        check(restarted.entries.entries()).length.equals(1);
        check(
          read.comparison.entryWithId(food.entryId)?.mfp,
        ).isA<MfpPending>();

        backends.requests.clear();
        await restarted.settle();

        check(mfpAdds()).isEmpty();
        check(restarted.writes()).contains('DELETE ${mfpApiUri.host}');
        check(restarted.entries.find(food.entryId)?.mfpLink).isNotNull()
          ..has<String?>((it) => it.id, 'link row').equals(original?.id)
          ..has((it) => it.mfpEntryId, 'MyFitnessPal id').equals('mfp-copy');
        check([
          for (final entry in backends.entries) entry.id,
        ]).deepEquals(['mfp-copy']);
      },
    );

    test(
      'H3b: finishes an edit whose original MyFitnessPal refused to remove',
      () async {
        final (writing, food) = await written();
        final original = mfpEntryIdOf(writing, food.entryId);
        backends.mfpRemoveFails = true;

        writing.editing.save(
          _draft(servings: 2),
          await writing.adding.plan(_draft(servings: 2)),
          entryId: food.entryId,
        );
        await writing.settle();

        check(
          writing.background.state.failures.single,
        ).isA<MfpNotWritten>();
        check(backends.entries).length.equals(2);

        backends
          ..mfpRemoveFails = false
          ..requests.clear();
        await writing.background.run();

        check(mfpAdds()).isEmpty();
        check(backends.entries.single)
          ..has((it) => it.id, 'id').not((it) => it.equals(original))
          ..has((it) => it.servings, 'servings').equals(2);
        check(
          mfpEntryIdOf(writing, food.entryId),
        ).equals(backends.entries.single.id);
        check(ekkloQuantities()).deepEquals([200]);
      },
    );

    test(
      'H4: copies a change of date killed after the Ekklo removal, then '
      'sends its remembered Ekklo side on the new day',
      () async {
        final (writing, food) = await written();
        backends.mfpWritesFail = true;
        writing.editing.save(
          _draft(date: _nextDay),
          await writing.adding.plan(_draft(date: _nextDay)),
          entryId: food.entryId,
        );
        await writing.settle();
        check(ekkloQuantities()).isEmpty();
        backends
          ..mfpWritesFail = false
          ..requests.clear();

        final restarted = await services();
        await restarted.settle();

        check(restarted.writes()).deepEquals([
          'POST ${mfpApiUri.host}',
          'DELETE ${mfpApiUri.host}',
          'POST ${ekkloUri.host}',
        ]);
        check(backends.entries.single.date).equals(_nextDay);
        check(
          restarted.entries.find(food.entryId)?.mfpLink?.date,
        ).equals(_nextDay);
        check(
          (await restarted.find(food.entryId, _nextDay))?.status,
        ).isA<InEkklo>();
      },
    );

    test(
      'H4b: writes nothing in MyFitnessPal when Ekklo refuses the removal of '
      'a change of date',
      () async {
        final (writing, food) = await written();
        backends.ekkloItemWritesFail = true;

        writing.editing.save(
          _draft(date: _nextDay),
          await writing.adding.plan(_draft(date: _nextDay)),
          entryId: food.entryId,
        );
        await writing.settle();

        check(writing.writes().toSet()).deepEquals({'DELETE ${ekkloUri.host}'});
        check(writing.background.state.failures.single)
            .isA<EkkloNotWritten>()
            .has((it) => MfpWrite.of(it.logged), 'MyFitnessPal')
            .isA<MfpEdit>();

        backends
          ..ekkloItemWritesFail = false
          ..ekkloMeals = [];
        final restarted = await services();
        final read = await restarted.journal.readDay(_nextDay);

        check(
          read.comparison.entryWithId(food.entryId)?.status,
        ).isA<ToUpdate>();
        check(
          restarted.entries.find(food.entryId)?.ekkloLink?.item,
        ).isNotNull();
      },
    );

    test(
      'H5: forgets the link of a deletion killed after the MyFitnessPal '
      'removal',
      () async {
        backends.failingMeals.add(dejeuner);
        final (writing, food) = await written();
        writing.entries.remove(food.entryId);
        backends.entries = [];

        final restarted = await services();
        await restarted.settle();

        check(restarted.writes()).isEmpty();
        check(restarted.entries.pendingMfp()).isEmpty();
      },
    );

    test('H5: a Journal read forgets that link the same way', () async {
      backends.failingMeals.add(dejeuner);
      final (writing, food) = await written();
      writing.entries.remove(food.entryId);
      backends.entries = [];

      final restarted = await services();
      await restarted.journal.readDay(day);

      check(restarted.entries.pendingMfp()).isEmpty();
      check(
        restarted.entries.mfpLinks().where((link) => link.deletedAt == null),
      ).isEmpty();
    });

    test(
      'H6: removes from MyFitnessPal a deletion killed after the Ekklo '
      'removal',
      () async {
        final (writing, food) = await written();
        backends.mfpRemoveFails = true;
        writing.removing.remove(food.entryId);
        await writing.settle();
        check(ekkloQuantities()).isEmpty();
        backends
          ..mfpRemoveFails = false
          ..requests.clear();

        final restarted = await services();
        await restarted.settle();

        check(restarted.writes()).deepEquals(['DELETE ${mfpApiUri.host}']);
        check(backends.entries).isEmpty();
        check(restarted.entries.pendingMfp()).isEmpty();
      },
    );

    test('H7: removes an add undone while MyFitnessPal wrote it', () async {
      final writing = await services();
      final gate = backends.mfpAddGate = Completer<void>();
      final food = await writing.add(_draft());
      await sent(1);

      writing.removing.remove(food.entryId);
      gate.complete();
      await writing.settle();

      check(backends.entries).isEmpty();
      check(writing.entries.pendingMfp()).isEmpty();
      check(ekkloQuantities()).isEmpty();
    });

    test('H8: writes an edit saved while MyFitnessPal wrote the add', () async {
      final writing = await services();
      final gate = backends.mfpAddGate = Completer<void>();
      final planned = await writing.adding.plan(_draft(servings: 2));
      final food = await writing.add(_draft());
      await sent(1);

      writing.editing.save(_draft(servings: 2), planned, entryId: food.entryId);
      gate.complete();
      await writing.settle();

      check(backends.entries.single.servings).equals(2);
      check(writing.entries.entries()).length.equals(1);
      check(writing.entries.find(food.entryId)?.mfpLink).isNotNull()
        ..has((it) => it.servings, 'servings').equals(2)
        ..has<String?>((it) => it.mfpEntryId, 'MyFitnessPal id').equals(
          backends.entries.single.id,
        );
    });

    test(
      'H8b: sends an edit saved while Ekklo took the add, after it',
      () async {
        final holding = _HeldEkkloAppend(backends.httpClient);
        final writing = await services(httpClient: holding);
        final planned = await writing.adding.plan(_draft(servings: 2));
        final food = await writing.add(_draft());
        await holding.reached.future;

        writing.editing.save(
          _draft(servings: 2),
          planned,
          entryId: food.entryId,
        );
        holding.gate.complete();
        await writing.settle();

        check(writing.background.heldFor(food.entryId)).isNull();
        check(backends.entries.single.servings).equals(2);
        check(ekkloQuantities()).deepEquals([200]);
      },
    );

    test(
      'H9: writes the moved version and makes a new own copy of it',
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
        final writing = await services();
        final draft = _draft(
          food: _gratinFood,
          serving: _onePortion,
          servings: 1,
        );
        final planned = await writing.adding.plan(draft);
        check(planned.choice)
            .isA<SendAsOwnCopy>()
            .has((it) => it.reuse?.ekkloFoodId, 'reused')
            .equals('own-old');
        backends.mfpReachable = false;
        final food = writing.adding.add(draft, planned);
        await writing.settle();
        backends
          ..mfpReachable = true
          ..mfpFoods = [
            _gratinFood.copyWith(
              version: '2',
              nutrients: nutrients(kcal: 300, protein: 10, carbs: 25, fat: 18),
            ),
          ];

        await writing.settle();

        check(writing.entries.find(food.entryId)).isNotNull()
          ..has((it) => it.mfpLink?.foodVersion, 'version').equals('2')
          ..has(
            (it) => it.entry.nutrients.energyValue,
            'kcal',
          ).equals(300);
        check([
          for (final reference in foodsOf(database).references())
            if (reference is MfpReference && reference.externalId == _gratin)
              reference.version,
        ]).deepEquals(['2']);
        check(backends.ekkloItems.single.foodId).not(
          (it) => it.equals('own-old'),
        );
        check(
          memoryRepository.load().food(_gratin, _portion),
        ).isA<OwnCopy>().has((it) => it.mfpFoodVersion, 'version').equals('2');
      },
    );

    test(
      'H10: writes nothing when the moved version lost the serving',
      () async {
        final writing = await services();
        final food = await unwritten(writing, _draft());
        backends.mfpFoods = [
          _basmati.copyWith(version: '2', servingSizes: const [_onePortion]),
        ];

        await writing.settle();

        check(
          writing.background.state.failures.single,
        ).isA<MfpNotWritten>();
        check(writing.entries.pendingMfp().single)
            .isA<MfpAdd>()
            .has((it) => it.logged.entry.id, 'entry')
            .equals(food.entryId);
        check(mfpAdds()).isEmpty();
      },
    );

    test(
      'H11: keeps an entry linked after a diary read before its write',
      () async {
        final writing = await services();
        final food = await unwritten(writing, _draft());
        final diary = await writing.journal.fetchDiary(day);
        final meals = await writing.journal.fetchEkkloMeals(day);

        await writing.settle();
        writing.journal.settleDay(
          day,
          diary: Fetched(
            diary.value,
            readAt: diary.readAt.subtract(const Duration(minutes: 1)),
          ),
          meals: meals,
        );

        check(writing.entries.find(food.entryId)?.mfpLink?.mfpEntryId).equals(
          backends.entries.single.id,
        );
      },
    );
  });

  group('an entry sent from the send page before MyFitnessPal', () {
    Future<SendReport> sendDay(WriteServices writing) async =>
        writing.sending.send(
          await writing.sending.plan(day, onProgress: (_) {}),
          mode: SendMode.reviewed,
          onProgress: (_) {},
        );

    Future<void> idle() async {
      for (var turn = 0; turn < 100; turn++) {
        await Future<void>.delayed(Duration.zero);
      }
    }

    test('is not sent again by its held send run meanwhile', () async {
      final holding = _HeldEkkloAppend(backends.httpClient);
      final writing = await services(httpClient: holding);
      final food = await unwritten(writing, _draft());

      final manual = sendDay(writing);
      await holding.reached.future;
      final retried = writing.background.run();
      await sent(1);
      await idle();
      holding.gate.complete();
      await manual;
      await retried;

      check(backends.ekkloItems).length.equals(1);
      check(writing.background.heldFor(food.entryId)).isNull();
      check((await writing.find(food.entryId, day))?.status).isA<InEkklo>();
    });

    test('is not sent again while its held send runs', () async {
      final holding = _HeldEkkloAppend(backends.httpClient);
      final writing = await services(httpClient: holding);
      final food = await unwritten(writing, _draft());

      final retried = writing.background.run();
      await holding.reached.future;
      final manual = sendDay(writing);
      await idle();
      holding.gate.complete();
      await retried;
      await manual;

      check(backends.ekkloItems).length.equals(1);
      check(writing.background.heldFor(food.entryId)).isNull();
      check((await writing.find(food.entryId, day))?.status).isA<InEkklo>();
    });
  });

  group('MyFitnessPal in receive only', () {
    var roles = const ConnectorRoles(
      mfp: Role.receiveOnly,
      ekklo: Role.receiveOnly,
    );

    setUp(
      () => roles = const ConnectorRoles(
        mfp: Role.receiveOnly,
        ekklo: Role.receiveOnly,
      ),
    );

    Future<(WriteServices, AddedFood)> receiving() async {
      final writing = await services(roles: () => roles);
      final food = await writing.add(_draft());
      await writing.settle();
      backends.requests.clear();
      return (writing, food);
    }

    test('adds again a row deleted in the MyFitnessPal app', () async {
      final (writing, food) = await receiving();
      backends.entries = [];

      await writing.journal.readDay(day);
      await writing.settle();

      check(writing.entries.find(food.entryId)?.entry.deletedAt).isNull();
      check(mfpAdds()).length.equals(1);
      check([
        for (final row in backends.entries) row.food.id,
      ]).deepEquals([rice]);
      check(
        mfpEntryIdOf(writing, food.entryId),
      ).equals(backends.entries.single.id);
    });

    test('neither copies in nor removes a row logged only in the app, and '
        'copies it in once back in two-way', () async {
      final (writing, _) = await receiving();
      final appOnly = entry('A-1', food: skyr, meal: snacks);
      backends.entries = [...backends.entries, appOnly];

      await writing.journal.readDay(day);
      await writing.settle();

      check(writing.entries.findByMfpEntryId('A-1')).isNull();
      check(backends.entries).contains(appOnly);
      check(writing.writes()).isEmpty();

      roles = foodRoles;
      await writing.journal.readDay(day);

      check(
        writing.entries.findByMfpEntryId('A-1')?.mfpFoodId,
      ).equals(skyr);
    });
  });
}

final class _HeldEkkloAppend extends http.BaseClient {
  _HeldEkkloAppend(this._inner);

  final http.Client _inner;
  final reached = Completer<void>();
  final gate = Completer<void>();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if ((request.method, request.url.host, reached.isCompleted) case (
      'POST',
      final host,
      false,
    ) when host == ekkloUri.host) {
      reached.complete();
      await gate.future;
    }
    return _inner.send(request);
  }
}

final class _LosingMfpAdd extends http.BaseClient {
  _LosingMfpAdd(this._inner);

  final http.Client _inner;
  var _lost = false;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final response = await _inner.send(request);
    if ((request.method, request.url.host, request.url.path, _lost) case (
      'POST',
      final host,
      '/v2/diary',
      false,
    ) when host == mfpApiUri.host) {
      _lost = true;
      return http.StreamedResponse(const Stream.empty(), 503);
    }
    return response;
  }
}
