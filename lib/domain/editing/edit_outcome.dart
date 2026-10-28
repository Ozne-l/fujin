import 'package:fujin/domain/editing/edited_food.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

sealed class EditOutcome {
  const EditOutcome();
}

final class Edited extends EditOutcome {
  const Edited(this.edited);

  final EditedFood edited;
}

final class EditFoodChanged extends EditOutcome {
  const EditFoodChanged({required this.before, required this.after});

  final MfpFood before;
  final MfpFood after;
}

final class NotEdited extends EditOutcome {
  const NotEdited(this.error);

  final Object error;
}

final class EkkloNotUpdated extends EditOutcome {
  const EkkloNotUpdated(this.edited, this.error);

  final EditedFood edited;
  final Object error;
}

final class OldEntryKept extends EditOutcome {
  const OldEntryKept(this.edited, this.error);

  final EditedFood edited;
  final Object error;
}
