import 'package:fujin/data/weigh_ins/logged_weigh_in.dart';
import 'package:fujin/data/weigh_ins/weigh_in.dart';

extension LiveWeighIn on List<LoggedWeighIn> {
  WeighIn? liveOn(DateTime day) => [
    for (final logged in this)
      if (logged.weighIn case final weighIn
          when weighIn.deletedAt == null && weighIn.date == day)
        weighIn,
  ].firstOrNull;
}
