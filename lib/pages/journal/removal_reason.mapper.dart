// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'removal_reason.dart';

class RemovalReasonMapper extends EnumMapper<RemovalReason> {
  RemovalReasonMapper._();

  static RemovalReasonMapper? _instance;
  static RemovalReasonMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = RemovalReasonMapper._());
    }
    return _instance!;
  }

  static RemovalReason fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  RemovalReason decode(dynamic value) {
    switch (value) {
      case r'undoAdd':
        return RemovalReason.undoAdd;
      case r'delete':
        return RemovalReason.delete;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(RemovalReason self) {
    switch (self) {
      case RemovalReason.undoAdd:
        return r'undoAdd';
      case RemovalReason.delete:
        return r'delete';
    }
  }
}

extension RemovalReasonMapperExtension on RemovalReason {
  String toValue() {
    RemovalReasonMapper.ensureInitialized();
    return MapperContainer.globals.toValue<RemovalReason>(this) as String;
  }
}

