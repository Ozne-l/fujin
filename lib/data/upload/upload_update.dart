sealed class UploadUpdate {
  const UploadUpdate(this.fileId, this.publicUrl);

  final String fileId;
  final String publicUrl;
}

final class UploadProgressed extends UploadUpdate {
  const UploadProgressed(super.fileId, super.publicUrl, this.fraction);

  final double fraction;
}

final class UploadWaiting extends UploadUpdate {
  const UploadWaiting(super.fileId, super.publicUrl);
}

final class UploadCompleted extends UploadUpdate {
  const UploadCompleted(super.fileId, super.publicUrl);
}

final class UploadFailed extends UploadUpdate {
  const UploadFailed(super.fileId, super.publicUrl, {required this.expired});

  final bool expired;
}
