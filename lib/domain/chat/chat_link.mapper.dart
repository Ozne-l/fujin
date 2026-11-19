// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'chat_link.dart';

class ChatLinkMapper extends EnumMapper<ChatLink> {
  ChatLinkMapper._();

  static ChatLinkMapper? _instance;
  static ChatLinkMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ChatLinkMapper._());
    }
    return _instance!;
  }

  static ChatLink fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  ChatLink decode(dynamic value) {
    switch (value) {
      case r'connecting':
        return ChatLink.connecting;
      case r'online':
        return ChatLink.online;
      case r'offline':
        return ChatLink.offline;
      case r'expired':
        return ChatLink.expired;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(ChatLink self) {
    switch (self) {
      case ChatLink.connecting:
        return r'connecting';
      case ChatLink.online:
        return r'online';
      case ChatLink.offline:
        return r'offline';
      case ChatLink.expired:
        return r'expired';
    }
  }
}

extension ChatLinkMapperExtension on ChatLink {
  String toValue() {
    ChatLinkMapper.ensureInitialized();
    return MapperContainer.globals.toValue<ChatLink>(this) as String;
  }
}

