import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/data/dev_chat/dev_chat_asset.dart';
import 'package:fujin/data/dev_chat/fake_chat.dart';
import 'package:fujin/data/dev_chat/fake_chat_token_store.dart';
import 'package:http/http.dart' as http;

final class FakeChatServer {
  FakeChatServer._(this._server, this._chat, this._loadAsset);

  static const port = 47321;
  static final Uri baseUri = Uri.parse(
    'http://${InternetAddress.loopbackIPv4.address}:$port',
  );
  static const _socketPath = '/api/v1/messaging/ws';
  static const _apiPrefix = '/api/';
  static const _bytesUnit = 'bytes=';
  static final _sending = Expando<bool>();
  static const _contentTypes = {
    'jpg': 'image/jpeg',
    'jpeg': 'image/jpeg',
    'png': 'image/png',
    'mp4': 'video/mp4',
    'm4a': 'audio/mp4',
  };

  final HttpServer _server;
  final FakeChat _chat;
  final Future<ByteData> Function(String key) _loadAsset;
  final _files = <String, Uint8List>{};

  static Future<FakeChatServer?> start(
    FakeChat chat, {
    required Future<ByteData> Function(String name) loadAsset,
  }) async {
    try {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
      return FakeChatServer._(server, chat, loadAsset).._listen();
    } on SocketException {
      return null;
    }
  }

  static EkkloClient client({http.Client? httpClient}) => EkkloClient(
    tokenStore: const FakeChatTokenStore(),
    httpClient: httpClient,
    baseUri: baseUri,
  );

  Future<void> close() => _server.close(force: true);

  void _listen() => _server.listen((request) => unawaited(_serve(request)));

  Future<void> _serve(HttpRequest request) async {
    final path = request.uri.path;
    try {
      switch (path) {
        case _ when path.startsWith(_apiPrefix) && !_authorized(request):
          await _reply(request, HttpStatus.unauthorized, null);
        case _socketPath when WebSocketTransformer.isUpgradeRequest(request):
          _attach(await WebSocketTransformer.upgrade(request));
        case _ when path.startsWith(_apiPrefix):
          final reply = _chat.handle(
            request.method,
            request.uri,
            await _bodyOf(request),
          );
          await _reply(request, reply.status, reply.body);
        case _ when path.startsWith(FakeChat.uploadsPath):
          await _upload(request, path.substring(FakeChat.uploadsPath.length));
        case _ when path.startsWith(FakeChat.mediaPath):
          await _media(request, path.substring(FakeChat.mediaPath.length));
        case _:
          await _reply(request, HttpStatus.notFound, null);
      }
    } on Object {
      await _abort(request.response);
    }
  }

  static Future<void> _abort(HttpResponse response) async {
    if (_sending[response] == null) {
      response.statusCode = HttpStatus.internalServerError;
    }
    await response.close().catchError((Object _) {});
  }

  bool _authorized(HttpRequest request) =>
      request.headers.value(HttpHeaders.authorizationHeader) ==
      'Bearer ${FakeChat.ownerTokens.accessToken}';

  void _attach(WebSocket socket) {
    final frames = _chat.frames.listen(socket.add);
    socket.listen(
      (data) {
        if (data case final String text) _chat.receiveFrame(text);
      },
      onDone: () => unawaited(frames.cancel()),
      onError: (Object _) => unawaited(frames.cancel()),
    );
  }

  static Future<Object?> _bodyOf(HttpRequest request) async {
    final text = await utf8.decodeStream(request);
    return text.isEmpty ? null : jsonDecode(text);
  }

  static Future<void> _reply(HttpRequest request, int status, Object? body) {
    request.response.statusCode = status;
    _sending[request.response] = true;
    if (body != null) {
      request.response
        ..headers.contentType = ContentType.json
        ..write(jsonEncode(body));
    }
    return request.response.close();
  }

  Future<void> _upload(HttpRequest request, String key) async {
    final bytes = BytesBuilder(copy: false);
    await request.forEach(bytes.add);
    _files[key] = bytes.takeBytes();
    await _reply(request, HttpStatus.ok, null);
  }

  Future<void> _media(HttpRequest request, String key) async {
    final bytes = await _bytesOf(key);
    final response = request.response;
    if (bytes == null) return _reply(request, HttpStatus.notFound, null);
    final range = _rangeOf(
      request.headers.value(HttpHeaders.rangeHeader),
      bytes.length,
    );
    if (range == null) {
      response.headers.set(
        HttpHeaders.contentRangeHeader,
        'bytes */${bytes.length}',
      );
      return _reply(request, HttpStatus.requestedRangeNotSatisfiable, null);
    }
    final (start, end) = range;
    response
      ..statusCode = switch ((start, end + 1 == bytes.length)) {
        (0, true) => HttpStatus.ok,
        _ => HttpStatus.partialContent,
      }
      ..headers.set(HttpHeaders.acceptRangesHeader, 'bytes')
      ..headers.contentLength = end - start + 1
      ..headers.set(
        HttpHeaders.contentTypeHeader,
        _contentTypes[key.split('.').last.toLowerCase()] ??
            ContentType.binary.mimeType,
      );
    if (response.statusCode == HttpStatus.partialContent) {
      response.headers.set(
        HttpHeaders.contentRangeHeader,
        'bytes $start-$end/${bytes.length}',
      );
    }
    _sending[response] = true;
    if (request.method != 'HEAD') {
      response.add(Uint8List.sublistView(bytes, start, end + 1));
    }
    await response.close();
  }

  Future<Uint8List?> _bytesOf(String key) async {
    if (_files[key] case final bytes?) return bytes;
    final asset = DevChatAsset.named(key);
    if (asset == null) return null;
    final data = await _loadAsset(asset.key);
    return _files[key] = data.buffer.asUint8List(
      data.offsetInBytes,
      data.lengthInBytes,
    );
  }

  static (int, int)? _rangeOf(String? header, int length) {
    final last = length - 1;
    if (header == null || !header.startsWith(_bytesUnit)) return (0, last);
    final (start, end) = switch (header
        .substring(_bytesUnit.length)
        .split('-')) {
      [final from, final to] => switch ((
        int.tryParse(from),
        int.tryParse(to),
      )) {
        (final start?, final end?) when start <= end => (start, min(end, last)),
        (final start?, null) => (start, last),
        (null, final suffix?) when suffix > 0 => (
          max(length - suffix, 0),
          last,
        ),
        (null, _?) => (length, last),
        _ => (0, last),
      },
      _ => (0, last),
    };
    return switch (start > last) {
      true => null,
      false => (start, end),
    };
  }
}
