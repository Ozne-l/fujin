import 'package:dart_mappable/dart_mappable.dart';

final class FlatFieldHook extends MappingHook {
  const FlatFieldHook(this._field);

  final String _field;

  @override
  Object? beforeDecode(Object? value) => switch (value) {
    final Map<String, Object?> row => {...row, _field: row},
    _ => value,
  };

  @override
  Object? afterEncode(Object? value) => switch (value) {
    final Map<String, Object?> row => switch (row[_field]) {
      final Map<String, Object?> nested => {...row, ...nested}..remove(_field),
      _ => value,
    },
    _ => value,
  };
}
