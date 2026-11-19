import 'package:fujin/data/upload/relay_scheduler.dart';
import 'package:workmanager/workmanager.dart';

final class WorkmanagerRelayScheduler implements RelayScheduler {
  const WorkmanagerRelayScheduler();

  static const taskName = 'chat-relay';
  static const messageKey = 'message';
  static const firstRun = Duration(seconds: 20);
  static const backoff = Duration(seconds: 10);

  static String uniqueName(String messageId) => '$taskName-$messageId';

  @override
  Future<void> schedule(String messageId) => Workmanager().registerOneOffTask(
    uniqueName(messageId),
    taskName,
    inputData: {messageKey: messageId},
    initialDelay: firstRun,
    constraints: Constraints(networkType: NetworkType.connected),
    existingWorkPolicy: ExistingWorkPolicy.keep,
    backoffPolicy: BackoffPolicy.linear,
    backoffPolicyDelay: backoff,
  );

  @override
  Future<void> cancel(String messageId) =>
      Workmanager().cancelByUniqueName(uniqueName(messageId));
}
