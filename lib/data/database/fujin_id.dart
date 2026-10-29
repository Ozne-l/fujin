import 'package:uuid/data.dart';
import 'package:uuid/uuid.dart';

abstract final class FujinId {
  static const sqlFunction = 'fujin_id';

  static String at(DateTime time) =>
      const Uuid().v7(config: V7Options(time.millisecondsSinceEpoch, null));
}
