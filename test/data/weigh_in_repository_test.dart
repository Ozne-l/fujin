import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart' show setUp, tearDown, test;
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/database/fujin_table.dart';
import 'package:fujin/data/weigh_ins/weigh_in_repository.dart';

import '../support/fixtures.dart';
import '../support/repositories.dart';

void main() {
  final dayBefore = day.subtract(const Duration(days: 1));
  late FujinDatabase<FujinTable> database;
  late WeighInRepository weighIns;

  setUp(() {
    database = FujinDatabase.inMemory();
    weighIns = weighInsOf(database);
  });

  tearDown(() => database.close());

  test('corrects the live weigh-in of a day in place', () {
    final first = weighIns.save(date: day, kilograms: 68.9);

    final corrected = weighIns.save(date: day, kilograms: 69.3);

    check(corrected.id).equals(first.id);
    check([
      for (final logged in weighIns.listed()) logged.weighIn.kilograms,
    ]).deepEquals([69.3]);
  });

  test('saves a new weigh-in on a day whose weigh-in was deleted, and lists '
      'the newest day first, its live weigh-in before the deleted one still '
      'owed to MyFitnessPal', () {
    weighIns.save(date: dayBefore, kilograms: 69.4);
    final deleted = weighIns.save(date: day, kilograms: 68.9);
    weighIns
      ..linkMfp(deleted, measurementId: '101')
      ..remove(deleted.id);

    final saved = weighIns.save(date: day, kilograms: 68.7);

    check(saved.id).not((it) => it.equals(deleted.id));
    check([
      for (final logged in weighIns.listed())
        (
          logged.weighIn.date,
          logged.weighIn.kilograms,
          logged.weighIn.deletedAt == null,
        ),
    ]).deepEquals([
      (day, 68.7, true),
      (day, 68.9, false),
      (dayBefore, 69.4, true),
    ]);
    check(weighIns.find(deleted.id)?.weighIn.deletedAt).isNotNull();
  });
}
