import 'package:fujin/app/providers.dart';
import 'package:fujin/data/connectors/connector.dart';
import 'package:fujin/data/connectors/connector_domain.dart';
import 'package:fujin/data/connectors/connector_roles.dart';
import 'package:fujin/data/connectors/role.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final foodRolesProvider = NotifierProvider<FoodRolesNotifier, ConnectorRoles>(
  FoodRolesNotifier.new,
);

final class FoodRolesNotifier extends Notifier<ConnectorRoles> {
  @override
  ConnectorRoles build() =>
      ref.watch(settingsRepositoryProvider).roles(ConnectorDomain.food);

  Future<void> choose(Connector connector, Role role) async {
    state = state.withRole(connector, role);
    await ref
        .read(settingsRepositoryProvider)
        .setRole(connector, ConnectorDomain.food, role);
  }
}
