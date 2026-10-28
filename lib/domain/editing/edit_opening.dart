import 'package:fujin/domain/adding/add_draft.dart';

sealed class EditOpening {
  const EditOpening();
}

final class Opened extends EditOpening {
  const Opened(this.draft);

  final AddDraft draft;
}

final class OpenedOnNewVersion extends EditOpening {
  const OpenedOnNewVersion(this.draft);

  final AddDraft draft;
}

final class FoodUnreadable extends EditOpening {
  const FoodUnreadable();
}

final class ServingMissing extends EditOpening {
  const ServingMissing();
}
