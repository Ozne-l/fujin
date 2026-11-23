import 'package:fujin/app/providers.dart';
import 'package:fujin/data/weigh_ins/logged_weigh_in.dart';
import 'package:fujin/data/weigh_ins/weigh_in.dart';
import 'package:fujin/pages/weigh_ins/weigh_in_write_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final NotifierProvider<WeighInsNotifier, List<LoggedWeighIn>> weighInsProvider =
    NotifierProvider<WeighInsNotifier, List<LoggedWeighIn>>(
      WeighInsNotifier.new,
    );

final class WeighInsNotifier extends Notifier<List<LoggedWeighIn>> {
  @override
  List<LoggedWeighIn> build() {
    ref.watch(weighInWriteProvider);
    return _listed();
  }

  WeighIn save({required DateTime date, required double kilograms}) {
    final saved = ref
        .read(weighInServiceProvider)
        .save(date: date, kilograms: kilograms);
    state = _listed();
    return saved;
  }

  void remove(WeighIn weighIn) {
    ref.read(weighInServiceProvider).remove(weighIn.id);
    state = _listed();
  }

  List<LoggedWeighIn> _listed() => ref.read(weighInRepositoryProvider).listed();
}
