import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/connectors/connector.dart';
import 'package:fujin/data/connectors/connector_domain.dart';
import 'package:fujin/data/connectors/role.dart';

part 'connector_roles.mapper.dart';

@MappableClass()
final class ConnectorRoles with ConnectorRolesMappable {
  const ConnectorRoles({required this.mfp, required this.ekklo});

  factory ConnectorRoles.defaults(ConnectorDomain domain) => ConnectorRoles(
    mfp: defaultOf(Connector.mfp, domain),
    ekklo: defaultOf(Connector.ekklo, domain),
  );

  final Role mfp;
  final Role ekklo;

  Role of(Connector connector) => switch (connector) {
    Connector.mfp => mfp,
    Connector.ekklo => ekklo,
  };

  ConnectorRoles withRole(Connector connector, Role role) =>
      switch (connector) {
        Connector.mfp => ConnectorRoles(mfp: role, ekklo: ekklo),
        Connector.ekklo => ConnectorRoles(mfp: mfp, ekklo: role),
      };

  static List<Role> offered(Connector connector, ConnectorDomain domain) =>
      switch ((connector, domain)) {
        (Connector.mfp, ConnectorDomain.food) => const [
          Role.twoWay,
          Role.receiveOnly,
        ],
        (Connector.ekklo, ConnectorDomain.food) => const [Role.receiveOnly],
      };

  static Role defaultOf(Connector connector, ConnectorDomain domain) =>
      switch ((connector, domain)) {
        (Connector.mfp, ConnectorDomain.food) => Role.twoWay,
        (Connector.ekklo, ConnectorDomain.food) => Role.receiveOnly,
      };

  static String preferenceKey(Connector connector, ConnectorDomain domain) =>
      'setting_role_${connector.name}_${domain.name}';
}
