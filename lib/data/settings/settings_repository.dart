import 'package:fujin/data/settings/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class SettingsRepository {
  const SettingsRepository(this._preferences);

  final SharedPreferencesWithCache _preferences;

  bool isOn(Setting setting) =>
      _preferences.getBool(setting.preferenceKey) ?? false;

  Future<void> turn(Setting setting, {required bool on}) =>
      _preferences.setBool(setting.preferenceKey, on);
}
