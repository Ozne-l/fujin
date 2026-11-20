import 'dart:io';

import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart' show addTearDown, test;
import 'package:fujin/data/chat_media/chat_media_cache.dart';
import 'package:fujin/data/chat_media/chat_media_unavailable.dart';
import 'package:fujin/data/dev_chat/fake_chat.dart';
import 'package:fujin/data/media/media_failure.dart';
import 'package:fujin/data/media/video_probe.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../../support/fake_backends.dart';
import '../../support/fake_media_processor.dart';

const _plateBytes = [1, 2, 3, 4];
const _clipLength = Duration(seconds: 4);

final Uri _plate = chatMediaUri.resolve('${FakeChat.mediaPath}plate.jpg');
final Uri _clip = chatMediaUri.resolve('${FakeChat.mediaPath}squat.mp4');

final class _Cache {
  _Cache(this.backends, this.directory, this.media);

  final FakeBackends backends;
  final Directory directory;
  final FakeMediaProcessor media;

  ChatMediaCache open() => ChatMediaCache(
    directory: directory,
    http: backends.httpClient,
    media: media,
  );

  int get downloads => backends.requests
      .where((request) => request.url.host == chatMediaUri.host)
      .length;
}

_Cache _cache() {
  final root = Directory.systemTemp.createTempSync('chat-media-cache');
  addTearDown(() => root.deleteSync(recursive: true));
  final backends = FakeBackends();
  backends.chatMedia['plate.jpg'] = _plateBytes;
  return _Cache(
    backends,
    Directory('${root.path}/${ChatMediaCache.folderName}'),
    FakeMediaProcessor()
      ..probes['$_clip'] = const VideoProbe(
        uprightWidth: 480,
        uprightHeight: 854,
        rotation: 0,
        duration: _clipLength,
        hdr: false,
      ),
  );
}

void main() {
  test('downloads a picture once, even across app launches', () async {
    final cache = _cache();

    final first = await cache.open().file(_plate);
    final again = await cache.open().file(_plate);

    check(first.readAsBytesSync()).deepEquals(_plateBytes);
    check(again.path).equals(first.path);
    check(first.path).endsWith('.jpg');
    check(cache.downloads).equals(1);
  });

  test('shares one download between simultaneous readers', () async {
    final cache = _cache();
    final media = cache.open();

    final files = await Future.wait([media.file(_plate), media.file(_plate)]);

    check(files.map((file) => file.path).toSet()).length.equals(1);
    check(cache.downloads).equals(1);
  });

  test('keeps nothing when the download fails', () async {
    final cache = _cache();
    final missing = chatMediaUri.resolve('${FakeChat.mediaPath}gone.jpg');

    await check(cache.open().file(missing)).throws<ChatMediaUnavailable>();

    check(cache.directory.listSync()).isEmpty();
  });

  test(
    'keeps no partial file when the connection drops mid-download',
    () async {
      final cache = _cache();
      final dropping = MockClient.streaming(
        (request, _) async => http.StreamedResponse(
          Stream.fromFutures([
            Future.value(_plateBytes),
            Future.error(http.ClientException('connection reset')),
          ]),
          HttpStatus.ok,
        ),
      );
      final media = ChatMediaCache(
        directory: cache.directory,
        http: dropping,
        media: cache.media,
      );

      await check(media.file(_plate)).throws<ChatMediaUnavailable>();

      check(cache.directory.listSync()).isEmpty();
    },
  );

  test(
    'extracts a video poster once and remembers its size and length',
    () async {
      final cache = _cache();

      final poster = await cache.open().poster(_clip);
      final again = await cache.open().poster(_clip);

      check(poster).isNotNull()
        ..has(
          (poster) => poster.width,
          'width',
        ).equals(ChatMediaCache.posterSize)
        ..has((poster) => poster.duration, 'duration').equals(_clipLength);
      check(again).equals(poster);
      check(cache.media.frameRequests).length.equals(1);
      check(cache.media.frameRequests.single.at).equals(Duration.zero);
    },
  );

  test('reports a video it cannot read', () async {
    final cache = _cache();
    cache.media.failure = MediaFailure.networkFailed;

    await check(cache.open().poster(_clip)).throws<ChatMediaUnavailable>();
  });

  test('forgets every file', () async {
    final cache = _cache();
    final media = cache.open();
    await media.file(_plate);

    await media.deleteAll();
    await media.file(_plate);

    check(cache.downloads).equals(2);
  });
}
