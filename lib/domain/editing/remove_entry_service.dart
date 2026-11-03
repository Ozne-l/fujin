import 'dart:async';

import 'package:fujin/data/entries/entry_repository.dart';
import 'package:fujin/data/entries/logged_entry.dart';
import 'package:fujin/domain/writing/background_writer.dart';
import 'package:fujin/domain/writing/ekklo_job.dart';

final class RemoveEntryService {
  const RemoveEntryService({
    required this._entries,
    required this._background,
  });

  final EntryRepository _entries;
  final BackgroundWriter _background;

  LoggedEntry? remove(String entryId) {
    final logged = _entries.find(entryId);
    if (logged == null) return null;
    _background.drop(entryId);
    if (logged.ekkloLink case final link? when link.item != null) {
      _background.hold(entryId, EkkloRemoval(link));
    }
    _entries.remove(entryId);
    unawaited(_background.run());
    return logged;
  }
}
