// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'step_state.dart';

class StepStateMapper extends EnumMapper<StepState> {
  StepStateMapper._();

  static StepStateMapper? _instance;
  static StepStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = StepStateMapper._());
    }
    return _instance!;
  }

  static StepState fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  StepState decode(dynamic value) {
    switch (value) {
      case r'pending':
        return StepState.pending;
      case r'running':
        return StepState.running;
      case r'done':
        return StepState.done;
      case r'failed':
        return StepState.failed;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(StepState self) {
    switch (self) {
      case StepState.pending:
        return r'pending';
      case StepState.running:
        return r'running';
      case StepState.done:
        return r'done';
      case StepState.failed:
        return r'failed';
    }
  }
}

extension StepStateMapperExtension on StepState {
  String toValue() {
    StepStateMapper.ensureInitialized();
    return MapperContainer.globals.toValue<StepState>(this) as String;
  }
}

