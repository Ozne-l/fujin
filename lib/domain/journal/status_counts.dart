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
    this.sending = 0,
  });

  factory StatusCounts.of(
    Iterable<ComparedEntry> entries, {
    Set<String> sending = const {},
  }) => entries.fold(
    const StatusCounts(),
    (counts, compared) => switch ((
      compared.status,
      sending.contains(compared.logged.entry.id),
    )) {
      (InEkklo(), _) => counts.copyWith(inEkklo: counts.inEkklo + 1),
      (ToSend() || ToUpdate(), true) => counts.copyWith(
        sending: counts.sending + 1,
      ),
      (ToSend(), false) => counts.copyWith(toSend: counts.toSend + 1),
      (ToUpdate(), false) => counts.copyWith(toUpdate: counts.toUpdate + 1),
    },
  );

  final int inEkklo;
  final int toSend;
  final int toUpdate;
  final int sending;

  int get total => inEkklo + pending;

  int get pending => toSend + toUpdate + sending;
}
