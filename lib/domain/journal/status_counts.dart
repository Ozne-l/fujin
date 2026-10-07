import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/domain/comparison/compared_entry.dart';
import 'package:fujin/domain/comparison/entry_status.dart';

part 'status_counts.mapper.dart';

@MappableClass()
final class StatusCounts with StatusCountsMappable {
  const StatusCounts({
    this.inEkklo = 0,
    this.toSend = 0,
    this.toUpdate = 0,
  });

  factory StatusCounts.of(Iterable<ComparedEntry> entries) => entries.fold(
    const StatusCounts(),
    (counts, compared) => switch (compared.status) {
      InEkklo() => counts.copyWith(inEkklo: counts.inEkklo + 1),
      ToSend() => counts.copyWith(toSend: counts.toSend + 1),
      ToUpdate() => counts.copyWith(toUpdate: counts.toUpdate + 1),
    },
  );

  final int inEkklo;
  final int toSend;
  final int toUpdate;

  int get total => inEkklo + toSend + toUpdate;

  int get pending => toSend + toUpdate;
}
