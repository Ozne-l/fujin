import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/connectors/connector.dart';
import 'package:fujin/data/weigh_ins/logged_weigh_in.dart';
import 'package:fujin/data/weigh_ins/mfp_weigh_in_link.dart';
import 'package:fujin/data/weigh_ins/weigh_in.dart';
import 'package:fujin/domain/weighing/kilograms.dart';

part 'weigh_in_debt.mapper.dart';

@MappableClass(discriminatorKey: 'debt')
sealed class WeighInDebt with WeighInDebtMappable {
  const WeighInDebt(this.weighIn);

  final WeighIn weighIn;

  Connector get connector;

  (Connector, String) get key => (connector, weighIn.id);

  static List<WeighInDebt> of(LoggedWeighIn logged) => switch (logged) {
    LoggedWeighIn(
      weighIn: final weighIn && WeighIn(deletedAt: _?),
      mfpLink: final link?,
    ) =>
      [MfpWeighInDeletion(weighIn, link)],
    LoggedWeighIn(weighIn: WeighIn(deletedAt: _?)) => const [],
    LoggedWeighIn(:final weighIn, :final ekkloLink, :final mfpLink) => [
      if (!_holds(ekkloLink?.kilograms, weighIn)) EkkloWeighInWrite(weighIn),
      if (!_holds(mfpLink?.kilograms, weighIn)) MfpWeighInWrite(weighIn),
    ],
  };

  static bool _holds(double? linked, WeighIn weighIn) => switch (linked) {
    final kilograms? => Kilograms.same(kilograms, weighIn.kilograms),
    null => false,
  };
}

@MappableClass(discriminatorValue: 'ekklo_write')
final class EkkloWeighInWrite extends WeighInDebt
    with EkkloWeighInWriteMappable {
  const EkkloWeighInWrite(super.weighIn);

  @override
  Connector get connector => Connector.ekklo;
}

@MappableClass(discriminatorValue: 'mfp_write')
final class MfpWeighInWrite extends WeighInDebt with MfpWeighInWriteMappable {
  const MfpWeighInWrite(super.weighIn);

  @override
  Connector get connector => Connector.mfp;
}

@MappableClass(discriminatorValue: 'mfp_deletion')
final class MfpWeighInDeletion extends WeighInDebt
    with MfpWeighInDeletionMappable {
  const MfpWeighInDeletion(super.weighIn, this.link);

  final MfpWeighInLink link;

  @override
  Connector get connector => Connector.mfp;
}
