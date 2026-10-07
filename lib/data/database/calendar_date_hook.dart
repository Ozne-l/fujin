import 'package:dart_mappable/dart_mappable.dart';

final class CalendarDateHook extends MappingHook {
  const CalendarDateHook();

  static const _dateLength = 10;
  static const _midnightUtc = 'T00:00:00Z';

  static String format(DateTime date) =>
      date.toIso8601String().substring(0, _dateLength);

  @override
  Object? beforeDecode(Object? value) => switch (value) {
    final String date when date.length == _dateLength => '$date$_midnightUtc',
    _ => value,
  };

  @override
  Object? afterEncode(Object? value) => switch (value) {
    final String date when date.length > _dateLength => date.substring(
      0,
      _dateLength,
    ),
    _ => value,
  };
}
