import 'package:dart_mappable/dart_mappable.dart';

final class FlatNutrientsHook extends MappingHook {
  const FlatNutrientsHook();

  static const _nutrients = 'nutrients';

  @override
  Object? beforeDecode(Object? value) => switch (value) {
    final Map<String, Object?> row => {...row, _nutrients: row},
    _ => value,
  };

  @override
  Object? afterEncode(Object? value) => switch (value) {
    {_nutrients: final Map<String, Object?> nutrients} &&
        final Map<String, Object?> row =>
      {...row, ...nutrients}..remove(_nutrients),
    _ => value,
  };
}
