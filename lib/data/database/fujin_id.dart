import 'dart:math';

import 'package:fujin/data/database/id_source.dart';
import 'package:uuid/data.dart';
import 'package:uuid/uuid.dart';

abstract final class FujinId {
  static const sqlFunction = 'fujin_id';

  static String at(DateTime time) =>
      _atMillisecond(time.millisecondsSinceEpoch);

  static IdSource source(DateTime Function() clock) {
    var last = -1;
    return () {
      last = max(clock().millisecondsSinceEpoch, last + 1);
      return _atMillisecond(last);
    };
  }

  static String _atMillisecond(int millisecond) =>
      const Uuid().v7(config: V7Options(millisecond, null));
}
