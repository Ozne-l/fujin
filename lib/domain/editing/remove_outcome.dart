sealed class RemoveOutcome {
  const RemoveOutcome();
}

final class Removed extends RemoveOutcome {
  const Removed({required this.ekkloRemoved});

  final bool ekkloRemoved;
}

final class StillInMfp extends RemoveOutcome {
  const StillInMfp(this.error);

  final Object error;
}

final class NotRemoved extends RemoveOutcome {
  const NotRemoved(this.error);

  final Object error;
}
