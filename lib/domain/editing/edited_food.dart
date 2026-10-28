import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/links/sent_link.dart';
import 'package:fujin/domain/sending/planned_entry.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

part 'edited_food.mapper.dart';

@MappableClass()
final class EditedFood with EditedFoodMappable {
  const EditedFood({
    required this.originalId,
    required this.original,
    required this.planned,
    required this.ekkloWritten,
    this.link,
  });

  final String originalId;
  final MfpFoodEntry original;
  final SentLink? link;
  final PlannedEntry planned;
  final bool ekkloWritten;

  String get entryId => planned.entryId;

  MfpFoodEntry get entry => planned.entry;

  bool get toEkklo => link != null;
}
