import 'dart:async';

import 'package:fujin/data/upload/media_uploader.dart';
import 'package:fujin/data/upload/upload_order.dart';
import 'package:fujin/data/upload/upload_update.dart';

final class FakeMediaUploader implements MediaUploader {
  final List<UploadOrder> orders = [];
  final Set<String> active = {};
  final List<String> cancelled = [];
  final _updates = StreamController<UploadUpdate>.broadcast(sync: true);

  @override
  Stream<UploadUpdate> get updates => _updates.stream;

  @override
  Future<void> start() async {}

  @override
  Future<Set<String>> activeUploads() async => {...active};

  @override
  Future<bool> enqueue(UploadOrder order) async {
    orders.add(order);
    active.add(order.publicUrl);
    return true;
  }

  @override
  Future<void> cancel(String messageId) async {
    cancelled.add(messageId);
    active.removeAll([
      for (final order in orders)
        if (order.messageId == messageId) order.publicUrl,
    ]);
  }

  UploadOrder latest(String fileId) =>
      orders.lastWhere((order) => order.fileId == fileId);

  void progress(String fileId, double fraction) {
    final order = latest(fileId);
    _updates.add(UploadProgressed(fileId, order.publicUrl, fraction));
  }

  void complete(String fileId) => finish(latest(fileId));

  void completeAll() => [
    for (final order in orders)
      if (active.contains(order.publicUrl)) order,
  ].forEach(finish);

  void settle(UploadOrder order) => active.remove(order.publicUrl);

  void finish(UploadOrder order) {
    settle(order);
    _updates.add(UploadCompleted(order.fileId, order.publicUrl));
  }

  void fail(String fileId, {bool expired = false}) {
    final order = latest(fileId);
    settle(order);
    _updates.add(UploadFailed(fileId, order.publicUrl, expired: expired));
  }
}
