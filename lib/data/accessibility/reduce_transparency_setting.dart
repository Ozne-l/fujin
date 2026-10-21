import 'package:flutter/services.dart';

abstract final class ReduceTransparencySetting {
  static const _channel = EventChannel('dev.oznel.fujin/reduce_transparency');

  static Stream<bool> watch() => _channel.receiveBroadcastStream().cast<bool>();
}
