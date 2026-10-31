import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart' show group, test;
import 'package:fujin/data/connectors/connector.dart';
import 'package:fujin/data/connectors/connector_domain.dart';
import 'package:fujin/data/connectors/connector_roles.dart';
import 'package:fujin/data/connectors/role.dart';
import 'package:fujin/data/preferences/fujin_preferences.dart';
import 'package:fujin/data/settings/appearance.dart';
import 'package:fujin/data/settings/settings_repository.dart';

import '../support/in_memory_preferences.dart';

void main() {
  group('the appearance', () {
    test('follows the system when nothing is stored', () async {
      final settings = SettingsRepository(await inMemoryPreferences());

      check(settings.appearance()).equals(Appearance.system);
    });

    test('follows the system when the stored value is unknown', () async {
      final preferences = await inMemoryPreferences();
      await preferences.setString(Appearance.preferenceKey, 'sepia');

      check(
        SettingsRepository(preferences).appearance(),
      ).equals(Appearance.system);
    });

    test('keeps the chosen appearance across launches', () async {
      final settings = SettingsRepository(await inMemoryPreferences());
      await settings.setAppearance(Appearance.dark);

      final reopened = SettingsRepository(await FujinPreferences.open());

      check(settings.appearance()).equals(Appearance.dark);
      check(reopened.appearance()).equals(Appearance.dark);
    });
  });

  group('the roles of the apps for food', () {
    String keyOf(Connector connector) =>
        ConnectorRoles.preferenceKey(connector, ConnectorDomain.food);

    test('are MyFitnessPal two-way and Ekklo receive only when nothing is '
        'stored', () async {
      final settings = SettingsRepository(await inMemoryPreferences());

      check(settings.roles(ConnectorDomain.food)).equals(
        const ConnectorRoles(mfp: Role.twoWay, ekklo: Role.receiveOnly),
      );
    });

    test('fall back to the default when the stored value is unknown', () async {
      final preferences = await inMemoryPreferences();
      await preferences.setString(keyOf(Connector.mfp), 'both');

      check(
        SettingsRepository(preferences).roles(ConnectorDomain.food).mfp,
      ).equals(Role.twoWay);
    });

    test('fall back to the default for a role the app cannot do', () async {
      final preferences = await inMemoryPreferences();
      await preferences.setString(keyOf(Connector.ekklo), Role.twoWay.name);

      check(
        SettingsRepository(preferences).roles(ConnectorDomain.food).ekklo,
      ).equals(Role.receiveOnly);
    });

    test('keep the chosen role across launches', () async {
      final settings = SettingsRepository(await inMemoryPreferences());
      await settings.setRole(
        Connector.mfp,
        ConnectorDomain.food,
        Role.receiveOnly,
      );

      final reopened = SettingsRepository(await FujinPreferences.open());

      check(
        reopened.roles(ConnectorDomain.food).mfp,
      ).equals(Role.receiveOnly);
    });
  });
}
