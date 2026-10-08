enum FujinRoute {
  journal('/'),
  ekkloSignIn('/ekklo-sign-in');

  const FujinRoute(this.path);

  final String path;
}
