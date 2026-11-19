// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'message_delivery.dart';

class MessageDeliveryMapper extends EnumMapper<MessageDelivery> {
  MessageDeliveryMapper._();

  static MessageDeliveryMapper? _instance;
  static MessageDeliveryMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MessageDeliveryMapper._());
    }
    return _instance!;
  }

  static MessageDelivery fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  MessageDelivery decode(dynamic value) {
    switch (value) {
      case r'sent':
        return MessageDelivery.sent;
      case r'sending':
        return MessageDelivery.sending;
      case r'failed':
        return MessageDelivery.failed;
      case r'deleting':
        return MessageDelivery.deleting;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(MessageDelivery self) {
    switch (self) {
      case MessageDelivery.sent:
        return r'sent';
      case MessageDelivery.sending:
        return r'sending';
      case MessageDelivery.failed:
        return r'failed';
      case MessageDelivery.deleting:
        return r'deleting';
    }
  }
}

extension MessageDeliveryMapperExtension on MessageDelivery {
  String toValue() {
    MessageDeliveryMapper.ensureInitialized();
    return MapperContainer.globals.toValue<MessageDelivery>(this) as String;
  }
}

