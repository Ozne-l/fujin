import 'dart:async';
import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:fujin/data/upload/media_uploader.dart';
import 'package:fujin/data/upload/upload_completion.dart';
import 'package:fujin/data/upload/upload_metadata.dart';
import 'package:fujin/data/upload/upload_notification_copy.dart';
import 'package:fujin/data/upload/upload_order.dart';
import 'package:fujin/data/upload/upload_update.dart';
import 'package:uuid/uuid.dart';

@pragma('vm:entry-point')
final class BackgroundMediaUploader implements MediaUploader {
  BackgroundMediaUploader({required this._cachePath, required this._copy});

  static const group = 'chat-upload';
  static const retries = 3;
  static const _method = 'PUT';
  static const _binary = 'binary';
  static const _highestPriority = 0;
  static const int _expiredStatus = HttpStatus.forbidden;
  static const _progressToken = '{progress}';
  static const Map<String, String> _headers = {'Content-Disposition': ''};

  final String? _cachePath;
  final UploadNotificationCopy _copy;
  final _updates = StreamController<UploadUpdate>.broadcast();
  StreamSubscription<TaskUpdate>? _subscription;

  @pragma('vm:entry-point')
  static Future<void> finished(TaskStatusUpdate update) async {
    if (update.status != TaskStatus.complete) return;
    if (UploadMetadata.decode(update.task.metaData) case UploadMetadata(
      :final fileId,
      :final publicUrl,
      cachePath: final cachePath?,
    )) {
      UploadCompletion.record(
        cachePath: cachePath,
        fileId: fileId,
        publicUrl: publicUrl,
        at: DateTime.now(),
      );
    }
  }

  @override
  Stream<UploadUpdate> get updates => _updates.stream;

  @override
  Future<void> start() async {
    if (_subscription != null) return;
    final downloader = FileDownloader();
    _subscription = downloader.updates.listen(_forward);
    await downloader.configure(
      androidConfig: [(Config.runInForeground, Config.always)],
    );
    await downloader.start(doRescheduleKilledTasks: false);
  }

  Future<void> close() async {
    await _subscription?.cancel();
    _subscription = null;
    await _updates.close();
  }

  @override
  Future<Set<String>> activeUploads() async => {
    for (final task in await FileDownloader().allTasks(group: group))
      if (UploadMetadata.decode(task.metaData) case UploadMetadata(
        :final publicUrl,
      ))
        publicUrl,
  };

  @override
  Future<bool> enqueue(UploadOrder order) {
    final file = File(order.path);
    return FileDownloader().enqueue(
      UploadTask.fromFile(
        file: file,
        taskId: const Uuid().v4(),
        url: '${order.url}',
        httpRequestMethod: _method,
        post: _binary,
        mimeType: order.mimeType,
        headers: _headers,
        group: group,
        updates: Updates.statusAndProgress,
        retries: retries,
        priority: _highestPriority,
        metaData: UploadMetadata(
          fileId: order.fileId,
          messageId: order.messageId,
          publicUrl: order.publicUrl,
          cachePath: _cachePath,
        ).toJson(),
        options: TaskOptions(onTaskFinished: finished),
        notificationConfig: TaskNotificationConfig(
          running: TaskNotification(
            _copy.title(order.notice.coach),
            _copy.progress(
              order.notice.count,
              order.position,
              _progressToken,
            ),
          ),
          progressBar: true,
        ),
      ),
    );
  }

  @override
  Future<void> cancel(String messageId) async {
    final downloader = FileDownloader();
    await downloader.cancelTasksWithIds([
      for (final task in await downloader.allTasks(group: group))
        if (UploadMetadata.decode(task.metaData)?.messageId == messageId)
          task.taskId,
    ]);
  }

  void _forward(TaskUpdate update) {
    if (update.task.group != group) return;
    final metadata = UploadMetadata.decode(update.task.metaData);
    if (metadata == null) return;
    final UploadMetadata(:fileId, :publicUrl) = metadata;
    final forwarded = switch (update) {
      TaskProgressUpdate(:final progress) when progress >= 0 && progress <= 1 =>
        UploadProgressed(fileId, publicUrl, progress),
      TaskProgressUpdate() => null,
      TaskStatusUpdate(status: TaskStatus.running) => UploadProgressed(
        fileId,
        publicUrl,
        0,
      ),
      TaskStatusUpdate(status: TaskStatus.complete) => UploadCompleted(
        fileId,
        publicUrl,
      ),
      TaskStatusUpdate(status: TaskStatus.waitingToRetry) => UploadWaiting(
        fileId,
        publicUrl,
      ),
      TaskStatusUpdate(status: TaskStatus.failed || TaskStatus.notFound) =>
        UploadFailed(
          fileId,
          publicUrl,
          expired: switch (update.exception) {
            TaskHttpException(httpResponseCode: _expiredStatus) => true,
            _ => update.responseStatusCode == _expiredStatus,
          },
        ),
      TaskStatusUpdate(
        status: TaskStatus.enqueued || TaskStatus.paused || TaskStatus.canceled,
      ) =>
        null,
    };
    if (forwarded != null) _updates.add(forwarded);
  }
}
