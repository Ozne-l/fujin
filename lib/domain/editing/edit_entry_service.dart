import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/data/memory/memory_repository.dart';
import 'package:fujin/domain/adding/add_draft.dart';
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
  });

  final MyFitnessPalClient _mfp;
  final EkkloClient _ekklo;
  final JournalService _journal;
  final SendService _sending;
  final MemoryRepository _memory;

  Future<EditOutcome>? _writing;

  Future<EditOpening> open(MfpFoodEntry entry) async {
    final food = await _mfp.foods.byId(entry.food.id);
    if (food == null) return const FoodUnreadable();
    final serving = food.servingSizes
        .where(
          (serving) =>
              serving.unit == entry.servingSize.unit &&
              serving.value == entry.servingSize.value,
        )
        .firstOrNull;
    if (serving == null) return const ServingMissing();
    final draft = AddDraft(
      food: food,
      servingSize: serving,
      servings: entry.servings,
      mfpMealName: entry.mealName,
      date: entry.date,
    );
    return switch (entry.food.version) {
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
    final ComparedEntry? original;
    final MfpFood? current;
    try {
      original = await _find(entryId, date);
      if (original == null) {
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
    final link = original.status.sentLink;
    if (link case final link? when !sameDay(date, draft.date)) {
      try {
        await _sending.removeLinked(link);
      } on Object catch (error) {
        return NotEdited(error);
      }
    }
    final String newId;
    try {
      newId =
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
    final entry = draft.entry.copyWith(id: newId);
    final edited = EditedFood(
      originalId: entryId,
      original: original.entry,
      link: link,
      planned: rescalePlanned(
        planned,
        entry,
        _memory.load(),
      ).copyWith(entryId: newId),
      ekkloWritten: false,
    );
    try {
      await _mfp.diary.remove(entryId);
    } on Object catch (error) {
      return OldEntryKept(edited, error);
    }
    return _toEkklo(edited);
  }

  Future<EditOutcome> _finish(EditedFood edited) async {
    try {
      if (await _find(edited.originalId, edited.original.date) != null) {
        await _mfp.diary.remove(edited.originalId);
      }
    } on Object catch (error) {
      return OldEntryKept(edited, error);
    }
    return _toEkklo(edited);
  }

  Future<EditOutcome> _revert(EditedFood edited) async {
    final original = edited.original;
    final AddDraft? draft;
    final PlannedEntry planned;
    try {
      draft = switch (await _mfp.foods.byId(original.food.id)) {
        final food? => AddDraft.of(
          food,
          mfpMealName: original.mealName,
          date: original.date,
          servingSize: original.servingSize,
          servings: original.servings,
        ),
        null => null,
      };
      if (draft == null) {
        return NotEdited(StateError('Food ${original.food.id} is unreadable'));
      }
      planned = await _sending.planOne(
        draft.entry,
        entryId: AddDraft.pendingEntryId,
      );
    } on Object catch (error) {
      return NotEdited(error);
    }
    return _save(
      draft,
      planned,
      entryId: edited.entryId,
      date: edited.entry.date,
    );
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
