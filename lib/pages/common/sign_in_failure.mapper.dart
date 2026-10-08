// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'sign_in_failure.dart';

class SignInFailureMapper extends EnumMapper<SignInFailure> {
  SignInFailureMapper._();

  static SignInFailureMapper? _instance;
  static SignInFailureMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SignInFailureMapper._());
    }
    return _instance!;
  }

  static SignInFailure fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  SignInFailure decode(dynamic value) {
    switch (value) {
      case r'refused':
        return SignInFailure.refused;
      case r'unreachable':
        return SignInFailure.unreachable;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(SignInFailure self) {
    switch (self) {
      case SignInFailure.refused:
        return r'refused';
      case SignInFailure.unreachable:
        return r'unreachable';
    }
  }
}

extension SignInFailureMapperExtension on SignInFailure {
  String toValue() {
    SignInFailureMapper.ensureInitialized();
    return MapperContainer.globals.toValue<SignInFailure>(this) as String;
  }
}

