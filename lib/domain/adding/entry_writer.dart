import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/database/fujin_id.dart';
import 'package:fujin/data/entries/entry.dart';
import 'package:fujin/data/entries/entry_repository.dart';
import 'package:fujin/data/entries/logged_entry.dart';
import 'package:fujin/data/entries/mfp_link.dart';
import 'package:fujin/data/foods/food_repository.dart';
import 'package:fujin/data/meals/meal_repository.dart';
import 'package:fujin/domain/adding/add_draft.dart';

final class EntryWriter {
  const EntryWriter({
    required this._database,
    required this._foods,
    required this._meals,
    required this._entries,
    required this._clock,
  });

  final FujinDatabase _database;
  final FoodRepository _foods;
  final MealRepository _meals;
  final EntryRepository _entries;
  final DateTime Function() _clock;

  String newEntryId() => FujinId.at(_clock());

  LoggedEntry save(
    AddDraft draft, {
    required String entryId,
    required String mfpEntryId,
    void Function()? alongside,
  }) => _database.transaction(() {
    alongside?.call();
    final now = _clock();
    final written = draft.mfpEntry;
    _entries.save(
      Entry.copyOf(
        written,
        id: entryId,
        mealId: _meals.mfpMeal(draft.mfpMealName, id: FujinId.at(now)),
        foodId: _foods.describedMfpFood(
          draft.food.id,
          name: draft.food.description,
          brand: draft.food.brandName,
        ),
        updatedAt: now,
      ),
      MfpLink.of(
        written,
        id: FujinId.at(now),
        entryId: entryId,
        mfpEntryId: mfpEntryId,
        updatedAt: now,
      ),
    );
    return switch (_entries.find(entryId)) {
      final stored? => stored,
      null => throw StateError('Entry $entryId was not saved'),
    };
  });
}
