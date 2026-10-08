// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'unit_weight.dart';

class UnitWeightMapper extends EnumMapper<UnitWeight> {
  UnitWeightMapper._();

  static UnitWeightMapper? _instance;
  static UnitWeightMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UnitWeightMapper._());
    }
    return _instance!;
  }

  static UnitWeight fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  UnitWeight decode(dynamic value) {
    switch (value) {
      case r'notNeeded':
        return UnitWeight.notNeeded;
      case r'remembered':
        return UnitWeight.remembered;
      case r'estimated':
        return UnitWeight.estimated;
      case r'confirmed':
        return UnitWeight.confirmed;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(UnitWeight self) {
    switch (self) {
      case UnitWeight.notNeeded:
        return r'notNeeded';
      case UnitWeight.remembered:
        return r'remembered';
      case UnitWeight.estimated:
        return r'estimated';
      case UnitWeight.confirmed:
        return r'confirmed';
    }
  }
}

extension UnitWeightMapperExtension on UnitWeight {
  String toValue() {
    UnitWeightMapper.ensureInitialized();
    return MapperContainer.globals.toValue<UnitWeight>(this) as String;
  }
}

