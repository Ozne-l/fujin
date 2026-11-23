import 'package:fujin/data/connectors/connector.dart';
import 'package:fujin/data/weigh_ins/logged_weigh_in.dart';
import 'package:fujin/data/weigh_ins/weigh_in.dart';
import 'package:fujin/domain/weighing/kilograms.dart';

abstract final class WeighInDebt {
  static List<Connector> of(LoggedWeighIn logged) => switch (logged) {
    LoggedWeighIn(weighIn: WeighIn(deletedAt: _?), mfpLink: _?) => const [
      Connector.mfp,
    ],
    LoggedWeighIn(weighIn: WeighIn(deletedAt: _?)) => const [],
    LoggedWeighIn(:final weighIn, :final ekkloLink, :final mfpLink) => [
      if (!_holds(ekkloLink?.kilograms, weighIn)) Connector.ekklo,
      if (!_holds(mfpLink?.kilograms, weighIn)) Connector.mfp,
    ],
  };

  static bool _holds(double? linked, WeighIn weighIn) => switch (linked) {
    final kilograms? => Kilograms.same(kilograms, weighIn.kilograms),
    null => false,
  };
}
