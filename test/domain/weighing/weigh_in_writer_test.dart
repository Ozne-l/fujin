import 'dart:async';

import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart'
    show group, setUp, tearDown, test;
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/database/fujin_table.dart';
import 'package:fujin/data/http/read_only_http_client.dart';
import 'package:fujin/data/milestones/milestone.dart';
import 'package:fujin/data/milestones/milestone_repository.dart';
import 'package:fujin/data/weigh_ins/logged_weigh_in.dart';
import 'package:fujin/data/weigh_ins/weigh_in_repository.dart';
import 'package:fujin/domain/weighing/weigh_in_failure.dart';
import 'package:fujin/domain/weighing/weigh_in_import.dart';
import 'package:fujin/domain/weighing/weigh_in_service.dart';
import 'package:fujin/domain/weighing/weigh_in_writer.dart';
import 'package:http/http.dart' as http;
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

import '../../support/fake_backends.dart';
import '../../support/fixtures.dart';
import '../../support/in_memory_preferences.dart';
import '../../support/repositories.dart';

const _measurements = '/v2/measurements';
const _ekkloWeights = '/api/v1/nutritions/weight-tracking';

final class _Weighing {
  _Weighing(this.writer, this.service, this.weighIns);

  final WeighInWriter writer;
  final WeighInService service;
  final WeighInRepository weighIns;

  Future<void> save(DateTime date, double kilograms) async {
    weighIns.save(date: date, kilograms: kilograms);
    await writer.run();
  }

  Future<void> remove(DateTime date) async {
    final logged = _live(weighIns).where((logged) {
      return logged.weighIn.date == date;
    }).single;
    weighIns.remove(logged.weighIn.id);
    await writer.run();
  }
}

List<LoggedWeighIn> _live(WeighInRepository weighIns) => [
  for (final logged in weighIns.listed())
    if (logged.weighIn.deletedAt == null) logged,
];

void main() {
  final dayBefore = day.subtract(const Duration(days: 1));
  final dayAfter = day.add(const Duration(days: 1));
  late FujinDatabase<FujinTable> database;
  late FakeBackends backends;

  setUp(() {
    database = FujinDatabase.inMemory();
    backends = FakeBackends();
  });

  tearDown(() => database.close());

  Future<_Weighing> started({
    Iterable<Milestone> reached = Milestone.values,
    http.Client? client,
  }) async {
    final mfp = backends.mfpWith(InMemoryMfpSessionStore(), client: client);
    await mfp.signIn(FakeBackends.mfpSession);
    final ekklo = backends.ekkloWith(
      await backends.ekkloTokenStore(),
      client: client,
    );
    final weighIns = weighInsOf(database);
    final writer = WeighInWriter(
      ekklo: ekklo,
      mfp: mfp,
      weighIns: weighIns,
      import: WeighInImport(
        ekklo: ekklo,
        weighIns: weighIns,
        milestones: MilestoneRepository(
          await inMemoryPreferences(reached: reached),
        ),
      ),
    );
    backends.requests.clear();
    return _Weighing(
      writer,
      WeighInService(weighIns: weighIns, writer: writer),
      weighIns,
    );
  }

  List<String> writes() => [
    for (final request in backends.requests)
      if (!ReadOnlyHttpClient.reads(request.method))
        '${request.method} ${request.url.path}',
  ];

  group('the import from Ekklo', () {
    test('stores the latest weight of each day, linked to Ekklo, then '
        'writes the history to MyFitnessPal oldest day first', () async {
      backends.ekkloWeights = [
        ekkloWeight('w-1', day, 68.94),
        ekkloWeight('w-2', day, 69.1, later: const Duration(minutes: 1)),
        ekkloWeight('w-3', dayBefore, 69.4),
      ];
      final weighing = await started(reached: const []);

      await weighing.writer.run();

      check([
        for (final logged in _live(weighing.weighIns))
          (logged.weighIn.kilograms, logged.ekkloLink?.kilograms),
      ]).deepEquals([(69.1, 69.1), (69.4, 69.4)]);
      check([
        for (final measurement in backends.mfpMeasurements)
          (measurement.date.day, measurement.value),
      ]).deepEquals([(dayBefore.day, 69.4), (day.day, 69.1)]);
      check(writes()).not((it) => it.contains('POST $_ekkloWeights'));
      check(weighing.writer.state.failures).isEmpty();
    });

    test('leaves the days Fujin holds, deleted ones included, and runs '
        'only once', () async {
      backends.ekkloWeights = [
        ekkloWeight('w-1', day, 70.1),
        ekkloWeight('w-2', dayBefore, 70.4),
      ];
      final weighIns = weighInsOf(database)..save(date: day, kilograms: 68.9);
      weighIns.remove(weighIns.save(date: dayBefore, kilograms: 69).id);
      final weighing = await started(reached: const []);

      await weighing.writer.run();
      backends.ekkloWeights = [
        ...backends.ekkloWeights,
        ekkloWeight('w-3', dayAfter, 70.8),
      ];
      await weighing.writer.run();

      check([
        for (final logged in _live(weighing.weighIns)) logged.weighIn.kilograms,
      ]).deepEquals([68.9]);
    });

    test('is tried again on the next run when Ekklo did not answer', () async {
      backends
        ..ekkloWeights = [ekkloWeight('w-1', day, 68.9)]
        ..ekkloReachable = false;
      final weighing = await started(reached: const []);

      await weighing.writer.run();
      backends.ekkloReachable = true;
      await weighing.writer.run();

      check(_live(weighing.weighIns)).length.equals(1);
    });
  });

  group('a saved weigh-in', () {
    test('is written to both apps and its links hold what was '
        'written', () async {
      final weighing = await started();

      weighing.service.save(date: day, kilograms: 68.94);
      await weighing.writer.run();

      final logged = _live(weighing.weighIns).single;
      check(logged.weighIn.kilograms).equals(68.9);
      check(logged.ekkloLink?.kilograms).equals(68.9);
      check(logged.mfpLink?.measurementId).equals(
        backends.mfpMeasurements.single.id,
      );
      check([
        for (final weight in backends.ekkloWeights) weight.kilograms,
      ]).deepEquals([68.9]);
      check(weighing.writer.state.failures).isEmpty();
    });

    test('adopts an equal MyFitnessPal weight instead of posting it '
        'again', () async {
      backends.mfpMeasurements = [mfpWeight('101', 68.92)];
      final weighing = await started();

      await weighing.save(day, 68.9);

      check(
        _live(weighing.weighIns).single.mfpLink?.measurementId,
      ).equals('101');
      check(writes()).not((it) => it.contains('POST $_measurements'));
    });

    test('replaces every other MyFitnessPal weight of the day, the hidden '
        'ones too', () async {
      backends.mfpMeasurements = [
        mfpWeight('101', 70),
        mfpWeight('102', 71),
        mfpWeight('103', 69, date: dayBefore),
      ];
      final weighing = await started();

      await weighing.save(day, 68.9);

      check([
        for (final measurement in backends.mfpMeasurements)
          (measurement.id, measurement.value),
      ]).deepEquals([
        ('103', 69),
        (_live(weighing.weighIns).single.mfpLink?.measurementId ?? '', 68.9),
      ]);
    });

    test('corrected replaces the value in both apps', () async {
      final weighing = await started();
      await weighing.save(day, 68.9);
      final first = backends.mfpMeasurements.single.id;

      await weighing.save(day, 69.3);

      final logged = _live(weighing.weighIns).single;
      check(backends.mfpMeasurements.single)
        ..has((it) => it.value, 'value').equals(69.3)
        ..has((it) => it.id, 'id').not((it) => it.equals(first));
      check(logged.mfpLink?.measurementId).equals(
        backends.mfpMeasurements.single.id,
      );
      check([
        for (final weight in backends.ekkloWeights) weight.kilograms,
      ]).deepEquals([69.3]);
    });
  });

  group('a deleted weigh-in', () {
    test('is deleted from MyFitnessPal and stays in Ekklo', () async {
      final weighing = await started();
      await weighing.save(day, 68.9);

      await weighing.remove(day);

      check(backends.mfpMeasurements).isEmpty();
      check(backends.ekkloWeights).length.equals(1);
      check(weighing.weighIns.pending()).isEmpty();
    });

    test('keeps its MyFitnessPal link when the deletion fails for another '
        'reason than a missing weight', () async {
      final weighing = await started();
      await weighing.save(day, 68.9);
      backends.mfpMeasurementWritesFail = true;

      await weighing.remove(day);

      check(
        weighing.writer.state.failures,
      ).single.isA<MfpWeightNotWritten>();
      check(
        weighing.weighIns.pending(),
      ).single.has((logged) => logged.mfpLink, 'mfpLink').isNotNull();
      check(backends.mfpMeasurements).length.equals(1);
    });

    test('is unlinked when its MyFitnessPal weight is already gone', () async {
      final weighing = await started();
      await weighing.save(day, 68.9);
      backends.mfpMeasurements = const [];

      await weighing.remove(day);

      check(weighing.writer.state.failures).isEmpty();
      check(weighing.weighIns.pending()).isEmpty();
    });

    test('then saved again on its day leaves one MyFitnessPal weight, the '
        'new one', () async {
      final weighing = await started();
      await weighing.save(day, 68.9);
      weighing.weighIns.remove(_live(weighing.weighIns).single.weighIn.id);

      await weighing.save(day, 68.9);

      check(backends.mfpMeasurements).length.equals(1);
      check(
        _live(weighing.weighIns).single.mfpLink?.measurementId,
      ).equals(backends.mfpMeasurements.single.id);
      check(weighing.weighIns.pending()).length.equals(1);
    });
  });

  group('a failed write', () {
    test('leaves the other app written and stops its app for the rest of '
        'the run', () async {
      final weighing = await started();
      backends.mfpMeasurementWritesFail = true;
      weighing.weighIns
        ..save(date: dayBefore, kilograms: 69.4)
        ..save(date: day, kilograms: 68.9);

      await weighing.writer.run();

      check(
            weighing.writer.state.failures,
          ).single
          .isA<MfpWeightNotWritten>()
          .has(
            (failure) => failure.weighIn.date,
            'date',
          )
          .equals(dayBefore);
      check(
        writes().where((write) => write == 'POST $_measurements'),
      ).length.equals(1);
      check(backends.ekkloWeights).length.equals(2);
    });

    test('is written on the next run and its failure cleared', () async {
      final weighing = await started();
      backends.ekkloWeightWritesFail = true;
      await weighing.save(day, 68.9);
      check(
        weighing.writer.state.failures,
      ).single.isA<EkkloWeightNotWritten>();

      backends.ekkloWeightWritesFail = false;
      await weighing.writer.run();

      check(weighing.writer.state.failures).isEmpty();
      check(
        _live(weighing.weighIns).single.ekkloLink?.kilograms,
      ).equals(68.9);
    });

    test('in Fujin DEV is a failure for each app, and the import still '
        'runs', () async {
      backends.ekkloWeights = [ekkloWeight('w-1', dayBefore, 69.4)];
      final weighing = await started(
        reached: const [],
        client: ReadOnlyHttpClient(
          backends.httpClient,
          ekkloBaseUri: ekkloUri,
          mfpSyncUri: mfpSyncUri,
        ),
      );

      await weighing.save(day, 68.9);

      check(_live(weighing.weighIns)).length.equals(2);
      check({
        for (final failure in weighing.writer.state.failures) failure.connector,
      }).length.equals(2);
      check(backends.mfpMeasurements).isEmpty();
      check(backends.ekkloWeights).length.equals(1);
    });
  });

  group('a run', () {
    test('reads each weigh-in again before writing it: one deleted meanwhile '
        'reaches neither app, one corrected meanwhile is written with its '
        'new value only', () async {
      late _Weighing weighing;
      weighing = await started(
        client: _Stepping(backends.httpClient, (request) async {
          if (request case http.Request(
            method: 'POST',
            url: Uri(path: _ekkloWeights),
          ) when backends.ekkloWeights.isEmpty) {
            final removed = _live(
              weighing.weighIns,
            ).singleWhere((logged) => logged.weighIn.date == day);
            weighing.weighIns
              ..remove(removed.weighIn.id)
              ..save(date: dayAfter, kilograms: 68.2);
          }
          return null;
        }),
      );
      weighing.weighIns
        ..save(date: dayBefore, kilograms: 69.4)
        ..save(date: day, kilograms: 68.9)
        ..save(date: dayAfter, kilograms: 68.5);

      await weighing.writer.run();

      check([
        for (final weight in backends.ekkloWeights) weight.kilograms,
      ]).unorderedEquals([69.4, 68.2]);
      check([
        for (final measurement in backends.mfpMeasurements) measurement.value,
      ]).unorderedEquals([69.4, 68.2]);
      check(writes().where((write) => write.startsWith('DELETE'))).isEmpty();
      check(weighing.writer.state.failures).isEmpty();
    });

    test('asked while one is running runs once more and writes what was '
        'saved meanwhile', () async {
      final held = _HeldEkkloWeight(backends.httpClient);
      final weighing = await started(client: held);
      weighing.weighIns.save(date: day, kilograms: 68.9);

      final first = weighing.writer.run();
      await held.reached.future;
      weighing.weighIns.save(date: dayAfter, kilograms: 68.5);
      final second = weighing.writer.run();
      held.gate.complete();
      await Future.wait([first, second]);

      check(backends.ekkloWeights).length.equals(2);
      check(backends.mfpMeasurements).length.equals(2);
    });

    test('stops writing a day to MyFitnessPal after ten reads that still '
        'hold another weight', () async {
      backends.mfpMeasurements = [mfpWeight('101', 70)];
      final weighing = await started(
        client: _Stepping(
          backends.httpClient,
          (request) async => switch (request) {
            http.Request(method: 'DELETE') => http.StreamedResponse(
              const Stream.empty(),
              204,
            ),
            _ => null,
          },
        ),
      );

      await weighing.save(day, 68.9);

      check(weighing.writer.state.failures).single
          .isA<MfpWeightNotWritten>()
          .has((failure) => failure.error, 'error')
          .isA<StateError>();
      check(
        backends.requests.where(
          (request) =>
              request.method == 'GET' && request.url.path == _measurements,
        ),
      ).length.equals(10);
      check(
        _live(weighing.weighIns).single.ekkloLink?.kilograms,
      ).equals(68.9);
    });
  });
}

final class _Stepping extends http.BaseClient {
  _Stepping(this._inner, this._step);

  final http.Client _inner;
  final Future<http.StreamedResponse?> Function(http.BaseRequest request) _step;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async =>
      await _step(request) ?? await _inner.send(request);
}

final class _HeldEkkloWeight extends http.BaseClient {
  _HeldEkkloWeight(this._inner);

  final http.Client _inner;
  final reached = Completer<void>();
  final gate = Completer<void>();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if ((request.method, request.url.path, reached.isCompleted) case (
      'POST',
      _ekkloWeights,
      false,
    )) {
      reached.complete();
      await gate.future;
    }
    return _inner.send(request);
  }
}
