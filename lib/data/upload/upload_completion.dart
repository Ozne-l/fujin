import 'dart:io';

import 'package:fujin/data/chat/message_in_progress_repository.dart';
import 'package:fujin/data/database/cache_opening.dart';
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/upload/upload_marker.dart';

abstract final class UploadCompletion {
  static const markerFolder = 'chat_upload_done';

  static Directory markersOf(String cachePath) => Directory(
    '${File(cachePath).parent.path}${Platform.pathSeparator}$markerFolder',
  );

  static void record({
    required String cachePath,
    required String fileId,
    required String publicUrl,
    required DateTime at,
  }) {
    try {
      switch (FujinDatabase.openCacheInBackground(cachePath)) {
        case CacheOutdated():
          return;
        case CacheOpened(:final database):
          try {
            MessageInProgressRepository(
              database,
            ).completeFile(fileId, publicUrl: publicUrl, at: at);
          } finally {
            database.close();
          }
      }
    } on Object {
      final markers = markersOf(cachePath)..createSync(recursive: true);
      File('${markers.path}${Platform.pathSeparator}$fileId').writeAsStringSync(
        UploadMarker(publicUrl: publicUrl, at: at.toUtc()).toJson(),
      );
    }
  }

  static void sweep(
    MessageInProgressRepository messages, {
    required String cachePath,
  }) {
    final markers = markersOf(cachePath);
    if (!markers.existsSync()) return;
    for (final marker in markers.listSync().whereType<File>()) {
      if (UploadMarker.decode(marker.readAsStringSync()) case final done?) {
        messages.completeFile(
          marker.uri.pathSegments.last,
          publicUrl: done.publicUrl,
          at: done.at,
        );
      }
      marker.deleteSync();
    }
  }
}
