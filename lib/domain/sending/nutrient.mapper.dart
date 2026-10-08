// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'nutrient.dart';

class NutrientMapper extends EnumMapper<Nutrient> {
  NutrientMapper._();

  static NutrientMapper? _instance;
  static NutrientMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = NutrientMapper._());
    }
    return _instance!;
  }

  static Nutrient fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  Nutrient decode(dynamic value) {
    switch (value) {
      case r'kilocalories':
        return Nutrient.kilocalories;
      case r'protein':
        return Nutrient.protein;
      case r'carbohydrates':
        return Nutrient.carbohydrates;
      case r'fat':
        return Nutrient.fat;
      case r'fiber':
        return Nutrient.fiber;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(Nutrient self) {
    switch (self) {
      case Nutrient.kilocalories:
        return r'kilocalories';
      case Nutrient.protein:
        return r'protein';
      case Nutrient.carbohydrates:
        return r'carbohydrates';
      case Nutrient.fat:
        return r'fat';
      case Nutrient.fiber:
        return r'fiber';
    }
  }
}

extension NutrientMapperExtension on Nutrient {
  String toValue() {
    NutrientMapper.ensureInitialized();
    return MapperContainer.globals.toValue<Nutrient>(this) as String;
  }
}

