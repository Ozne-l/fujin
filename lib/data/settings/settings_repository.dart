import 'package:fujin/data/connectors/connector.dart';
import 'package:fujin/data/connectors/connector_domain.dart';
import 'package:fujin/data/connectors/connector_roles.dart';
import 'package:fujin/data/connectors/role.dart';
import 'package:fujin/data/settings/appearance.dart';
import 'package:fujin/data/settings/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class SettingsRepository {
  const SettingsRepository(this._preferences);

  final SharedPreferencesWithCache _preferences;

  bool isOn(Setting setting) =>
      _preferences.getBool(setting.preferenceKey) ?? false;

  Future<void> turn(Setting setting, {required bool on}) =>
      _preferences.setBool(setting.preferenceKey, on);

  Appearance appearance() {
    final stored = _preferences.getString(Appearance.preferenceKey);
    return Appearance.values.asNameMap()[stored] ?? Appearance.system;
  }

  Future<void> setAppearance(Appearance appearance) =>
      _preferences.setString(Appearance.preferenceKey, appearance.name);

  ConnectorRoles roles(ConnectorDomain domain) => ConnectorRoles(
    mfp: _role(Connector.mfp, domain),
    ekklo: _role(Connector.ekklo, domain),
  );

  Future<void> setRole(
    Connector connector,
    ConnectorDomain domain,
    Role role,
  ) => _preferences.setString(
    ConnectorRoles.preferenceKey(connector, domain),
    role.name,
  );

  Role _role(Connector connector, ConnectorDomain domain) {
    final stored = _preferences.getString(
      ConnectorRoles.preferenceKey(connector, domain),
    );
    return switch (Role.values.asNameMap()[stored]) {
      final role?
          when ConnectorRoles.offered(connector, domain).contains(role) =>
        role,
      _ => ConnectorRoles.defaultOf(connector, domain),
    };
  }
}
