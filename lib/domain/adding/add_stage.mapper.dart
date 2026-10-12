// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'add_stage.dart';

class AddStageMapper extends EnumMapper<AddStage> {
  AddStageMapper._();

  static AddStageMapper? _instance;
  static AddStageMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AddStageMapper._());
    }
    return _instance!;
  }

  static AddStage fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  AddStage decode(dynamic value) {
    switch (value) {
      case r'mfp':
        return AddStage.mfp;
      case r'ekklo':
        return AddStage.ekklo;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(AddStage self) {
    switch (self) {
      case AddStage.mfp:
        return r'mfp';
      case AddStage.ekklo:
        return r'ekklo';
    }
  }
}

extension AddStageMapperExtension on AddStage {
  String toValue() {
    AddStageMapper.ensureInitialized();
    return MapperContainer.globals.toValue<AddStage>(this) as String;
  }
}

