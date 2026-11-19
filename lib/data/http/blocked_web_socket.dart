import 'dart:io';

Future<Never> blockedWebSocket(Uri uri, Map<String, String> headers) async =>
    throw SocketException(
      'Blocked by the read-only dev environment: ${uri.path}',
    );
