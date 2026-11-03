import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/entries/logged_entry.dart';
import 'package:fujin/pages/journal/removal_reason.dart';

part 'entry_removal.mapper.dart';

@MappableClass()
final class EntryRemoval with EntryRemovalMappable {
  const EntryRemoval({required this.entry, required this.reason});

  final LoggedEntry entry;
  final RemovalReason reason;

  String get entryId => entry.entry.id;
}
