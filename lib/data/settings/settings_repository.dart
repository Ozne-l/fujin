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
}
