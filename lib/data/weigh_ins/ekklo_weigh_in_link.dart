import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/database/calendar_date_hook.dart';

part 'ekklo_weigh_in_link.mapper.dart';

@MappableClass()
final class EkkloWeighInLink with EkkloWeighInLinkMappable {
  const EkkloWeighInLink({
    required this.id,
    required this.weighInId,
    required this.date,
    required this.kilograms,
    required this.updatedAt,
    this.deletedAt,
  });

  final String id;
  final String weighInId;
  @MappableField(hook: CalendarDateHook())
  final DateTime date;
  final double kilograms;
  final DateTime updatedAt;
  final DateTime? deletedAt;
}
