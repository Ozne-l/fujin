import 'package:fujin/data/connectors/connector.dart';
import 'package:fujin/data/weigh_ins/weigh_in.dart';
import 'package:fujin/domain/writing/connector_failure.dart';

sealed class WeighInFailure implements ConnectorFailure {
  const WeighInFailure(this.weighIn, this.error);

  final WeighIn weighIn;
  @override
  final Object error;
}

final class MfpWeightNotWritten extends WeighInFailure {
  const MfpWeightNotWritten(super.weighIn, super.error);

  @override
  Connector get connector => Connector.mfp;
}

final class EkkloWeightNotWritten extends WeighInFailure {
  const EkkloWeightNotWritten(super.weighIn, super.error);

  @override
  Connector get connector => Connector.ekklo;
}
