import 'package:fujin/domain/sending/planned_entry.dart';

sealed class EntryPlanning {
  const EntryPlanning();
}

final class Planned extends EntryPlanning {
  const Planned(this.planned);

  final PlannedEntry planned;
}

final class NeedsEkkloFood extends EntryPlanning {
  const NeedsEkkloFood(this.ekkloFoodId);

  final String ekkloFoodId;
}

final class NeedsSearch extends EntryPlanning {
  const NeedsSearch(this.terms);

  final String terms;
}
