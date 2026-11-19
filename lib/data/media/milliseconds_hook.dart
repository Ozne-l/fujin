import 'package:dart_mappable/dart_mappable.dart';

final class MillisecondsHook extends MappingHook {
  const MillisecondsHook();

  @override
  Object? beforeDecode(Object? value) => switch (value) {
    final int milliseconds => Duration(milliseconds: milliseconds),
    _ => value,
  };

  @override
  Object? beforeEncode(Object? value) => switch (value) {
    final Duration duration => duration.inMilliseconds,
    _ => value,
  };
}
