import 'package:fujin/app/providers.dart';
import 'package:fujin/domain/journal/journal_day.dart';
import 'package:fujin/domain/journal/journal_service.dart';
import 'package:fujin/pages/journal/refresh_outcome.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart';

Duration? _noRetry(int retryCount, Object error) => null;

final mealNamesProvider = FutureProvider<List<String>>(
  (ref) => ref.watch(journalServiceProvider).mealNames(),
  retry: _noRetry,
);

final AsyncNotifierProviderFamily<JournalNotifier, JournalDay, DateTime>
journalProvider = AsyncNotifierProvider.autoDispose
    .family<JournalNotifier, JournalDay, DateTime>(
      JournalNotifier.new,
      retry: _noRetry,
    );

final class JournalNotifier extends AsyncNotifier<JournalDay> {
  JournalNotifier(this.date);

  final DateTime date;

  @override
  Future<JournalDay> build() => _read(
    ref.watch(journalServiceProvider),
    ref.watch(mealNamesProvider.future),
  );

  Future<RefreshOutcome> refresh() async {
    final before = state.value?.diary;
    final next = await _reread();
    return switch ((before, next?.diary)) {
      (final before?, final after?) when before == after =>
        RefreshOutcome.nothingNew,
      _ => RefreshOutcome.changed,
    };
  }

  Future<void> reload() => _reread();

  Future<JournalDay?> _reread() async {
    switch (ref.read(mealNamesProvider)) {
      case AsyncError():
        ref.invalidate(mealNamesProvider);
      case AsyncData() || AsyncLoading():
        break;
    }
    final next = await AsyncValue.guard(
      () => _read(
        ref.read(journalServiceProvider),
        ref.read(mealNamesProvider.future),
      ),
    );
    if (ref.mounted) state = next;
    return next.value;
  }

  Future<JournalDay> _read(
    JournalService service,
    Future<List<String>> mealNames,
  ) async => service.readDay(date, mealNames: await mealNames);
}
