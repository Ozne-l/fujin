import 'package:flutter/services.dart';
import 'package:fujin/data/media/media_failure.dart';

final class MediaProcessingException implements Exception {
  const MediaProcessingException(this.failure, [this.detail]);

  factory MediaProcessingException.from(Object error) => switch (error) {
    MediaProcessingException() => error,
    PlatformException(:final code, :final message) => MediaProcessingException(
      MediaFailure.of(code),
      message,
    ),
    MissingPluginException() => const MediaProcessingException(
      MediaFailure.unsupported,
    ),
    _ => MediaProcessingException(MediaFailure.failed, '$error'),
  };

  final MediaFailure failure;
  final String? detail;

  @override
  String toString() => 'MediaProcessingException(${failure.name}, $detail)';
}
