import 'package:fujin/data/upload/upload_order.dart';
import 'package:fujin/data/upload/upload_update.dart';

abstract interface class MediaUploader {
  Stream<UploadUpdate> get updates;

  Future<void> start();

  Future<Set<String>> activeUploads();

  Future<bool> enqueue(UploadOrder order);

  Future<void> cancel(String messageId);
}
