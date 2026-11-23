import 'package:fujin/data/connectors/connector.dart';
import 'package:fujin/data/entries/logged_entry.dart';
import 'package:fujin/domain/writing/connector_failure.dart';

sealed class WriteFailure implements ConnectorFailure {
  const WriteFailure(this.logged, this.error);

  final LoggedEntry logged;
  @override
  final Object error;

  String get entryId => logged.entry.id;
}

final class MfpNotWritten extends WriteFailure {
  const MfpNotWritten(super.logged, super.error);

  @override
  Connector get connector => Connector.mfp;
}

final class EkkloNotWritten extends WriteFailure {
  const EkkloNotWritten(super.logged, super.error);

  @override
  Connector get connector => Connector.ekklo;
}
