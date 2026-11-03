import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/entries/linked_item.dart';
import 'package:fujin/data/entries/unattended_expectation.dart';

final class EkkloLinkHook extends MappingHook {
  const EkkloLinkHook();

  static const _item = 'item';
  static const _unattended = 'unattended';

  @override
  Object? beforeDecode(Object? value) => switch (value) {
    final Map<String, Object?> row => {
      ...row,
      if (row[LinkedItem.itemIdKey] != null) _item: row,
      if (row[UnattendedExpectation.mealNameKey] != null) _unattended: row,
    },
    _ => value,
  };

  @override
  Object? afterEncode(Object? value) => switch (value) {
    final Map<String, Object?> row => {
      ...row,
      if (row[_item] case final Map<String, Object?> item) ...item,
      if (row[_unattended] case final Map<String, Object?> unattended)
        ...unattended,
    }..removeWhere((key, _) => key == _item || key == _unattended),
    _ => value,
  };
}
