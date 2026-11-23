import 'dart:async';

import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/app/providers.dart';
import 'package:fujin/domain/journal/calendar_week.dart';
import 'package:fujin/domain/journal/fetch.dart';
import 'package:fujin/domain/journal/fresh_read_service.dart';
import 'package:fujin/domain/journal/journal_read.dart';
import 'package:fujin/pages/journal/refresh_outcome.dart';
import 'package:fujin/pages/journal/selected_day.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

const _heldFor = Duration(minutes: 5);

Duration? _noRetry(int retryCount, Object error) => null;

void _holdAfterLastListener(Ref ref) {
  var link = ref.keepAlive();
  Timer? release;
  void rearm() {
    if (ref.mounted) link = ref.keepAlive();
  }

  ref
    ..onCancel(() => release = Timer(_heldFor, () => link.close()))
    ..onResume(() {
      if (release case final timer? when !timer.isActive) {
        scheduleMicrotask(rearm);
      }
      release?.cancel();
      release = null;
    })
    ..onDispose(() => release?.cancel());
}

final mealNamesProvider = FutureProvider<List<String>>(
  (ref) => ref.watch(journalServiceProvider).mealNames(),
  retry: _noRetry,
);

final FutureProviderFamily<Fetched<MfpDiaryDay>, DateTime> mfpDiaryProvider =
    FutureProvider.autoDispose.family<Fetched<MfpDiaryDay>, DateTime>((
      ref,
      day,
    ) {
      _holdAfterLastListener(ref);
      return ref.watch(journalServiceProvider).fetchDiary(day);
    }, retry: _noRetry);

final FutureProviderFamily<Fetched<List<EkkloDailyMeal>>, DateTime>
ekkloMealsProvider = FutureProvider.autoDispose
    .family<Fetched<List<EkkloDailyMeal>>, DateTime>((ref, day) {
      _holdAfterLastListener(ref);
      return ref.watch(journalServiceProvider).fetchEkkloMeals(day);
    }, retry: _noRetry);

List<DateTime> _readableDays(Ref ref, DateTime monday) {
  final today = ref.watch(todayProvider);
  return [
    for (final day in CalendarWeek.daysOf(monday))
      if (!day.isAfter(today)) day,
  ];
}

final FutureProviderFamily<void, DateTime> weekReadProvider = FutureProvider
    .autoDispose
    .family<void, DateTime>((ref, monday) async {
      final days = _readableDays(ref, monday);
      for (final day in days) {
        ref.listen(ekkloMealsProvider(day), (_, _) {});
      }
      await Future.wait([
        for (final day in days) ref.watch(mfpDiaryProvider(day).future),
      ]);
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

  Future<JournalRead>? _firstReading;
  bool _keepShown = false;

  @override
  FutureOr<JournalRead> build() {
    final service = ref.watch(journalServiceProvider);
    final diary = ref.watch(mfpDiaryProvider(date));
    final meals = ref.watch(ekkloMealsProvider(date));
    final names = ref.watch(mealNamesProvider);
    return switch ((
      diary.isLoading || meals.isLoading,
      state,
      _held(diary),
      _held(meals),
      _heldNames(names),
    )) {
      (true, AsyncValue(:final error?, :final stackTrace?), _, _, _) =>
        Error.throwWithStackTrace(error, stackTrace),
      (true, AsyncValue(:final value?), _, _, _) when _keepShown => value,
      (_, _, final diary?, final meals?, final names?) => service.journalOf(
        date,
        diary: diary,
        meals: meals,
        mealNames: names,
      ),
      (true, AsyncValue(:final value?), _, _, _) => value,
      _ => _sharedFirstRead(
        ref.watch(freshReadServiceProvider),
        ref.watch(mfpDiaryProvider(date).future),
        ref.watch(ekkloMealsProvider(date).future),
        ref.watch(mealNamesProvider.future),
      ),
    };
  }

  Future<RefreshOutcome> refresh() async {
    final before = switch (state.value) {
      BothSides() => ref.read(mfpDiaryProvider(date)).value?.value,
      MfpOnly() || FujinOnly() || EkkloOnly() || null => null,
    };
    final (diary, meals) = await _reread(thenWrite: true);
    return switch ((before, diary, meals)) {
      (final before?, Fetched(value: final after), Fetched())
          when before == after =>
        RefreshOutcome.nothingNew,
      _ => RefreshOutcome.changed,
    };
  }

  Future<void> reload({bool thenWrite = true, bool keepShown = false}) async {
    _keepShown = keepShown;
    try {
      await _reread(thenWrite: thenWrite);
    } finally {
      _keepShown = false;
    }
  }

  Future<void> revalidate() async {
    if (!ref.mounted) return;
    final held = [
      for (final side in [mfpDiaryProvider(date), ekkloMealsProvider(date)])
        if (!ref.read(side).isLoading) side,
    ];
    if (held.isEmpty) return;
    held.forEach(ref.invalidate);
    await _readSides(thenWrite: true);
  }

  Future<(Fetch<MfpDiaryDay>, Fetch<List<EkkloDailyMeal>>)> _reread({
    required bool thenWrite,
  }) {
    switch (ref.read(mealNamesProvider)) {
      case AsyncError():
        ref.invalidate(mealNamesProvider);
      case AsyncData() || AsyncLoading():
        break;
    }
    for (final day in CalendarWeek.daysOf(date)) {
      final meals = ekkloMealsProvider(day);
      ref.invalidate(mfpDiaryProvider(day));
      if (ref.exists(meals) && ref.read(meals).hasError) ref.invalidate(meals);
    }
    ref.invalidate(ekkloMealsProvider(date));
    return _readSides(thenWrite: thenWrite);
  }

  Future<(Fetch<MfpDiaryDay>, Fetch<List<EkkloDailyMeal>>)> _readSides({
    required bool thenWrite,
  }) => ref
      .read(freshReadServiceProvider)
      .settle(
        date,
        diary: ref.read(mfpDiaryProvider(date).future),
        meals: ref.read(ekkloMealsProvider(date).future),
        thenWrite: thenWrite,
      );

  Future<JournalRead> _sharedFirstRead(
    FreshReadService fresh,
    Future<Fetched<MfpDiaryDay>> diary,
    Future<Fetched<List<EkkloDailyMeal>>> meals,
    Future<List<String>> mealNames,
  ) => _firstReading ??= fresh
      .read(
        date,
        diary: diary,
        meals: meals,
        mealNames: mealNames,
      )
      .whenComplete(() => _firstReading = null);

  static Fetch<T>? _held<T>(AsyncValue<Fetched<T>> side) => switch (side) {
    AsyncData(:final value) => value,
    AsyncError(:final error, :final stackTrace) => FetchFailed(
      error,
      stackTrace,
    ),
    AsyncLoading(:final value?) => value,
    AsyncLoading(:final error?, :final stackTrace?) => FetchFailed(
      error,
      stackTrace,
    ),
    AsyncLoading() => null,
  };

  static List<String>? _heldNames(AsyncValue<List<String>> names) =>
      switch (names) {
        AsyncData(:final value) => value,
        AsyncError() => const [],
        AsyncLoading(:final value?) => value,
        AsyncLoading(hasError: true) => const [],
        AsyncLoading() => null,
      };
}
