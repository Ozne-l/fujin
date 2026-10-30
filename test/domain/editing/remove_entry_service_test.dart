import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart' show setUp, tearDown, test;
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/entries/ekklo_link.dart';
import 'package:fujin/data/entries/mfp_write.dart';
import 'package:fujin/domain/adding/add_draft.dart';
import 'package:fujin/domain/adding/added_food.dart';
import 'package:fujin/domain/writing/ekklo_job.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

import '../../support/fake_backends.dart';
import '../../support/fixtures.dart';
import '../../support/repositories.dart';
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

Iterable<EkkloLink> _liveEkkloLinks(WriteServices services) =>
    services.entries.ekkloLinks().where((link) => link.deletedAt == null);

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

  test('soft-deletes the entry and owes its MyFitnessPal deletion', () async {
    final (services, food) = await added();

    final removed = services.removing.remove(food.entryId);

    check(
      removed,
    ).isNotNull().has((it) => it.entry.entry.id, 'entry').equals(food.entryId);
    check(services.entries.find(food.entryId)).isNull();
    check(services.entries.pendingMfp().single).isA<MfpDeletion>();

    await services.settle();

    check(services.writes()).deepEquals([
      'DELETE ${ekkloUri.host}',
      'DELETE ${mfpApiUri.host}',
    ]);
    check(backends.entries).isEmpty();
    check(backends.ekkloItems).isEmpty();
    check(services.entries.pendingMfp()).isEmpty();
    check(_liveEkkloLinks(services)).isEmpty();
  });

  test('holds the Ekklo removal of a linked item', () async {
    final (services, food) = await added();
    final item = services.entries.find(food.entryId)?.ekkloLink?.item;
    backends.ekkloReachable = false;

    services.removing.remove(food.entryId);
    await services.settle();

    check(
      services.background.heldFor(food.entryId),
    ).isA<EkkloRemoval>().has((it) => it.link.item, 'item').equals(item);
  });

  test('removes only the MyFitnessPal entry of a food not in Ekklo', () async {
    backends.failingMeals.add(dejeuner);
    final services = await WriteServices.over(backends, database);
    final food = await services.add(_draft());
    await services.settle();
    backends.requests.clear();

    services.removing.remove(food.entryId);
    await services.settle();

    check(services.writes()).deepEquals(['DELETE ${mfpApiUri.host}']);
    check(backends.entries).isEmpty();
  });

  test('forgets an unwritten add entirely', () async {
    backends.mfpWritesFail = true;
    final services = await WriteServices.over(backends, database);
    final food = await services.add(_draft());
    await services.settle();
    backends
      ..mfpWritesFail = false
      ..requests.clear();

    services.removing.remove(food.entryId);
    await services.settle();

    check(services.entries.pendingMfp()).isEmpty();
    check(services.background.heldFor(food.entryId)).isNull();
    check(services.background.state.failures).isEmpty();
    check(services.writes()).isEmpty();
    check(backends.entries).isEmpty();
  });

  test('returns nothing for an entry already gone', () async {
    final (services, food) = await added();
    services.removing.remove(food.entryId);
    await services.settle();
    backends.requests.clear();

    check(services.removing.remove(food.entryId)).isNull();
    await services.settle();
    check(services.writes()).isEmpty();
  });
}
