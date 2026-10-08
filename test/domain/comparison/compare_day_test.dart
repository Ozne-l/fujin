import 'package:checks/checks.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter_test/flutter_test.dart' show group, test;
import 'package:fujin/data/links/sent_link.dart';
import 'package:fujin/data/memory/meal_mapping.dart';
import 'package:fujin/data/memory/memory.dart';
import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/domain/comparison/compare_day.dart';
import 'package:fujin/domain/comparison/day_comparison.dart';
import 'package:fujin/domain/comparison/entry_status.dart';
import 'package:fujin/domain/comparison/update_kind.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

import '../../support/fixtures.dart';

DayComparison compare(
  List<MfpFoodEntry> entries,
  List<EkkloDailyMeal> meals, [
  List<SentLink> links = const [],
  Memory remembered = memory,
]) => compareDay(
  entries: entries,
  meals: meals,
  links: links,
  memory: remembered,
  now: now,
);

List<EntryStatus> statusesOf(DayComparison comparison) => [
  for (final compared in comparison.entries) compared.status,
];

SentLink adoptedLink(
  String entryId,
  String itemId, {
  String meal = breakfast,
  String food = oats,
  double servings = 1,
  double servingValue = 100,
  String unit = grams,
}) => SentLink(
  mfpEntryId: entryId,
  date: day,
  mfpFoodId: food,
  mfpMealName: meal,
  mfpServings: servings,
  mfpServingValue: servingValue,
  mfpServingUnit: unit,
  ekkloMealId: 'meal-1',
  ekkloItemId: itemId,
  sentAt: now,
);

void main() {
  group('a linked entry', () {
    test('is in Ekklo while its item exists', () {
      final sent = link('E-1', 'I-1');

      final result = compare(
        [entry('E-1')],
        [
          meal('meal-1', [item('I-1')]),
        ],
        [sent],
      );

      check(statusesOf(result)).deepEquals([InEkklo(sent)]);
      check(result.linksToAdopt).isEmpty();
      check(result.linksToDrop).isEmpty();
    });

    test('loses its link and is to send once its item is gone', () {
      final sent = link('E-1', 'I-1');

      final result = compare([entry('E-1')], [meal('meal-1', [])], [sent]);

      check(statusesOf(result)).deepEquals([const ToSend()]);
      check(result.linksToDrop).deepEquals([sent]);
    });
  });

  group('an unlinked entry', () {
    test('adopts the unclaimed item Memory expects', () {
      final result = compare(
        [entry('E-1', servings: 1.5)],
        [
          meal('meal-1', [item('I-1', quantity: 150)]),
        ],
      );

      final adopted = adoptedLink('E-1', 'I-1', servings: 1.5);
      check(statusesOf(result)).deepEquals([InEkklo(adopted)]);
      check(result.linksToAdopt).deepEquals([adopted]);
    });

    test('adopts within 0.1 of the expected quantity and not beyond', () {
      final result = compare(
        [entry('E-1'), entry('E-2', servings: 2)],
        [
          meal('meal-1', [
            item('I-1', quantity: 100.1),
            item('I-2', quantity: 200.2),
          ]),
        ],
      );

      check(statusesOf(result)).deepEquals([
        InEkklo(adoptedLink('E-1', 'I-1')),
        const ToSend(),
      ]);
    });

    test('converts a remembered unit to grams', () {
      final result = compare(
        [entry('E-1', food: rice, unit: cup, servingValue: 1, servings: 2)],
        [
          meal('meal-1', [item('I-1', food: riceInEkklo, quantity: 360)]),
        ],
      );

      check(statusesOf(result)).deepEquals([
        InEkklo(
          adoptedLink(
            'E-1',
            'I-1',
            food: rice,
            servings: 2,
            servingValue: 1,
            unit: cup,
          ),
        ),
      ]);
    });

    test(
      'expects an own copy in portions of its unit, and nothing in another',
      () {
        const copied = Memory(
          foods: [
            OwnCopy(
              mfpFoodId: oats,
              mfpDescription: oats,
              ekkloFoodId: 'own-oats',
              ekkloFoodName: oats,
              mfpUnit: cup,
            ),
          ],
          meals: [
            MealMapping(mfpMealName: breakfast, ekkloMealName: petitDejeuner),
          ],
        );

        final result = compare(
          [
            entry('E-1', unit: cup, servingValue: 0.5, servings: 3),
            entry('E-2', unit: 'bowl', servingValue: 1, servings: 1.5),
          ],
          [
            meal('meal-1', [
              item(
                'I-1',
                food: 'own-oats',
                quantity: 1.5,
                type: EkkloQuantityType.portion,
              ),
              item(
                'I-2',
                food: 'own-oats',
                quantity: 1.5,
                type: EkkloQuantityType.portion,
              ),
            ]),
          ],
          const [],
          copied,
        );

        check(statusesOf(result)).deepEquals([
          InEkklo(
            adoptedLink(
              'E-1',
              'I-1',
              servings: 3,
              servingValue: 0.5,
              unit: cup,
            ),
          ),
          const ToSend(),
        ]);
      },
    );

    test('is to send when its unit has no grams in Memory', () {
      final result = compare(
        [entry('E-1', unit: cup, servingValue: 1)],
        [
          meal('meal-1', [item('I-1', quantity: 1)]),
        ],
      );

      check(statusesOf(result)).deepEquals([const ToSend()]);
    });

    test('is to send when its meal has no Ekklo meal in Memory', () {
      final result = compare(
        [entry('E-1', meal: 'Snacks')],
        [
          meal('meal-1', [item('I-1')]),
        ],
      );

      check(statusesOf(result)).deepEquals([const ToSend()]);
    });

    test('cannot adopt an item a link already claims', () {
      final result = compare(
        [entry('E-1'), entry('E-2')],
        [
          meal('meal-1', [item('I-1')]),
        ],
        [link('E-1', 'I-1')],
      );

      check(statusesOf(result)).deepEquals([
        InEkklo(link('E-1', 'I-1')),
        const ToSend(),
      ]);
    });

    test('claims each item once, in MyFitnessPal order', () {
      final result = compare(
        [entry('E-1'), entry('E-2')],
        [
          meal('meal-1', [item('I-1')]),
        ],
      );

      check(statusesOf(result)).deepEquals([
        InEkklo(adoptedLink('E-1', 'I-1')),
        const ToSend(),
      ]);
    });

    test('without an id is always to send', () {
      final result = compare(
        [entry(null)],
        [
          meal('meal-1', [item('I-1')]),
        ],
      );

      check(statusesOf(result)).deepEquals([const ToSend()]);
      check(result.linksToAdopt).isEmpty();
    });
  });

  group('an orphan link', () {
    test('turns the same food in the same meal into a quantity update', () {
      final orphan = link('E-1', 'I-1');

      final result = compare(
        [entry('E-2', servings: 1.5)],
        [
          meal('meal-1', [item('I-1')]),
        ],
        [orphan],
      );

      check(
        statusesOf(result),
      ).deepEquals([ToUpdate(orphan, UpdateKind.quantityOnly)]);
      check(result.linksToDrop).isEmpty();
    });

    test('turns the same food moved to another Ekklo meal into a move', () {
      final orphan = link('E-1', 'I-1');

      final result = compare(
        [entry('E-2', meal: lunch)],
        [
          meal('meal-1', [item('I-1')]),
        ],
        [orphan],
      );

      check(
        statusesOf(result),
      ).deepEquals([ToUpdate(orphan, UpdateKind.mealChanged)]);
    });

    test('moves to the new entry when nothing changed in Ekklo terms', () {
      final orphan = link('E-1', 'I-1');

      final result = compare(
        [entry('E-2')],
        [
          meal('meal-1', [item('I-1')]),
        ],
        [orphan],
      );

      final moved = adoptedLink('E-2', 'I-1');
      check(statusesOf(result)).deepEquals([InEkklo(moved)]);
      check(result.linksToDrop).deepEquals([orphan]);
      check(result.linksToAdopt).deepEquals([moved]);
    });

    test('pairs with an entry of its own meal before any other', () {
      final orphan = link('E-1', 'I-1');

      final result = compare(
        [
          entry('E-2', meal: lunch, servings: 2),
          entry('E-3', servings: 2),
        ],
        [
          meal('meal-1', [item('I-1')]),
        ],
        [orphan],
      );

      check(statusesOf(result)).deepEquals([
        const ToSend(),
        ToUpdate(orphan, UpdateKind.quantityOnly),
      ]);
    });

    test('is dropped with nothing to update when its item is gone', () {
      final orphan = link('E-1', 'I-1');

      final result = compare(
        [entry('E-2', servings: 2)],
        [meal('meal-1', [])],
        [orphan],
      );

      check(statusesOf(result)).deepEquals([const ToSend()]);
      check(result.linksToDrop).deepEquals([orphan]);
    });

    test('left unpaired changes nothing and keeps its link', () {
      final orphan = link('E-1', 'I-1');

      final result = compare(
        [entry('E-2', food: rice)],
        [
          meal('meal-1', [item('I-1')]),
        ],
        [orphan],
      );

      check(statusesOf(result)).deepEquals([const ToSend()]);
      check(result.linksToDrop).isEmpty();
      check(result.linksToAdopt).isEmpty();
    });
  });
}
