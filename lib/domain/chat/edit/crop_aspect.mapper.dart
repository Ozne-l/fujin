// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'crop_aspect.dart';

class CropAspectMapper extends EnumMapper<CropAspect> {
  CropAspectMapper._();

  static CropAspectMapper? _instance;
  static CropAspectMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CropAspectMapper._());
    }
    return _instance!;
  }

  static CropAspect fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  CropAspect decode(dynamic value) {
    switch (value) {
      case r'free':
        return CropAspect.free;
      case r'original':
        return CropAspect.original;
      case r'square':
        return CropAspect.square;
      case r'fourFive':
        return CropAspect.fourFive;
      case r'sixteenNine':
        return CropAspect.sixteenNine;
      case r'nineSixteen':
        return CropAspect.nineSixteen;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(CropAspect self) {
    switch (self) {
      case CropAspect.free:
        return r'free';
      case CropAspect.original:
        return r'original';
      case CropAspect.square:
        return r'square';
      case CropAspect.fourFive:
        return r'fourFive';
      case CropAspect.sixteenNine:
        return r'sixteenNine';
      case CropAspect.nineSixteen:
        return r'nineSixteen';
    }
  }
}

extension CropAspectMapperExtension on CropAspect {
  String toValue() {
    CropAspectMapper.ensureInitialized();
    return MapperContainer.globals.toValue<CropAspect>(this) as String;
  }
}

