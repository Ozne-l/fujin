import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/database/fujin_id.dart';
import 'package:fujin/data/entries/day_changes.dart';
import 'package:fujin/data/entries/ekklo_link.dart';
import 'package:fujin/data/entries/linked_item.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

import 'fixtures.dart';
import 'repositories.dart';

final class SentFood {
  const SentFood(
    this.entry, {
    required this.itemId,
    this.ekkloMeal = 'meal-1',
    this.servings,
  });

  final MfpFoodEntry entry;
  final String itemId;
  final String ekkloMeal;
  final double? servings;

  void store(FujinDatabase database, {required String entryId}) {
    final entries = entriesOf(database);
    storeEntry(database, entry, entryId);
    final stored = entries.find(entryId)?.entry;
    if (stored == null) throw StateError('$entryId was not stored');
    entries.store(
      DayChanges(
        date: stored.date,
        addedEkkloLinks: [
          EkkloLink(
            id: FujinId.at(now),
            entryId: entryId,
            updatedAt: now,
            item: LinkedItem.of(
              stored.copyWith(servings: servings ?? stored.servings),
              ekkloMealId: ekkloMeal,
              ekkloItemId: itemId,
              sentAt: DateTime.utc(2026, 10, 7, 9),
            ),
          ),
        ],
      ),
    );
  }
}
