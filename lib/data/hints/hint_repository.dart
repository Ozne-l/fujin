import 'package:fujin/data/hints/hint.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class HintRepository {
  const HintRepository(this._preferences);

  final SharedPreferencesWithCache _preferences;

  static Future<SharedPreferencesWithCache> openPreferences() =>
      SharedPreferencesWithCache.create(
        cacheOptions: SharedPreferencesWithCacheOptions(
          allowList: {for (final hint in Hint.values) hint.preferenceKey},
        ),
      );

  bool wasShown(Hint hint) => _preferences.getBool(hint.preferenceKey) ?? false;

  Future<void> markShown(Hint hint) =>
      _preferences.setBool(hint.preferenceKey, true);
}
