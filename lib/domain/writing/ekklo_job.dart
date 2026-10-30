import 'package:fujin/data/entries/ekklo_link.dart';
import 'package:fujin/domain/sending/planned_entry.dart';

sealed class EkkloJob {
  const EkkloJob();
}

final class EkkloSend extends EkkloJob {
  const EkkloSend(this.planned);

  final PlannedEntry planned;
}

final class EkkloRemoval extends EkkloJob {
  const EkkloRemoval(this.link);

  final EkkloLink link;
}
