// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'own_copy_renewal.dart';

class OwnCopyRenewalMapper extends EnumMapper<OwnCopyRenewal> {
  OwnCopyRenewalMapper._();

  static OwnCopyRenewalMapper? _instance;
  static OwnCopyRenewalMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = OwnCopyRenewalMapper._());
    }
    return _instance!;
  }

  static OwnCopyRenewal fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  OwnCopyRenewal decode(dynamic value) {
    switch (value) {
      case r'newUnit':
        return OwnCopyRenewal.newUnit;
      case r'foodChanged':
        return OwnCopyRenewal.foodChanged;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(OwnCopyRenewal self) {
    switch (self) {
      case OwnCopyRenewal.newUnit:
        return r'newUnit';
      case OwnCopyRenewal.foodChanged:
        return r'foodChanged';
    }
  }
}

extension OwnCopyRenewalMapperExtension on OwnCopyRenewal {
  String toValue() {
    OwnCopyRenewalMapper.ensureInitialized();
    return MapperContainer.globals.toValue<OwnCopyRenewal>(this) as String;
  }
}

