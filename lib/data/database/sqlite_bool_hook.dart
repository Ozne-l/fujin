import 'package:dart_mappable/dart_mappable.dart';

final class SqliteBoolHook extends MappingHook {
  const SqliteBoolHook();

  static const _false = 0;
  static const _true = 1;

  @override
  Object? beforeDecode(Object? value) => switch (value) {
    _false => false,
    _true => true,
    _ => value,
  };

  @override
  Object? afterEncode(Object? value) => switch (value) {
    false => _false,
    true => _true,
    _ => value,
  };
}
