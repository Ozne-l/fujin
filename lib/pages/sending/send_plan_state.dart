import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/domain/sending/send_plan.dart';
import 'package:fujin/pages/sending/send_failure.dart';

part 'send_plan_state.mapper.dart';

@MappableClass(discriminatorKey: 'state')
sealed class SendPlanState with SendPlanStateMappable {
  const SendPlanState();
}

@MappableClass(discriminatorValue: 'searching')
final class SendPlanSearching extends SendPlanState
    with SendPlanSearchingMappable {
  const SendPlanSearching(this.plan);

  final SendPlan plan;
}

@MappableClass(discriminatorValue: 'ready')
final class SendPlanReady extends SendPlanState with SendPlanReadyMappable {
  const SendPlanReady(this.plan);

  final SendPlan plan;
}

@MappableClass(discriminatorValue: 'failed')
final class SendPlanFailed extends SendPlanState with SendPlanFailedMappable {
  const SendPlanFailed(this.plan, this.failure);

  final SendPlan plan;
  final SendFailure failure;
}
