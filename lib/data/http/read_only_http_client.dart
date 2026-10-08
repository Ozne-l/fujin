import 'package:http/http.dart' as http;

final class ReadOnlyHttpClient extends http.BaseClient {
  ReadOnlyHttpClient(this._inner, {required Uri ekkloBaseUri})
    : _sessionWrites = {
        ekkloBaseUri.resolve(_ekkloLoginPath),
        ekkloBaseUri.resolve(_ekkloRefreshPath),
      };

  static const _readMethods = {'GET', 'HEAD'};
  static const _ekkloLoginPath = '/api/v1/auth/login';
  static const _ekkloRefreshPath = '/api/v1/auth/login/refresh_token';
  static const _blocked = 'Blocked by the read-only dev environment';

  final http.Client _inner;
  final Set<Uri> _sessionWrites;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (!_allows(request)) {
      throw http.ClientException(
        '$_blocked: ${request.method} ${request.url.path}',
        request.url,
      );
    }
    return _inner.send(request);
  }

  @override
  void close() => _inner.close();

  bool _allows(http.BaseRequest request) =>
      _readMethods.contains(request.method.toUpperCase()) ||
      _sessionWrites.any(
        (uri) =>
            uri.origin == request.url.origin && uri.path == request.url.path,
      );
}
