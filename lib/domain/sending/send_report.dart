import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/domain/sending/retained_weight.dart';

part 'send_report.mapper.dart';

@MappableClass()
final class SendReport with SendReportMappable {
  const SendReport({
    required this.date,
    required this.sentAt,
    this.sent = 0,
    this.reused = 0,
    this.updated = 0,
    this.newAssociations = const [],
    this.weights = const [],
    this.ownCopies = const [],
  });

  final DateTime date;
  final DateTime sentAt;
  final int sent;
  final int reused;
  final int updated;
  final List<String> newAssociations;
  final List<RetainedWeight> weights;
  final List<String> ownCopies;
}
