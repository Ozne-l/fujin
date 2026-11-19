import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';

final class MediaScratch {
  const MediaScratch(this._cache);

  static const _folder = 'chat_scratch';
  static const _frameExtension = '.jpg';

  final Directory _cache;

  Directory get folder =>
      Directory('${_cache.path}${Platform.pathSeparator}$_folder');

  Future<String> frame(String source, Duration at, int maxSize) async {
    final directory = await folder.create(recursive: true);
    final name = sha1.convert(
      utf8.encode('$source ${at.inMilliseconds} $maxSize'),
    );
    return '${directory.path}${Platform.pathSeparator}$name$_frameExtension';
  }

  Future<void> clear() async {
    try {
      await folder.delete(recursive: true);
    } on FileSystemException {
      return;
    }
  }
}
