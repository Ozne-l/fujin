import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/database/fujin_id.dart';
import 'package:fujin/data/entries/entry.dart';
import 'package:fujin/data/entries/entry_repository.dart';
import 'package:fujin/data/entries/logged_entry.dart';
import 'package:fujin/data/entries/mfp_link.dart';
import 'package:fujin/data/entries/mfp_write.dart';
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

  LoggedEntry store(
    AddDraft draft, {
    required String entryId,
    void Function()? alongside,
  }) => _database.transaction(() {
    alongside?.call();
    final now = _clock();
    _entries.saveEntry(
      Entry.copyOf(
        draft.mfpEntry,
        id: entryId,
        mealId: _meals.mfpMeal(draft.mfpMealName, id: FujinId.at(now)),
        foodId: _foods.describedMfpFood(
          draft.food.id,
          name: draft.food.description,
          brand: draft.food.brandName,
        ),
        updatedAt: now,
      ),
    );
    return _stored(entryId);
  });

  LoggedEntry put(Entry entry) => _database.transaction(() {
    _entries.saveEntry(entry);
    return _stored(entry.id);
  });

  void linkWritten(
    String entryId, {
    required AddDraft written,
    required String mfpEntryId,
  }) => _database.transaction(() {
    _foods.fill(written.food);
    final now = _clock();
    final row = written.mfpEntry;
    final link = MfpLink.of(
      row,
      id: FujinId.at(now),
      entryId: entryId,
      mfpEntryId: mfpEntryId,
      updatedAt: now,
    );
    _entries.saveLink(
      link,
      entry: switch (_entries.findAny(entryId)) {
        LoggedEntry(entry: Entry(deletedAt: null)) && final live
            when MfpWrite.of(live.copyWith(mfpLink: link)) == null =>
          Entry.copyOf(
            row,
            id: entryId,
            mealId: live.entry.mealId,
            foodId: live.entry.foodId,
            updatedAt: now,
          ),
        _ => null,
      },
    );
  });

  LoggedEntry _stored(String entryId) => switch (_entries.find(entryId)) {
    final stored? => stored,
    null => throw StateError('Entry $entryId was not saved'),
  };
}
