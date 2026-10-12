import 'package:fujin/app/providers.dart';
import 'package:fujin/data/settings/setting.dart';
import 'package:fujin/domain/sending/send_mode.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final automaticModeProvider = NotifierProvider<AutomaticModeNotifier, bool>(
  AutomaticModeNotifier.new,
);

final class AutomaticModeNotifier extends Notifier<bool> {
  @override
  bool build() =>
      ref.watch(settingsRepositoryProvider).isOn(Setting.automaticMode);

  SendMode get sendMode => switch (state) {
    true => SendMode.automatic,
    false => SendMode.reviewed,
  };

  Future<void> turn({required bool on}) async {
    state = on;
    await ref
        .read(settingsRepositoryProvider)
        .turn(Setting.automaticMode, on: on);
  }
}
