import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:fujin/data/chat_media/chat_media_unavailable.dart';
import 'package:fujin/data/chat_media/video_poster.dart';
import 'package:fujin/data/media/frame_request.dart';
import 'package:fujin/data/media/media_processing_exception.dart';
import 'package:fujin/data/media/media_processor.dart';
import 'package:http/http.dart' as http;

final class ChatMediaCache {
  ChatMediaCache({
    required this._directory,
    required this._http,
    required this._media,
  });

  static const folderName = 'chat_media';
  static const posterSize = 720;
  static const _partSuffix = '.part';
  static const _posterSuffix = '.poster.jpg';
  static const _posterInfoSuffix = '.poster.json';
  static const _okStatus = 200;
  static final _extension = RegExp(r'^[a-z0-9]{1,5}$');

  final Directory _directory;
  final http.Client _http;
  final MediaProcessor _media;
  final _files = <String, Future<File>>{};
  final _posters = <String, Future<VideoPoster?>>{};

  Future<File> file(Uri url) async {
    final target = File('${_directory.path}/${_nameOf(url)}');
    if (target.existsSync()) return target;
    return _files[target.path] ??=
        _download(
          url,
          target,
        ).whenComplete(
          () => _files.removeWhere((path, _) => path == target.path),
        );
  }

  Future<VideoPoster?> poster(Uri videoUrl) async {
    final base = '${_directory.path}/${_hashOf(videoUrl)}';
    final info = File('$base$_posterInfoSuffix');
    if (info.existsSync()) {
      return VideoPosterMapper.fromJson(await info.readAsString());
    }
    return _posters[base] ??= _extract(
      videoUrl,
      base,
      info,
    ).whenComplete(() => _posters.removeWhere((path, _) => path == base));
  }

  Future<void> deleteAll() async {
    if (_directory.existsSync()) await _directory.delete(recursive: true);
  }

  Future<File> _download(Uri url, File target) async {
    await _directory.create(recursive: true);
    final part = File('${target.path}$_partSuffix');
    try {
      final response = await _http.send(http.Request('GET', url));
      if (response.statusCode != _okStatus) {
        await response.stream.drain<void>();
        throw ChatMediaUnavailable(url, '${response.statusCode}');
      }
      await response.stream.pipe(part.openWrite());
      return await part.rename(target.path);
    } on http.ClientException catch (error) {
      throw ChatMediaUnavailable(url, error.message);
    } on FileSystemException catch (error) {
      throw ChatMediaUnavailable(url, error.message);
    }
  }

  Future<VideoPoster?> _extract(Uri url, String base, File info) async {
    await _directory.create(recursive: true);
    try {
      final frame = await _media.extractFrame(
        FrameRequest(
          source: '$url',
          output: '$base$_posterSuffix',
          at: Duration.zero,
          maxSize: posterSize,
        ),
      );
      if (frame == null) return null;
      final poster = VideoPoster(
        path: frame.path,
        width: frame.width,
        height: frame.height,
        duration: await _durationOf(url),
      );
      await info.writeAsString(poster.toJson());
      return poster;
    } on MediaProcessingException catch (error) {
      throw ChatMediaUnavailable(url, error.detail);
    }
  }

  Future<Duration?> _durationOf(Uri url) async {
    try {
      return (await _media.probeVideo('$url')).duration;
    } on MediaProcessingException {
      return null;
    }
  }

  static String _hashOf(Uri url) => '${sha256.convert(utf8.encode('$url'))}';

  static String _nameOf(Uri url) {
    final last = url.pathSegments.lastOrNull ?? '';
    final dot = last.lastIndexOf('.');
    final extension = dot < 0 ? '' : last.substring(dot + 1).toLowerCase();
    return switch (_extension.hasMatch(extension)) {
      true => '${_hashOf(url)}.$extension',
      false => _hashOf(url),
    };
  }
}
