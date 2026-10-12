import 'package:fujin/data/hints/hint.dart';
import 'package:fujin/data/preferences/fujin_preferences.dart';
import 'package:fujin/data/settings/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

Future<SharedPreferencesWithCache> inMemoryPreferences({
  Iterable<Hint> shown = Hint.values,
  Iterable<Setting> on = const [],
}) {
  SharedPreferencesAsyncPlatform.instance =
      InMemorySharedPreferencesAsync.withData({
        for (final hint in shown) hint.preferenceKey: true,
        for (final setting in on) setting.preferenceKey: true,
      });
  return FujinPreferences.open();
}
