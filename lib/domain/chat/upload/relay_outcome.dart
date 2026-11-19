enum RelayOutcome {
  posted(finished: true),
  later(finished: false),
  gaveUp(finished: true),
  gone(finished: true),
  outdatedCache(finished: true);

  const RelayOutcome({required this.finished});

  final bool finished;
}
