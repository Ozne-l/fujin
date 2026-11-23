import 'package:dart_mappable/dart_mappable.dart';
import 'package:ekklo_client/ekklo_client.dart';

part 'post_outcome.mapper.dart';

@MappableClass(discriminatorKey: 'outcome')
sealed class PostOutcome with PostOutcomeMappable {
  const PostOutcome();
}

@MappableClass(discriminatorValue: 'posted')
final class MessagePosted extends PostOutcome with MessagePostedMappable {
  const MessagePosted(this.message);

  final EkkloMessage message;
}

@MappableClass(discriminatorValue: 'not_ready')
final class MessageNotReady extends PostOutcome with MessageNotReadyMappable {
  const MessageNotReady();
}

@MappableClass(discriminatorValue: 'waiting')
final class MessageWaiting extends PostOutcome with MessageWaitingMappable {
  const MessageWaiting();
}

@MappableClass(discriminatorValue: 'given_up')
final class MessageGivenUp extends PostOutcome with MessageGivenUpMappable {
  const MessageGivenUp();
}

@MappableClass(discriminatorValue: 'gone')
final class MessageGone extends PostOutcome with MessageGoneMappable {
  const MessageGone();
}
