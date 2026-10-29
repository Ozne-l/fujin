// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'energy_unit.dart';

class EnergyUnitMapper extends EnumMapper<EnergyUnit> {
  EnergyUnitMapper._();

  static EnergyUnitMapper? _instance;
  static EnergyUnitMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = EnergyUnitMapper._());
    }
    return _instance!;
  }

  static EnergyUnit fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  EnergyUnit decode(dynamic value) {
    switch (value) {
      case r'calories':
        return EnergyUnit.calories;
      case r'kilojoules':
        return EnergyUnit.kilojoules;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(EnergyUnit self) {
    switch (self) {
      case EnergyUnit.calories:
        return r'calories';
      case EnergyUnit.kilojoules:
        return r'kilojoules';
    }
  }
}

extension EnergyUnitMapperExtension on EnergyUnit {
  String toValue() {
    EnergyUnitMapper.ensureInitialized();
    return MapperContainer.globals.toValue<EnergyUnit>(this) as String;
  }
}

