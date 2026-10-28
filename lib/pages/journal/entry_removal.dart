import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/pages/journal/removal_reason.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

part 'entry_removal.mapper.dart';

@MappableClass()
final class EntryRemoval with EntryRemovalMappable {
  const EntryRemoval({
    required this.entryId,
    required this.entry,
    required this.reason,
  });

  final String entryId;
  final MfpFoodEntry entry;
  final RemovalReason reason;
}
