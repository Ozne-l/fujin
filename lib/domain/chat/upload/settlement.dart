import 'package:dart_mappable/dart_mappable.dart';
import 'package:ekklo_client/ekklo_client.dart';

part 'settlement.mapper.dart';

@MappableClass(discriminatorKey: 'settlement')
sealed class Settlement with SettlementMappable {
  const Settlement();
}

@MappableClass(discriminatorValue: 'posted')
final class MessagePosted extends Settlement with MessagePostedMappable {
  const MessagePosted(this.message);

  final EkkloMessage message;
}

@MappableClass(discriminatorValue: 'not_ready')
final class MessageNotReady extends Settlement with MessageNotReadyMappable {
  const MessageNotReady();
}

@MappableClass(discriminatorValue: 'waiting')
final class MessageWaiting extends Settlement with MessageWaitingMappable {
  const MessageWaiting();
}

@MappableClass(discriminatorValue: 'given_up')
final class MessageGivenUp extends Settlement with MessageGivenUpMappable {
  const MessageGivenUp();
}

@MappableClass(discriminatorValue: 'gone')
final class MessageGone extends Settlement with MessageGoneMappable {
  const MessageGone();
}
