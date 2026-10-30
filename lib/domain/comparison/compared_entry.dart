import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/entries/logged_entry.dart';
import 'package:fujin/domain/comparison/entry_status.dart';

part 'compared_entry.mapper.dart';

@MappableClass()
final class ComparedEntry with ComparedEntryMappable {
  const ComparedEntry(this.logged, this.status, {this.stored = true});

  final LoggedEntry logged;
  final EntryStatus status;
  final bool stored;

  String? get entryId => switch (stored) {
    true => logged.entry.id,
    false => null,
  };
}
