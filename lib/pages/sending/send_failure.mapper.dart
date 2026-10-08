// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'send_failure.dart';

class SendFailureMapper extends EnumMapper<SendFailure> {
  SendFailureMapper._();

  static SendFailureMapper? _instance;
  static SendFailureMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SendFailureMapper._());
    }
    return _instance!;
  }

  static SendFailure fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  SendFailure decode(dynamic value) {
    switch (value) {
      case r'network':
        return SendFailure.network;
      case r'ekkloSession':
        return SendFailure.ekkloSession;
      case r'mfpSession':
        return SendFailure.mfpSession;
      case r'refused':
        return SendFailure.refused;
      case r'blockedInDev':
        return SendFailure.blockedInDev;
      case r'other':
        return SendFailure.other;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(SendFailure self) {
    switch (self) {
      case SendFailure.network:
        return r'network';
      case SendFailure.ekkloSession:
        return r'ekkloSession';
      case SendFailure.mfpSession:
        return r'mfpSession';
      case SendFailure.refused:
        return r'refused';
      case SendFailure.blockedInDev:
        return r'blockedInDev';
      case SendFailure.other:
        return r'other';
    }
  }
}

extension SendFailureMapperExtension on SendFailure {
  String toValue() {
    SendFailureMapper.ensureInitialized();
    return MapperContainer.globals.toValue<SendFailure>(this) as String;
  }
}

