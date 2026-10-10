// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'backup_failure.dart';

class BackupFailureMapper extends EnumMapper<BackupFailure> {
  BackupFailureMapper._();

  static BackupFailureMapper? _instance;
  static BackupFailureMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = BackupFailureMapper._());
    }
    return _instance!;
  }

  static BackupFailure fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  BackupFailure decode(dynamic value) {
    switch (value) {
      case r'unreadable':
        return BackupFailure.unreadable;
      case r'notWritten':
        return BackupFailure.notWritten;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(BackupFailure self) {
    switch (self) {
      case BackupFailure.unreadable:
        return r'unreadable';
      case BackupFailure.notWritten:
        return r'notWritten';
    }
  }
}

extension BackupFailureMapperExtension on BackupFailure {
  String toValue() {
    BackupFailureMapper.ensureInitialized();
    return MapperContainer.globals.toValue<BackupFailure>(this) as String;
  }
}

