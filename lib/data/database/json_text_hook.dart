import 'dart:convert';

import 'package:dart_mappable/dart_mappable.dart';

final class JsonTextHook extends MappingHook {
  const JsonTextHook();

  @override
  Object? beforeDecode(Object? value) => switch (value) {
    final String text => jsonDecode(text),
    _ => value,
  };

  @override
  Object? afterEncode(Object? value) => switch (value) {
    final Map<String, Object?> json => jsonEncode(json),
    _ => value,
  };
}
