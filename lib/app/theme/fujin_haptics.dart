import 'dart:async';

import 'package:flutter/services.dart';

abstract final class FujinHaptics {
  static void select() => unawaited(HapticFeedback.selectionClick());

  static void threshold() => unawaited(HapticFeedback.lightImpact());

  static void press() => unawaited(HapticFeedback.mediumImpact());

  static void error() => unawaited(HapticFeedback.errorNotification());
}
