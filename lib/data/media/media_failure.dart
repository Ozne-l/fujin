enum MediaFailure {
  invalidRequest,
  unreadableSource,
  networkFailed,
  writeFailed,
  exportFailed,
  busy,
  cancelled,
  foregroundRefused,
  unsupported,
  failed;

  static MediaFailure of(String code) =>
      MediaFailure.values.asNameMap()[code] ?? MediaFailure.failed;
}
