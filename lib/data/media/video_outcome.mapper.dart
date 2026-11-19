// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'video_outcome.dart';

class VideoOutcomeMapper extends EnumMapper<VideoOutcome> {
  VideoOutcomeMapper._();

  static VideoOutcomeMapper? _instance;
  static VideoOutcomeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = VideoOutcomeMapper._());
    }
    return _instance!;
  }

  static VideoOutcome fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  VideoOutcome decode(dynamic value) {
    switch (value) {
      case r'encoded':
        return VideoOutcome.encoded;
      case r'toneMapped':
        return VideoOutcome.toneMapped;
      case r'original':
        return VideoOutcome.original;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(VideoOutcome self) {
    switch (self) {
      case VideoOutcome.encoded:
        return r'encoded';
      case VideoOutcome.toneMapped:
        return r'toneMapped';
      case VideoOutcome.original:
        return r'original';
    }
  }
}

extension VideoOutcomeMapperExtension on VideoOutcome {
  String toValue() {
    VideoOutcomeMapper.ensureInitialized();
    return MapperContainer.globals.toValue<VideoOutcome>(this) as String;
  }
}

