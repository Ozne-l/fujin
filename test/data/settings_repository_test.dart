import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart' show group, test;
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
}
