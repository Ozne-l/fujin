enum AppEnvironment {
  production,
  dev;

  static AppEnvironment fromFlavor(String? flavor) => switch (flavor) {
    null => throw StateError(
      'Build with --flavor production or --flavor dev',
    ),
    final name => values.byName(name),
  };
}
