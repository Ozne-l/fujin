import 'package:fujin/domain/editing/edited_food.dart';

sealed class EditOutcome {
  const EditOutcome();
}

final class Edited extends EditOutcome {
  const Edited(this.edited);

  final EditedFood edited;
}

final class NotEdited extends EditOutcome {
  const NotEdited(this.error);

  final Object error;
}
