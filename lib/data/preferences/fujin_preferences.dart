import 'package:fujin/data/hints/hint.dart';
import 'package:fujin/data/settings/appearance.dart';
import 'package:fujin/data/settings/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract final class FujinPreferences {
  static Future<SharedPreferencesWithCache> open() =>
      SharedPreferencesWithCache.create(
        cacheOptions: SharedPreferencesWithCacheOptions(
          allowList: {
            for (final hint in Hint.values) hint.preferenceKey,
            for (final setting in Setting.values) setting.preferenceKey,
            Appearance.preferenceKey,
          },
        ),
      );
}
