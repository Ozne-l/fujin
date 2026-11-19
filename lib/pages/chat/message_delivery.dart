import 'package:dart_mappable/dart_mappable.dart';

part 'message_delivery.mapper.dart';

@MappableEnum()
enum MessageDelivery { sent, sending, failed, deleting }
