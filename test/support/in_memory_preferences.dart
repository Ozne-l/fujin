import 'package:fujin/data/hints/hint.dart';
import 'package:fujin/data/hints/hint_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

Future<SharedPreferencesWithCache> inMemoryPreferences({
  Iterable<Hint> shown = Hint.values,
}) {
  SharedPreferencesAsyncPlatform.instance =
      InMemorySharedPreferencesAsync.withData({
        for (final hint in shown) hint.preferenceKey: true,
      });
  return HintRepository.openPreferences();
}
