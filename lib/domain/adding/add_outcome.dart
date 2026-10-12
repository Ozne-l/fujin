import 'package:fujin/domain/adding/added_food.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

sealed class AddOutcome {
  const AddOutcome();
}

final class Added extends AddOutcome {
  const Added(this.added);

  final AddedFood added;
}

final class FoodChanged extends AddOutcome {
  const FoodChanged({required this.before, required this.after});

  final MfpFood before;
  final MfpFood after;
}

final class NotAdded extends AddOutcome {
  const NotAdded(this.error);

  final Object error;
}

final class EkkloFailed extends AddOutcome {
  const EkkloFailed(this.added, this.error);

  final AddedFood added;
  final Object error;
}
