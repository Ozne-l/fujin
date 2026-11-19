import 'package:fujin/data/upload/relay_scheduler.dart';

final class FakeRelayScheduler implements RelayScheduler {
  final Set<String> scheduled = {};

  @override
  Future<void> schedule(String messageId) async => scheduled.add(messageId);

  @override
  Future<void> cancel(String messageId) async => scheduled.remove(messageId);
}
