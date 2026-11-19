import 'package:dart_mappable/dart_mappable.dart';

final class EpochMicrosecondsHook extends MappingHook {
  const EpochMicrosecondsHook();

  static int format(DateTime instant) => instant.microsecondsSinceEpoch;

  @override
  Object? beforeDecode(Object? value) => switch (value) {
    final int microseconds => DateTime.fromMicrosecondsSinceEpoch(
      microseconds,
      isUtc: true,
    ).toIso8601String(),
    _ => value,
  };

  @override
  Object? afterEncode(Object? value) => switch (value) {
    final String instant => format(DateTime.parse(instant)),
    _ => value,
  };
}
