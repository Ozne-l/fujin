import 'dart:async';

import 'package:fujin/data/entries/entry_repository.dart';
import 'package:fujin/data/entries/logged_entry.dart';
import 'package:fujin/data/entries/mfp_link.dart';
import 'package:fujin/data/entries/mfp_write.dart';
import 'package:fujin/data/memory/memory_repository.dart';
import 'package:fujin/domain/adding/add_draft.dart';
import 'package:fujin/domain/adding/entry_writer.dart';
import 'package:fujin/domain/adding/rescale_planned.dart';
import 'package:fujin/domain/comparison/written_row.dart';
import 'package:fujin/domain/journal/same_day.dart';
import 'package:fujin/domain/sending/own_copy_renewal.dart';
import 'package:fujin/domain/sending/plan_entry.dart';
import 'package:fujin/domain/sending/planned_entry.dart';
import 'package:fujin/domain/sending/send_choice.dart';
import 'package:fujin/domain/sending/send_service.dart';
import 'package:fujin/domain/writing/ekklo_job.dart';
import 'package:fujin/domain/writing/write_failure.dart';
import 'package:fujin/domain/writing/writer_state.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

final class BackgroundWriter {
  BackgroundWriter({
    required this._mfp,
    required this._sending,
    required this._memory,
    required this._entries,
    required this._writer,
  });

  final MyFitnessPalClient _mfp;
  final SendService _sending;
  final MemoryRepository _memory;
  final EntryRepository _entries;
  final EntryWriter _writer;

  final _states = StreamController<WriterState>.broadcast();
  final Map<String, EkkloJob> _held = {};
  WriterState _state = const WriterIdle();
  Future<void>? _running;
  bool _again = false;

  WriterState get state => _state;

  Stream<WriterState> get states => _states.stream;

  void hold(String entryId, EkkloJob job) {
    _held[entryId] = job;
    _emit(_state);
  }

  EkkloJob? heldFor(String entryId) => _held[entryId];

  void drop(String entryId) {
    if (_held.remove(entryId) != null) _emit(_state);
  }

  Future<void> run() {
    if (_running case final running?) {
      _again = true;
      return running;
    }
    return _running = _runs().whenComplete(() => _running = null);
  }

  Future<void> _runs() async {
    do {
      _again = false;
      await _once();
    } while (_again);
  }

  Future<void> _once() async {
    final failures = {
      for (final failure in _state.failures) failure.entryId: failure,
    };
    try {
      final ids = {
        for (final write in _entries.pendingMfp()) write.logged.entry.id,
        ..._held.keys,
      }.toList()..sort();
      failures.removeWhere((id, _) => !ids.contains(id));
      for (final id in ids) {
        final logged = _entries.findAny(id);
        _emit(WriterRunning(current: logged, failures: [...failures.values]));
        switch (await _write(id, logged)) {
          case final failure?:
            failures[id] = failure;
          case null:
            failures.remove(id);
        }
      }
    } finally {
      _emit(WriterIdle(failures: [...failures.values]));
    }
  }

  void _emit(WriterState state) {
    final next = _state = state.withHeld({..._held});
    _states.add(next);
  }

  Future<WriteFailure?> _write(String id, LoggedEntry? logged) async =>
      switch (logged) {
        null => _dropped(id),
        final logged => switch (MfpWrite.of(logged)) {
          MfpAdd() => _toMfp(logged, null),
          final MfpEdit edit => _toMfp(logged, edit),
          MfpDeletion(:final link) => _deleted(logged, link),
          null => _job(logged),
        },
      };

  WriteFailure? _dropped(String id) {
    drop(id);
    return null;
  }

  Future<WriteFailure?> _toMfp(LoggedEntry logged, MfpEdit? edit) async {
    final id = logged.entry.id;
    final date = logged.entry.date;
    if ((edit, logged.ekkloLink) case (
      MfpEdit(:final link),
      final ekkloLink?,
    ) when !sameDay(link.date, date) && ekkloLink.item != null) {
      try {
        await _sending.removeLinked(ekkloLink);
      } on Object catch (error) {
        return EkkloNotWritten(logged, error);
      }
    }
    try {
      final food = switch (logged.mfpFoodId) {
        final mfpFoodId? => await _mfp.foods.byId(mfpFoodId),
        null => null,
      };
      final draft = switch (food) {
        final food? =>
          AddDraft.forEntry(logged, food) ??
              (throw StateError('Serving of ${food.id} is gone')),
        null => throw StateError('Food ${logged.mfpFoodId} is unreadable'),
      };
      final diary = (await _mfp.diary.forDate(date)).entries;
      final mfpEntryId =
          writtenRow(logged, diary, _entries.heldMfpEntryIds(date))?.id ??
          await _mfp.diary.addFood(
            date: draft.date,
            mealName: draft.mfpMealName,
            food: draft.food,
            servingSize: draft.servingSize,
            servings: draft.servings,
          ) ??
          (throw StateError('MyFitnessPal returned no entry id'));
      if (edit case MfpEdit(:final link)) {
        final original = switch (sameDay(link.date, date)) {
          true => diary,
          false => (await _mfp.diary.forDate(link.date)).entries,
        };
        if (original.any((row) => row.id == link.mfpEntryId)) {
          await _mfp.diary.remove(link.mfpEntryId);
        }
      }
      _writer.linkWritten(id, written: draft, mfpEntryId: mfpEntryId);
    } on Object catch (error) {
      return MfpNotWritten(logged, error);
    }
    return _job(logged);
  }

  Future<WriteFailure?> _deleted(LoggedEntry logged, MfpLink link) async {
    final id = logged.entry.id;
    if (_held[id] case final EkkloRemoval removal) {
      try {
        await _sending.removeLinked(removal.link);
      } on Object catch (error) {
        return EkkloNotWritten(logged, error);
      }
      _done(id, removal);
    }
    try {
      final diary = (await _mfp.diary.forDate(link.date)).entries;
      if (diary.any((row) => row.id == link.mfpEntryId)) {
        await _mfp.diary.remove(link.mfpEntryId);
      }
      _entries.unlinkMfp(id);
    } on Object catch (error) {
      return MfpNotWritten(logged, error);
    }
    return _dropped(id);
  }

  Future<WriteFailure?> _job(LoggedEntry logged) async {
    final id = logged.entry.id;
    switch (_held[id]) {
      case null:
        return null;
      case final EkkloSend send:
        final stored = _entries.find(id);
        if (stored == null) return _done(id, send);
        return switch (await _sending.sendOne(
          _renewed(send.planned, stored),
        )) {
          null => _done(id, send),
          final error => EkkloNotWritten(stored, error),
        };
      case final EkkloRemoval removal:
        try {
          await _sending.removeLinked(removal.link);
        } on Object catch (error) {
          return EkkloNotWritten(logged, error);
        }
        return _done(id, removal);
    }
  }

  WriteFailure? _done(String id, EkkloJob job) {
    if (identical(_held[id], job)) drop(id);
    return null;
  }

  PlannedEntry _renewed(PlannedEntry planned, LoggedEntry stored) {
    final rescaled = rescalePlanned(planned, stored, _memory.load());
    return switch (rescaled.choice) {
      SendAsOwnCopy(reuse: final copy?) when !isFresh(copy, stored) =>
        rescaled.copyWith(
          choice: const SendAsOwnCopy(renewal: OwnCopyRenewal.foodChanged),
        ),
      _ => rescaled,
    };
  }
}
