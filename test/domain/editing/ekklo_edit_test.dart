import 'package:checks/checks.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter_test/flutter_test.dart' show group, test;
import 'package:fujin/data/links/sent_link.dart';
import 'package:fujin/domain/adding/add_draft.dart';
import 'package:fujin/domain/comparison/compared_entry.dart';
import 'package:fujin/domain/comparison/entry_status.dart';
import 'package:fujin/domain/comparison/update_kind.dart';
import 'package:fujin/domain/editing/draft_changes.dart';
import 'package:fujin/domain/editing/ekklo_edit.dart';
import 'package:fujin/domain/sending/planned_entry.dart';
import 'package:fujin/domain/sending/send_choice.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

import '../../support/fixtures.dart';

const _itemId = 'item-1';
const _mealId = 'meal-1';
const _riceName = 'Riz basmati';

final MfpFoodEntry _logged = entry('e1', food: rice, meal: lunch);
final SentLink _link = link('e1', _itemId, food: rice, meal: lunch);

PlannedEntry _planned({
  String ekkloMeal = dejeuner,
  String ekkloFood = riceInEkklo,
  DateTime? date,
  double servings = 2,
}) => PlannedEntry(
  entry: _logged.copyWith(servings: servings, date: date ?? day),
  entryId: AddDraft.pendingEntryId,
  ekkloMealName: ekkloMeal,
  choice: SendToEkkloFood(
    ekkloFoodId: ekkloFood,
    ekkloFoodName: ekkloFood,
    grams: servings * 100,
    remembered: true,
  ),
  reviewed: true,
);

EkkloEdit _edit(
  PlannedEntry planned, {
  EntryStatus? status,
  bool changed = true,
  bool itemThere = true,
  EkkloFood? itemFood,
}) => EkkloEdit.of(
  original: ComparedEntry(_logged, status ?? InEkklo(_link)),
  planned: planned,
  ekkloMeals: [
    meal(_mealId, [
      if (itemThere) item(_itemId, food: riceInEkklo).copyWith(food: itemFood),
    ], name: dejeuner),
  ],
  changed: changed,
);

void main() {
  group('the Ekklo side of an edit', () {
    test('is already in Ekklo when nothing changed', () {
      check(_edit(_planned(), changed: false)).isA<AlreadyInEkklo>();
    });

    test('updates the quantity in place on the same meal and day', () {
      check(
        _edit(_planned()),
      ).isA<QuantityInPlace>().has((it) => it.from.id, 'item').equals(_itemId);
    });

    test('settles a pending update even when the fiche changed nothing', () {
      check(
        _edit(
          _planned(),
          status: ToUpdate(_link, UpdateKind.quantityOnly),
          changed: false,
        ),
      ).isA<QuantityInPlace>();
    });

    test('moves the item when the Ekklo meal changes', () {
      check(
        _edit(_planned(ekkloMeal: petitDejeuner)),
      ).isA<MealMove>().has((it) => it.from, 'from').equals(dejeuner);
    });

    test('moves the item when the day changes', () {
      final before = day.subtract(const Duration(days: 1));

      check(_edit(_planned(date: before))).isA<DayMove>()
        ..has((it) => it.from, 'from').equals(day)
        ..has((it) => it.to, 'to').equals(before);
    });

    test('names the Ekklo food it replaces', () {
      check(
        _edit(
          _planned(ekkloFood: oatsInEkklo),
          itemFood: ekkloFood(riceInEkklo, name: _riceName),
        ),
      ).isA<Replaced>().has((it) => it.before, 'before').equals(_riceName);
    });

    test('has no name for a replaced item Ekklo gives without its food', () {
      check(
        _edit(_planned(ekkloFood: oatsInEkklo)),
      ).isA<Replaced>().has((it) => it.before, 'before').isNull();
    });

    test('is not in Ekklo yet for an entry to send', () {
      check(_edit(_planned(), status: const ToSend())).isA<NotInEkkloYet>();
    });

    test('is not in Ekklo yet when the linked item is gone', () {
      check(_edit(_planned(), itemThere: false)).isA<NotInEkkloYet>();
    });
  });

  group('a draft', () {
    AddDraft draft({
      double servings = 1,
      String meal = lunch,
      DateTime? date,
      MfpServingSize serving = const MfpServingSize(value: 100, unit: grams),
    }) => AddDraft(
      food: mfpFood(rice),
      servingSize: serving,
      servings: servings,
      mfpMealName: meal,
      date: date ?? day,
    );

    test('changes nothing with the logged values', () {
      check(draftChanges(draft(), _logged)).isFalse();
    });

    test('changes the entry with another quantity, meal, day or serving', () {
      check([
        draftChanges(draft(servings: 2), _logged),
        draftChanges(draft(meal: breakfast), _logged),
        draftChanges(
          draft(date: day.subtract(const Duration(days: 1))),
          _logged,
        ),
        draftChanges(
          draft(serving: const MfpServingSize(value: 1, unit: cup)),
          _logged,
        ),
      ]).every((it) => it.isTrue());
    });
  });
}
