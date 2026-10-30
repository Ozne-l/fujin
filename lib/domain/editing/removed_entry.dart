import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/entries/logged_entry.dart';

part 'removed_entry.mapper.dart';

@MappableClass()
final class RemovedEntry with RemovedEntryMappable {
  const RemovedEntry(this.entry);

  final LoggedEntry entry;
}
