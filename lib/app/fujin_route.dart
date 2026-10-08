enum FujinRoute {
  journal('/'),
  welcome('/welcome'),
  mfpSignIn('/mfp-sign-in'),
  ekkloSignIn('/ekklo-sign-in');

  const FujinRoute(this.path);

  final String path;
}
