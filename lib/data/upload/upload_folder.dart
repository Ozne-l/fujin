import 'dart:io';

final class UploadFolder {
  const UploadFolder(this._cache);

  static const name = 'chat_upload';

  final Directory _cache;

  Directory get root =>
      Directory('${_cache.path}${Platform.pathSeparator}$name');

  Directory of(String messageId) =>
      Directory('${root.path}${Platform.pathSeparator}$messageId');

  String file(String messageId, String fileName) =>
      '${of(messageId).path}${Platform.pathSeparator}$fileName';

  void create(String messageId) => of(messageId).createSync(recursive: true);

  String adopt(String path, String messageId, String fileName) {
    create(messageId);
    final target = file(messageId, fileName);
    try {
      File(path).renameSync(target);
    } on FileSystemException {
      File(path)
        ..copySync(target)
        ..deleteSync();
    }
    return target;
  }

  void delete(String messageId) {
    final folder = of(messageId);
    if (folder.existsSync()) folder.deleteSync(recursive: true);
  }

  void keepOnly(Set<String> messageIds) {
    if (!root.existsSync()) return;
    for (final entry in root.listSync()) {
      if (!messageIds.contains(entry.uri.pathSegments.lastWhere(_named))) {
        entry.deleteSync(recursive: true);
      }
    }
  }

  static bool _named(String segment) => segment.isNotEmpty;
}
