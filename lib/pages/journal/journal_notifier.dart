import 'package:fujin/app/providers.dart';
import 'package:fujin/domain/journal/calendar_week.dart';
import 'package:fujin/domain/journal/journal_read.dart';
import 'package:fujin/domain/journal/journal_service.dart';
import 'package:fujin/pages/journal/refresh_outcome.dart';
import 'package:fujin/pages/journal/selected_day.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart';

Duration? _noRetry(int retryCount, Object error) => null;

final mealNamesProvider = FutureProvider<List<String>>(
  (ref) => ref.watch(journalServiceProvider).mealNames(),
  retry: _noRetry,
);

final FutureProviderFamily<Map<DateTime, double?>, DateTime>
weekKilocaloriesProvider = FutureProvider.autoDispose
    .family<Map<DateTime, double?>, DateTime>((ref, monday) {
      final today = ref.watch(todayProvider);
      return ref
          .watch(journalServiceProvider)
          .loggedKilocalories(
            CalendarWeek.daysOf(monday).where((day) => !day.isAfter(today)),
          );
    }, retry: _noRetry);

final AsyncNotifierProviderFamily<JournalNotifier, JournalRead, DateTime>
journalProvider = AsyncNotifierProvider.autoDispose
    .family<JournalNotifier, JournalRead, DateTime>(
      JournalNotifier.new,
      retry: _noRetry,
    );

final class JournalNotifier extends AsyncNotifier<JournalRead> {
  JournalNotifier(this.date);

  final DateTime date;

  @override
  Future<JournalRead> build() => _read(
    ref.watch(journalServiceProvider),
    ref.watch(mealNamesProvider.future),
  );

  Future<RefreshOutcome> refresh() async {
    final before = state.value;
    final next = await _reread();
    return switch ((before, next)) {
      (BothSides(diary: final before), BothSides(diary: final after))
          when before == after =>
        RefreshOutcome.nothingNew,
      _ => RefreshOutcome.changed,
    };
  }

  Future<void> reload() => _reread();

  Future<JournalRead?> _reread() async {
    switch (ref.read(mealNamesProvider)) {
      case AsyncError():
        ref.invalidate(mealNamesProvider);
      case AsyncData() || AsyncLoading():
        break;
    }
    ref.invalidate(weekKilocaloriesProvider(CalendarWeek.mondayOf(date)));
    final next = await AsyncValue.guard(
      () => _read(
        ref.read(journalServiceProvider),
        ref.read(mealNamesProvider.future),
      ),
    );
    if (ref.mounted) state = next;
    return next.value;
  }

  Future<JournalRead> _read(
    JournalService service,
    Future<List<String>> mealNames,
  ) async => service.readJournal(
    date,
    mealNames: await mealNames.catchError((Object error) => const <String>[]),
  );
}
