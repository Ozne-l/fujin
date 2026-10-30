import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/entries/logged_entry.dart';

part 'stored_day.mapper.dart';

@MappableClass()
final class StoredDay with StoredDayMappable {
  const StoredDay({
    this.entries = const [],
    this.deleted = const [],
    this.owed = const [],
  });

  final List<LoggedEntry> entries;
  final List<LoggedEntry> deleted;
  final List<LoggedEntry> owed;
}
