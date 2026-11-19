// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'message_in_progress_state.dart';

class MessageInProgressStateMapper extends EnumMapper<MessageInProgressState> {
  MessageInProgressStateMapper._();

  static MessageInProgressStateMapper? _instance;
  static MessageInProgressStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MessageInProgressStateMapper._());
    }
    return _instance!;
  }

  static MessageInProgressState fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  MessageInProgressState decode(dynamic value) {
    switch (value) {
      case r'processing':
        return MessageInProgressState.processing;
      case r'uploading':
        return MessageInProgressState.uploading;
      case r'failed':
        return MessageInProgressState.failed;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(MessageInProgressState self) {
    switch (self) {
      case MessageInProgressState.processing:
        return r'processing';
      case MessageInProgressState.uploading:
        return r'uploading';
      case MessageInProgressState.failed:
        return r'failed';
    }
  }
}

extension MessageInProgressStateMapperExtension on MessageInProgressState {
  String toValue() {
    MessageInProgressStateMapper.ensureInitialized();
    return MapperContainer.globals.toValue<MessageInProgressState>(this)
        as String;
  }
}

