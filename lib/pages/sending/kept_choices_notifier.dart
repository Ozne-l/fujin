import 'package:fujin/app/providers.dart';
import 'package:fujin/domain/sending/planned_entry.dart';
import 'package:fujin/pages/sending/kept_choices.dart';
import 'package:fujin/pages/sending/send_failure.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart';

final NotifierProviderFamily<KeptChoicesNotifier, KeptChoices, DateTime>
keptChoicesProvider = NotifierProvider.autoDispose
    .family<KeptChoicesNotifier, KeptChoices, DateTime>(
      KeptChoicesNotifier.new,
    );

final class KeptChoicesNotifier extends Notifier<KeptChoices> {
  KeptChoicesNotifier(this.date);

  final DateTime date;

  @override
  KeptChoices build() => const KeptChoices();

  Future<SendFailure?> keep(PlannedEntry planned) async {
    final id = planned.entryId;
    if (state.keeping.contains(id) || state.kept.containsKey(id)) return null;
    final environment = ref.read(appEnvironmentProvider);
    state = state.copyWith(keeping: {...state.keeping, id});
    try {
      await ref.read(sendServiceProvider).keep(planned);
    } on Object catch (error) {
      if (ref.mounted) {
        state = state.copyWith(keeping: {...state.keeping}..remove(id));
      }
      return SendFailure.of(error, environment);
    }
    if (ref.mounted) {
      state = KeptChoices(
        kept: {...state.kept, id: planned},
        keeping: {...state.keeping}..remove(id),
      );
    }
    return null;
  }
}
