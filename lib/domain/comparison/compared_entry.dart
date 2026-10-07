import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/domain/comparison/entry_status.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

part 'compared_entry.mapper.dart';

@MappableClass()
final class ComparedEntry with ComparedEntryMappable {
  const ComparedEntry(this.entry, this.status);

  final MfpFoodEntry entry;
  final EntryStatus status;
}
