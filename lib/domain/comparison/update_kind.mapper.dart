// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'update_kind.dart';

class UpdateKindMapper extends EnumMapper<UpdateKind> {
  UpdateKindMapper._();

  static UpdateKindMapper? _instance;
  static UpdateKindMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UpdateKindMapper._());
    }
    return _instance!;
  }

  static UpdateKind fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  UpdateKind decode(dynamic value) {
    switch (value) {
      case r'quantityOnly':
        return UpdateKind.quantityOnly;
      case r'mealChanged':
        return UpdateKind.mealChanged;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(UpdateKind self) {
    switch (self) {
      case UpdateKind.quantityOnly:
        return r'quantityOnly';
      case UpdateKind.mealChanged:
        return r'mealChanged';
    }
  }
}

extension UpdateKindMapperExtension on UpdateKind {
  String toValue() {
    UpdateKindMapper.ensureInitialized();
    return MapperContainer.globals.toValue<UpdateKind>(this) as String;
  }
}

