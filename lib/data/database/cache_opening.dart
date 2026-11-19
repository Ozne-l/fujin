import 'package:fujin/data/database/cache_table.dart';
import 'package:fujin/data/database/fujin_database.dart';

sealed class CacheOpening {
  const CacheOpening();
}

final class CacheOpened extends CacheOpening {
  const CacheOpened(this.database);

  final FujinDatabase<CacheTable> database;
}

final class CacheOutdated extends CacheOpening {
  const CacheOutdated();
}
