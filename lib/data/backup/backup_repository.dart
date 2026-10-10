import 'package:fujin/data/backup/backup.dart';
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/goals/goals_repository.dart';
import 'package:fujin/data/links/sent_link_repository.dart';
import 'package:fujin/data/memory/memory_repository.dart';

final class BackupRepository {
  const BackupRepository({
    required this._database,
    required this._memory,
    required this._links,
    required this._goals,
  });

  final FujinDatabase _database;
  final MemoryRepository _memory;
  final SentLinkRepository _links;
  final GoalsRepository _goals;

  Backup snapshot(DateTime exportedAt) {
    final memory = _memory.load();
    return Backup(
      exportedAt: exportedAt,
      matches: memory.matches,
      ownCopies: memory.ownCopies,
      units: memory.units,
      meals: memory.meals,
      links: _links.all(),
      goals: _goals.load(),
    );
  }

  void restore(Backup backup) => _database.transaction(() {
    _memory.replace(backup.memory);
    _links.replaceAll(backup.links);
    _goals.replace(backup.goals);
  });
}
