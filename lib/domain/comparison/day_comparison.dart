import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/links/sent_link.dart';
import 'package:fujin/domain/comparison/compared_entry.dart';

part 'day_comparison.mapper.dart';

@MappableClass()
final class DayComparison with DayComparisonMappable {
  const DayComparison({
    this.entries = const [],
    this.linksToAdopt = const [],
    this.linksToDrop = const [],
  });

  final List<ComparedEntry> entries;
  final List<SentLink> linksToAdopt;
  final List<SentLink> linksToDrop;
}
