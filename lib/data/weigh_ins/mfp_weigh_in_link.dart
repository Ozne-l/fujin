import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/database/calendar_date_hook.dart';

part 'mfp_weigh_in_link.mapper.dart';

@MappableClass()
final class MfpWeighInLink with MfpWeighInLinkMappable {
  const MfpWeighInLink({
    required this.id,
    required this.weighInId,
    required this.measurementId,
    required this.date,
    required this.kilograms,
    required this.updatedAt,
    this.deletedAt,
  });

  final String id;
  final String weighInId;
  final String measurementId;
  @MappableField(hook: CalendarDateHook())
  final DateTime date;
  final double kilograms;
  final DateTime updatedAt;
  final DateTime? deletedAt;
}
