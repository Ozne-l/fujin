import 'dart:async';

import 'package:fujin/data/entries/entry_repository.dart';
import 'package:fujin/domain/editing/removed_entry.dart';
import 'package:fujin/domain/writing/background_writer.dart';
import 'package:fujin/domain/writing/ekklo_job.dart';

final class RemoveEntryService {
  const RemoveEntryService({
    required this._entries,
    required this._background,
  });

  final EntryRepository _entries;
  final BackgroundWriter _background;

  RemovedEntry? remove(String entryId) {
    final logged = _entries.find(entryId);
    if (logged == null) return null;
    _background.drop(entryId);
    final link = logged.ekkloLink;
    final ekkloRemoved = link?.item != null;
    if (link case final link? when ekkloRemoved) {
      _background.hold(entryId, EkkloRemoval(link));
    }
    _entries.remove(entryId);
    unawaited(_background.run());
    return RemovedEntry(logged, ekkloRemoved: ekkloRemoved);
  }
}
