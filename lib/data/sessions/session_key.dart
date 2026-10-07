enum SessionKey {
  mfpCookies('mfp_session_cookies'),
  ekkloTokens('ekklo_tokens');

  const SessionKey(this.storageKey);

  final String storageKey;
}
