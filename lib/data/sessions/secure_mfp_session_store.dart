import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fujin/data/sessions/session_key.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

final class SecureMfpSessionStore implements MfpSessionStore {
  const SecureMfpSessionStore(this._storage);

  static const SessionKey _key = SessionKey.mfpCookies;

  final FlutterSecureStorage _storage;

  @override
  Future<MfpSessionCookies?> read() async =>
      switch (await _storage.read(key: _key.storageKey)) {
        null => null,
        final json => MfpSessionCookiesMapper.fromJson(json),
      };

  @override
  Future<void> write(MfpSessionCookies cookies) =>
      _storage.write(key: _key.storageKey, value: cookies.toJson());

  @override
  Future<void> clear() => _storage.delete(key: _key.storageKey);
}
