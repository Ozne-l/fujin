// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'chat_media_kind.dart';

class ChatMediaKindMapper extends EnumMapper<ChatMediaKind> {
  ChatMediaKindMapper._();

  static ChatMediaKindMapper? _instance;
  static ChatMediaKindMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ChatMediaKindMapper._());
    }
    return _instance!;
  }

  static ChatMediaKind fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  ChatMediaKind decode(dynamic value) {
    switch (value) {
      case r'image':
        return ChatMediaKind.image;
      case r'video':
        return ChatMediaKind.video;
      case r'voice':
        return ChatMediaKind.voice;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(ChatMediaKind self) {
    switch (self) {
      case ChatMediaKind.image:
        return r'image';
      case ChatMediaKind.video:
        return r'video';
      case ChatMediaKind.voice:
        return r'voice';
    }
  }
}

extension ChatMediaKindMapperExtension on ChatMediaKind {
  String toValue() {
    ChatMediaKindMapper.ensureInitialized();
    return MapperContainer.globals.toValue<ChatMediaKind>(this) as String;
  }
}

