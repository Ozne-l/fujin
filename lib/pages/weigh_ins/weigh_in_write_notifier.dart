import 'dart:async';

import 'package:fujin/app/providers.dart';
import 'package:fujin/domain/weighing/weigh_in_writer_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final NotifierProvider<WeighInWriteNotifier, WeighInWriterState>
weighInWriteProvider =
    NotifierProvider<WeighInWriteNotifier, WeighInWriterState>(
      WeighInWriteNotifier.new,
    );

final class WeighInWriteNotifier extends Notifier<WeighInWriterState> {
  @override
  WeighInWriterState build() {
    final writer = ref.watch(weighInWriterProvider);
    final states = writer.states.listen((next) => state = next);
    ref.onDispose(states.cancel);
    return writer.state;
  }

  void run() => unawaited(ref.read(weighInWriterProvider).run());
}
