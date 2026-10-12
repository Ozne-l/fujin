// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'send_mode.dart';

class SendModeMapper extends EnumMapper<SendMode> {
  SendModeMapper._();

  static SendModeMapper? _instance;
  static SendModeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SendModeMapper._());
    }
    return _instance!;
  }

  static SendMode fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  SendMode decode(dynamic value) {
    switch (value) {
      case r'reviewed':
        return SendMode.reviewed;
      case r'automatic':
        return SendMode.automatic;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(SendMode self) {
    switch (self) {
      case SendMode.reviewed:
        return r'reviewed';
      case SendMode.automatic:
        return r'automatic';
    }
  }
}

extension SendModeMapperExtension on SendMode {
  String toValue() {
    SendModeMapper.ensureInitialized();
    return MapperContainer.globals.toValue<SendMode>(this) as String;
  }
}

