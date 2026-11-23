import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/data/entries/entry_repository.dart';
import 'package:fujin/data/entries/logged_entry.dart';
import 'package:fujin/data/foods/food_repository.dart';
import 'package:fujin/domain/adding/add_draft.dart';
import 'package:fujin/domain/adding/entry_writer.dart';
import 'package:fujin/domain/adding/known_food.dart';
import 'package:fujin/domain/editing/edit_opening.dart';
import 'package:fujin/domain/editing/edit_outcome.dart';
import 'package:fujin/domain/editing/edited_food.dart';
import 'package:fujin/domain/sending/planned_entry.dart';
import 'package:fujin/domain/sending/send_service.dart';
import 'package:fujin/domain/writing/background_writer.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

final class EditEntryService {
  const EditEntryService({
    required this._mfp,
    required this._sending,
    required this._foods,
    required this._entries,
    required this._writer,
    required this._background,
  });

  final MyFitnessPalClient _mfp;
  final SendService _sending;
  final FoodRepository _foods;
  final EntryRepository _entries;
  final EntryWriter _writer;
  final BackgroundWriter _background;

  Future<EditOpening> open(LoggedEntry logged) async {
    final food = switch (logged.mfpFoodId) {
      final mfpFoodId? => await knownFood(mfpFoodId, mfp: _mfp, foods: _foods),
      null => null,
    };
    if (food == null) return const FoodUnreadable();
    final draft = AddDraft.forEntry(logged, food);
    if (draft == null) return const ServingMissing();
    return switch (logged.mfpLink?.foodVersion) {
      final version? when version != food.version => OpenedOnNewVersion(draft),
      _ => Opened(draft),
    };
  }

  EditOutcome save(
    AddDraft draft,
    PlannedEntry? planned, {
    required String entryId,
  }) {
    final original = _entries.find(entryId);
    if (original == null) {
      return NotEdited(StateError('Entry $entryId is gone'));
    }
    final stored = _writer.store(draft, entryId: entryId);
    _background.saved(stored, planned, added: false);
    return Edited(EditedFood(original: original, entry: stored));
  }

  Future<EditOutcome> revert(EditedFood edited) async {
    final stored = _writer.put(edited.original.entry);
    _background.saved(stored, await _planned(stored), added: false);
    return Edited(EditedFood(original: edited.entry, entry: stored));
  }

  LoggedEntry? remove(String entryId) {
    final logged = _entries.find(entryId);
    if (logged == null) return null;
    _entries.remove(entryId);
    _background.removed(logged);
    return logged;
  }

  Future<PlannedEntry?> _planned(LoggedEntry stored) async {
    try {
      return await _sending.planOne(stored);
    } on EkkloException {
      return null;
    }
  }
}
