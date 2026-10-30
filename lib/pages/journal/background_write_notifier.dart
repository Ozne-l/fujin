import 'dart:async';

import 'package:fujin/app/providers.dart';
import 'package:fujin/domain/writing/writer_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final NotifierProvider<BackgroundWriteNotifier, WriterState>
backgroundWriteProvider =
    NotifierProvider<BackgroundWriteNotifier, WriterState>(
      BackgroundWriteNotifier.new,
    );

final class BackgroundWriteNotifier extends Notifier<WriterState> {
  @override
  WriterState build() {
    final writer = ref.watch(backgroundWriterProvider);
    final states = writer.states.listen((next) => state = next);
    ref.onDispose(states.cancel);
    return writer.state;
  }

  void run() => unawaited(ref.read(backgroundWriterProvider).run());
}
