import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fujin/data/sessions/session_key.dart';

final class SecureEkkloTokenStore implements EkkloTokenStore {
  const SecureEkkloTokenStore(this._storage);

  static const SessionKey _key = SessionKey.ekkloTokens;

  final FlutterSecureStorage _storage;

  @override
  Future<EkkloTokens?> read() async =>
      switch (await _storage.read(key: _key.storageKey)) {
        null => null,
        final json => EkkloTokensMapper.fromJson(json),
      };

  @override
  Future<void> write(EkkloTokens tokens) =>
      _storage.write(key: _key.storageKey, value: tokens.toJson());

  @override
  Future<void> clear() => _storage.delete(key: _key.storageKey);
}
