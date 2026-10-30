import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/data/entries/entry_repository.dart';
import 'package:fujin/data/entries/logged_entry.dart';
import 'package:fujin/data/entries/mfp_link.dart';
import 'package:fujin/data/foods/food_repository.dart';
import 'package:fujin/data/memory/memory_repository.dart';
import 'package:fujin/domain/adding/add_draft.dart';
import 'package:fujin/domain/adding/entry_writer.dart';
import 'package:fujin/domain/adding/rescale_planned.dart';
import 'package:fujin/domain/comparison/compared_entry.dart';
import 'package:fujin/domain/comparison/compared_entry_lookup.dart';
import 'package:fujin/domain/comparison/entry_status_link.dart';
import 'package:fujin/domain/editing/edit_opening.dart';
import 'package:fujin/domain/editing/edit_outcome.dart';
import 'package:fujin/domain/editing/edited_food.dart';
import 'package:fujin/domain/journal/journal_service.dart';
import 'package:fujin/domain/journal/same_day.dart';
import 'package:fujin/domain/sending/planned_entry.dart';
import 'package:fujin/domain/sending/send_service.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

final class EditEntryService {
  EditEntryService({
    required this._mfp,
    required this._ekklo,
    required this._journal,
    required this._sending,
    required this._memory,
    required this._foods,
    required this._entries,
    required this._writer,
  });

  final MyFitnessPalClient _mfp;
  final EkkloClient _ekklo;
  final JournalService _journal;
  final SendService _sending;
  final MemoryRepository _memory;
  final FoodRepository _foods;
  final EntryRepository _entries;
  final EntryWriter _writer;

  Future<EditOutcome>? _writing;

  Future<EditOpening> open(LoggedEntry logged) async {
    final food = switch (logged.mfpFoodId) {
      final mfpFoodId? => await _mfp.foods.byId(mfpFoodId),
      null => null,
    };
    if (food == null) return const FoodUnreadable();
    _foods.fill(food);
    final entry = logged.entry;
    final serving = food.servingSizes
        .where(
          (serving) =>
              serving.unit == entry.servingUnit &&
              serving.value == entry.servingValue,
        )
        .firstOrNull;
    if (serving == null) return const ServingMissing();
    final draft = AddDraft(
      food: food,
      servingSize: serving,
      servings: entry.servings,
      mfpMealName: logged.mealName,
      date: entry.date,
    );
    return switch (logged.mfpLink?.foodVersion) {
      final version? when version != food.version => OpenedOnNewVersion(draft),
      _ => Opened(draft),
    };
  }

  Future<EditOutcome> save(
    AddDraft draft,
    PlannedEntry planned, {
    required String entryId,
    required DateTime date,
  }) => _single(() => _save(draft, planned, entryId: entryId, date: date));

  Future<EditOutcome> retryEkklo(EditedFood edited) =>
      _single(() => _toEkklo(edited));

  Future<EditOutcome> finish(EditedFood edited) =>
      _single(() => _finish(edited));

  Future<EditOutcome> revert(EditedFood edited) =>
      _single(() => _revert(edited));

  Future<EditOutcome> _single(Future<EditOutcome> Function() write) =>
      _writing ??= write().whenComplete(() => _writing = null);

  Future<EditOutcome> _save(
    AddDraft draft,
    PlannedEntry planned, {
    required String entryId,
    required DateTime date,
  }) async {
    final ComparedEntry original;
    final String originalMfpEntryId;
    final MfpFood? current;
    try {
      switch (await _find(entryId, date)) {
        case ComparedEntry(
              logged: LoggedEntry(mfpLink: MfpLink(:final mfpEntryId)),
            ) &&
            final compared:
          original = compared;
          originalMfpEntryId = mfpEntryId;
        case _:
          return NotEdited(StateError('Entry $entryId is not in the diary'));
      }
      current = await _mfp.foods.byId(draft.food.id);
      if (!sameDay(date, draft.date)) await _ekklo.meals.forDate(draft.date);
    } on Object catch (error) {
      return NotEdited(error);
    }
    if (current case final current?
        when current.version != draft.food.version) {
      return EditFoodChanged(before: draft.food, after: current);
    }
    return _write(
      draft,
      planned,
      original: original,
      originalMfpEntryId: originalMfpEntryId,
    );
  }

  Future<EditOutcome> _write(
    AddDraft draft,
    PlannedEntry planned, {
    required ComparedEntry original,
    required String originalMfpEntryId,
  }) async {
    final link = original.status.ekkloLink;
    if (link case final link?
        when !sameDay(original.logged.entry.date, draft.date)) {
      try {
        await _sending.removeLinked(link);
      } on Object catch (error) {
        return NotEdited(error);
      }
    }
    final String mfpEntryId;
    try {
      mfpEntryId =
          await _mfp.diary.addFood(
            date: draft.date,
            mealName: draft.mfpMealName,
            food: draft.food,
            servingSize: draft.servingSize,
            servings: draft.servings,
          ) ??
          (throw StateError('MyFitnessPal returned no entry id'));
    } on Object catch (error) {
      return NotEdited(error);
    }
    final edited = EditedFood(
      original: original.logged,
      originalMfpEntryId: originalMfpEntryId,
      mfpEntryId: mfpEntryId,
      draft: draft,
      link: link,
      planned: rescalePlanned(
        planned,
        draft.entry.copyWith.entry(id: original.logged.entry.id),
        _memory.load(),
      ),
      ekkloWritten: false,
    );
    try {
      await _mfp.diary.remove(originalMfpEntryId);
    } on Object catch (error) {
      return OldEntryKept(edited, error);
    }
    return _toEkklo(_stored(edited));
  }

  Future<EditOutcome> _finish(EditedFood edited) async {
    try {
      await _journal.readDay(edited.original.entry.date);
      if (_entries.findByMfpEntryId(edited.originalMfpEntryId) != null) {
        await _mfp.diary.remove(edited.originalMfpEntryId);
      }
    } on Object catch (error) {
      return OldEntryKept(edited, error);
    }
    return _toEkklo(_stored(edited));
  }

  Future<EditOutcome> _revert(EditedFood edited) async {
    final original = edited.original;
    final AddDraft? draft;
    final PlannedEntry planned;
    try {
      draft = switch (original.mfpFoodId) {
        final mfpFoodId? => switch (await _mfp.foods.byId(mfpFoodId)) {
          final food? => AddDraft.of(
            food,
            mfpMealName: original.mealName,
            date: original.entry.date,
            servingSize: MfpServingSize(
              value: original.entry.servingValue,
              unit: original.entry.servingUnit,
              nutritionMultiplier: original.entry.nutritionMultiplier,
            ),
            servings: original.entry.servings,
          ),
          null => null,
        },
        null => null,
      };
      if (draft == null) {
        return NotEdited(
          StateError('Food ${original.mfpFoodId} is unreadable'),
        );
      }
      planned = await _sending.planOne(draft.entry);
    } on Object catch (error) {
      return NotEdited(error);
    }
    return _save(
      draft,
      planned,
      entryId: edited.entryId,
      date: edited.entry.entry.date,
    );
  }

  EditedFood _stored(EditedFood edited) {
    final stored = _writer.save(
      edited.draft,
      entryId: edited.entryId,
      mfpEntryId: edited.mfpEntryId,
    );
    return edited.copyWith(planned: edited.planned.copyWith(entry: stored));
  }

  Future<EditOutcome> _toEkklo(EditedFood edited) async {
    if (!edited.toEkklo) return Edited(edited);
    return switch (await _sending.sendOne(edited.planned)) {
      null => Edited(edited.copyWith(ekkloWritten: true)),
      final error => EkkloNotUpdated(edited, error),
    };
  }

  Future<ComparedEntry?> _find(String entryId, DateTime date) async =>
      (await _journal.readDay(date)).comparison.entryWithId(entryId);
}
