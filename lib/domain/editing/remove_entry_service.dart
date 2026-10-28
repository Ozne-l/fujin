import 'dart:async';

import 'package:fujin/domain/comparison/compared_entry_lookup.dart';
import 'package:fujin/domain/comparison/entry_status_link.dart';
import 'package:fujin/domain/editing/remove_outcome.dart';
import 'package:fujin/domain/journal/journal_day.dart';
import 'package:fujin/domain/journal/journal_service.dart';
import 'package:fujin/domain/sending/send_service.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

final class RemoveEntryService {
  RemoveEntryService({
    required this._mfp,
    required this._journal,
    required this._sending,
  });

  final MyFitnessPalClient _mfp;
  final JournalService _journal;
  final SendService _sending;

  final Map<String, Future<RemoveOutcome>> _removing = {};

  Future<RemoveOutcome> remove({
    required String entryId,
    required DateTime date,
  }) => _removing[entryId] ??= _remove(
    entryId,
    date,
  ).whenComplete(() => unawaited(_removing.remove(entryId)));

  Future<RemoveOutcome> _remove(String entryId, DateTime date) async {
    final JournalDay day;
    try {
      day = await _journal.readDay(date);
    } on Object catch (error) {
      return NotRemoved(error);
    }
    final status = day.comparison.entryWithId(entryId)?.status;
    final ekkloRemoved = status?.sentLink;
    if (ekkloRemoved case final link?) {
      try {
        await _sending.removeLinked(link);
      } on Object catch (error) {
        return NotRemoved(error);
      }
    }
    if (status == null) return const Removed(ekkloRemoved: false);
    try {
      await _mfp.diary.remove(entryId);
    } on Object catch (error) {
      return switch (ekkloRemoved) {
        null => NotRemoved(error),
        _ => StillInMfp(error),
      };
    }
    return Removed(ekkloRemoved: ekkloRemoved != null);
  }
}
