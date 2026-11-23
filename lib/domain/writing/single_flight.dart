final class SingleFlight {
  SingleFlight(this._pass);

  final Future<void> Function() _pass;
  Future<void>? _running;
  bool _again = false;

  Future<void> run() {
    if (_running case final running?) {
      _again = true;
      return running;
    }
    return _running = _passes().whenComplete(() => _running = null);
  }

  Future<void> _passes() async {
    do {
      _again = false;
      await _pass();
    } while (_again);
  }
}
