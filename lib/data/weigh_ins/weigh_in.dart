import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/database/calendar_date_hook.dart';

part 'weigh_in.mapper.dart';

@MappableClass()
final class WeighIn with WeighInMappable {
  const WeighIn({
    required this.id,
    required this.date,
    required this.kilograms,
    required this.updatedAt,
    this.deletedAt,
  });

  final String id;
  @MappableField(hook: CalendarDateHook())
  final DateTime date;
  final double kilograms;
  final DateTime updatedAt;
  final DateTime? deletedAt;
}
