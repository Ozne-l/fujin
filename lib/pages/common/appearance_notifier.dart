import 'package:fujin/app/providers.dart';
import 'package:fujin/data/settings/appearance.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final appearanceProvider = NotifierProvider<AppearanceNotifier, Appearance>(
  AppearanceNotifier.new,
);

final class AppearanceNotifier extends Notifier<Appearance> {
  @override
  Appearance build() => ref.watch(settingsRepositoryProvider).appearance();

  Future<void> choose(Appearance appearance) async {
    state = appearance;
    await ref.read(settingsRepositoryProvider).setAppearance(appearance);
  }
}
