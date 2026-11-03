import 'dart:async';

import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/data/entries/ekklo_link.dart';
import 'package:fujin/data/entries/entry_repository.dart';
import 'package:fujin/data/entries/logged_entry.dart';
import 'package:fujin/data/foods/food_repository.dart';
import 'package:fujin/data/memory/memory_repository.dart';
import 'package:fujin/domain/adding/add_draft.dart';
import 'package:fujin/domain/adding/entry_writer.dart';
import 'package:fujin/domain/adding/known_food.dart';
import 'package:fujin/domain/adding/rescale_planned.dart';
import 'package:fujin/domain/editing/edit_opening.dart';
import 'package:fujin/domain/editing/edit_outcome.dart';
import 'package:fujin/domain/editing/edited_food.dart';
import 'package:fujin/domain/sending/planned_entry.dart';
import 'package:fujin/domain/sending/send_service.dart';
import 'package:fujin/domain/writing/background_writer.dart';
import 'package:fujin/domain/writing/ekklo_job.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

final class EditEntryService {
  const EditEntryService({
    required this._mfp,
    required this._sending,
    required this._memory,
    required this._foods,
    required this._entries,
    required this._writer,
    required this._background,
  });

  final MyFitnessPalClient _mfp;
  final SendService _sending;
  final MemoryRepository _memory;
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
    _holdSend(
      entryId,
      switch (planned) {
        final planned? => rescalePlanned(planned, stored, _memory.load()),
        null => null,
      },
      link: original.ekkloLink,
    );
    unawaited(_background.run());
    return Edited(EditedFood(original: original, entry: stored));
  }

  Future<EditOutcome> revert(EditedFood edited) async {
    final stored = _writer.put(edited.original.entry);
    final replanned = await _replanned(stored);
    _holdSend(stored.entry.id, replanned, link: stored.ekkloLink);
    unawaited(_background.run());
    return Edited(EditedFood(original: edited.entry, entry: stored));
  }

  Future<PlannedEntry?> _replanned(LoggedEntry stored) async {
    try {
      return rescalePlanned(
        await _sending.planOne(stored),
        stored,
        _memory.load(),
      );
    } on EkkloException {
      return null;
    }
  }

  void _holdSend(
    String entryId,
    PlannedEntry? planned, {
    required EkkloLink? link,
  }) {
    final held = _background.heldFor(entryId) is EkkloSend;
    switch ((planned, link?.item != null || held)) {
      case (final planned?, true) when planned.sends:
        _background.hold(entryId, EkkloSend(planned));
      case (_, _) when held:
        _background.drop(entryId);
      case (_, _):
        break;
    }
  }
}
