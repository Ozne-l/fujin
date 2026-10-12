import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/domain/sending/planned_entry.dart';

part 'kept_choices.mapper.dart';

@MappableClass()
final class KeptChoices with KeptChoicesMappable {
  const KeptChoices({this.kept = const {}, this.keeping = const {}});

  final Map<String, PlannedEntry> kept;
  final Set<String> keeping;
}
