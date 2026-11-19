// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'pending_text_state.dart';

class PendingTextStateMapper extends EnumMapper<PendingTextState> {
  PendingTextStateMapper._();

  static PendingTextStateMapper? _instance;
  static PendingTextStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PendingTextStateMapper._());
    }
    return _instance!;
  }

  static PendingTextState fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  PendingTextState decode(dynamic value) {
    switch (value) {
      case r'sending':
        return PendingTextState.sending;
      case r'failed':
        return PendingTextState.failed;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(PendingTextState self) {
    switch (self) {
      case PendingTextState.sending:
        return r'sending';
      case PendingTextState.failed:
        return r'failed';
    }
  }
}

extension PendingTextStateMapperExtension on PendingTextState {
  String toValue() {
    PendingTextStateMapper.ensureInitialized();
    return MapperContainer.globals.toValue<PendingTextState>(this) as String;
  }
}

