import 'package:flutter/widgets.dart';

final class FakeScanCamera {
  ValueChanged<String>? _onRead;
  VoidCallback? _onRefused;
  bool torch = false;

  Widget build({
    required bool torch,
    required ValueChanged<String> onRead,
    required VoidCallback onRefused,
  }) {
    this.torch = torch;
    _onRead = onRead;
    _onRefused = onRefused;
    return const SizedBox.expand();
  }

  void read(String code) => _onRead?.call(code);

  void refuse() => _onRefused?.call();
}
