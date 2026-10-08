import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/domain/sending/step_state.dart';

part 'send_step.mapper.dart';

@MappableClass(discriminatorKey: 'step')
sealed class SendStep with SendStepMappable {
  const SendStep({this.state = StepState.pending});

  final StepState state;

  int get entryCount;
}

@MappableClass(discriminatorValue: 'own_copy')
final class OwnCopyStep extends SendStep with OwnCopyStepMappable {
  const OwnCopyStep({
    required this.mfpFoodId,
    required this.name,
    super.state,
  });

  final String mfpFoodId;
  final String name;

  @override
  int get entryCount => 0;
}

@MappableClass(discriminatorValue: 'quantity_update')
final class QuantityUpdateStep extends SendStep
    with QuantityUpdateStepMappable {
  const QuantityUpdateStep({
    required this.entryId,
    required this.name,
    super.state,
  });

  final String entryId;
  final String name;

  @override
  int get entryCount => 1;
}

@MappableClass(discriminatorValue: 'meal')
final class MealStep extends SendStep with MealStepMappable {
  const MealStep({
    required this.ekkloMealName,
    required this.entryIds,
    super.state,
  });

  final String ekkloMealName;
  final List<String> entryIds;

  @override
  int get entryCount => entryIds.length;
}
