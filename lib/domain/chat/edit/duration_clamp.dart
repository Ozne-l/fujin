extension DurationClamp on Duration {
  Duration clampedTo(Duration lowest, Duration highest) =>
      switch ((this < lowest, this > highest)) {
        (true, _) => lowest,
        (false, true) => highest,
        (false, false) => this,
      };
}
