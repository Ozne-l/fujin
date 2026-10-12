sealed class UndoOutcome {
  const UndoOutcome();
}

final class Undone extends UndoOutcome {
  const Undone();
}

final class StillInMfp extends UndoOutcome {
  const StillInMfp(this.error);

  final Object error;
}

final class NotUndone extends UndoOutcome {
  const NotUndone(this.error);

  final Object error;
}
