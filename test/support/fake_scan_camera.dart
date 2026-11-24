import 'package:flutter/widgets.dart';
import 'package:fujin/pages/scanner/scanned_code.dart';

final class FakeScanCamera {
  ValueChanged<ScannedCode>? _onRead;
  VoidCallback? _onRefused;
  bool torch = false;

  Widget build({
    required bool torch,
    required ValueChanged<ScannedCode> onRead,
    required VoidCallback onRefused,
  }) {
    this.torch = torch;
    _onRead = onRead;
    _onRefused = onRefused;
    return const SizedBox.expand();
  }

  void read(String code, {Rect? bounds}) =>
      _onRead?.call((code: code, bounds: bounds));

  void refuse() => _onRefused?.call();
}
