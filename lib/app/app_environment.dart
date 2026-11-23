enum AppEnvironment {
  production,
  dev;

  bool get readOnly => switch (this) {
    production => false,
    dev => true,
  };

  static AppEnvironment fromFlavor(String? flavor) => switch (flavor) {
    null => throw StateError(
      'Build with --flavor production or --flavor dev',
    ),
    final name => values.byName(name),
  };
}
