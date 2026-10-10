import 'dart:async';

import 'package:ekklo_client/ekklo_client.dart';

final class GatedEkkloTokenStore implements EkkloTokenStore {
  GatedEkkloTokenStore(this._inner);

  final EkkloTokenStore _inner;
  final _gate = Completer<void>();

  void open() => _gate.complete();

  @override
  Future<EkkloTokens?> read() async {
    await _gate.future;
    return _inner.read();
  }

  @override
  Future<void> write(EkkloTokens tokens) => _inner.write(tokens);

  @override
  Future<void> clear() => _inner.clear();
}
