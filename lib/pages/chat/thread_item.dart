import 'package:dart_mappable/dart_mappable.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/domain/chat/upload/message_upload.dart';
import 'package:fujin/pages/chat/message_delivery.dart';

part 'thread_item.mapper.dart';

@MappableClass(discriminatorKey: 'item')
sealed class ThreadItem with ThreadItemMappable {
  const ThreadItem();
}

@MappableClass(discriminatorValue: 'day')
final class ThreadDay extends ThreadItem with ThreadDayMappable {
  const ThreadDay(this.day);

  final DateTime day;
}

@MappableClass(discriminatorValue: 'message')
final class ThreadMessage extends ThreadItem with ThreadMessageMappable {
  const ThreadMessage({
    required this.message,
    required this.mine,
    this.quoted,
    this.quotesMine = false,
    this.delivery = MessageDelivery.sent,
    this.seen = false,
    this.postedFrom,
  });

  final EkkloMessage message;
  final bool mine;
  final EkkloMessage? quoted;
  final bool quotesMine;
  final MessageDelivery delivery;
  final bool seen;
  final String? postedFrom;
}

@MappableClass(discriminatorValue: 'upload')
final class ThreadUpload extends ThreadItem with ThreadUploadMappable {
  const ThreadUpload({
    required this.upload,
    this.quoted,
    this.quotesMine = false,
  });

  final MessageUpload upload;
  final EkkloMessage? quoted;
  final bool quotesMine;
}
