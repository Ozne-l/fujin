// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'read_problem.dart';

class ReadProblemMapper extends EnumMapper<ReadProblem> {
  ReadProblemMapper._();

  static ReadProblemMapper? _instance;
  static ReadProblemMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ReadProblemMapper._());
    }
    return _instance!;
  }

  static ReadProblem fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  ReadProblem decode(dynamic value) {
    switch (value) {
      case r'mfpSessionExpired':
        return ReadProblem.mfpSessionExpired;
      case r'ekkloSessionExpired':
        return ReadProblem.ekkloSessionExpired;
      case r'offline':
        return ReadProblem.offline;
      case r'mfpUnavailable':
        return ReadProblem.mfpUnavailable;
      case r'ekkloUnavailable':
        return ReadProblem.ekkloUnavailable;
      case r'unknown':
        return ReadProblem.unknown;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(ReadProblem self) {
    switch (self) {
      case ReadProblem.mfpSessionExpired:
        return r'mfpSessionExpired';
      case ReadProblem.ekkloSessionExpired:
        return r'ekkloSessionExpired';
      case ReadProblem.offline:
        return r'offline';
      case ReadProblem.mfpUnavailable:
        return r'mfpUnavailable';
      case ReadProblem.ekkloUnavailable:
        return r'ekkloUnavailable';
      case ReadProblem.unknown:
        return r'unknown';
    }
  }
}

extension ReadProblemMapperExtension on ReadProblem {
  String toValue() {
    ReadProblemMapper.ensureInitialized();
    return MapperContainer.globals.toValue<ReadProblem>(this) as String;
  }
}

