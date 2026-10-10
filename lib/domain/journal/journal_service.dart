import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/data/links/sent_link_repository.dart';
import 'package:fujin/data/memory/memory_repository.dart';
import 'package:fujin/domain/comparison/compare_day.dart';
import 'package:fujin/domain/journal/day_nutrients.dart';
import 'package:fujin/domain/journal/journal_day.dart';
import 'package:fujin/domain/journal/journal_read.dart';
import 'package:fujin/domain/journal/read_problem.dart';
import 'package:fujin/domain/sending/nutrient.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

final class JournalService {
  const JournalService({
    required this._mfp,
    required this._ekklo,
    required this._links,
    required this._memory,
    required this._clock,
  });

  final MyFitnessPalClient _mfp;
  final EkkloClient _ekklo;
  final SentLinkRepository _links;
  final MemoryRepository _memory;
  final DateTime Function() _clock;

  Future<JournalDay> readDay(
    DateTime date, {
    List<String> mealNames = const [],
  }) async => switch (await _sides(date)) {
    (_Read(value: final diary), _Read(value: final meals)) => _compare(
      date,
      diary,
      meals,
      mealNames,
    ),
    (_Failed(:final error, :final stackTrace), _) ||
    (_, _Failed(:final error, :final stackTrace)) => Error.throwWithStackTrace(
      error,
      stackTrace,
    ),
  };

  Future<JournalRead> readJournal(
    DateTime date, {
    List<String> mealNames = const [],
  }) async => switch (await _sides(date)) {
    (_Read(value: final diary), _Read(value: final meals)) => BothSides(
      day: _compare(date, diary, meals, mealNames),
      readAt: _clock(),
    ),
    (_Read(value: final diary), _Failed(:final error)) => MfpOnly(
      diary: diary,
      mealNames: mealNames,
      ekkloProblem: ReadProblem.of(error),
      readAt: _clock(),
    ),
    (_Failed(:final error), _Read(value: final meals))
        when ReadProblem.of(error) != ReadProblem.offline =>
      EkkloOnly(
        ekkloMeals: meals,
        mfpProblem: ReadProblem.of(error),
        readAt: _clock(),
      ),
    (_Failed(:final error, :final stackTrace), _) => Error.throwWithStackTrace(
      error,
      stackTrace,
    ),
  };

  Future<Map<DateTime, double?>> loggedKilocalories(
    Iterable<DateTime> days,
  ) async => {
    for (final diary in await Future.wait([
      for (final day in days) _mfp.diary.forDate(day),
    ]))
      diary.date: switch (diary.entries) {
        [] => null,
        final entries => DayNutrients.ofEntries(
          entries,
        ).amount(Nutrient.kilocalories),
      },
  };

  Future<List<String>> mealNames() => _mfp.diary.mealNames();

  JournalDay _compare(
    DateTime date,
    MfpDiaryDay diary,
    List<EkkloDailyMeal> ekkloMeals,
    List<String> mealNames,
  ) {
    final comparison = compareDay(
      entries: diary.entries,
      meals: ekkloMeals,
      links: _links.forDate(date),
      memory: _memory.load(),
      now: _clock(),
    );
    _links.replace(
      dropped: comparison.linksToDrop,
      adopted: comparison.linksToAdopt,
    );
    return JournalDay(
      diary: diary,
      mealNames: mealNames,
      ekkloMeals: ekkloMeals,
      comparison: comparison,
    );
  }

  Future<(_Settled<MfpDiaryDay>, _Settled<List<EkkloDailyMeal>>)> _sides(
    DateTime date,
  ) async {
    final diary = _Settled.of(_mfp.diary.forDate(date));
    final ekkloMeals = _Settled.of(_ekklo.meals.forDate(date));
    return (await diary, await ekkloMeals);
  }
}

sealed class _Settled<T> {
  const _Settled();

  static Future<_Settled<T>> of<T>(Future<T> read) =>
      read.then<_Settled<T>>(_Read.new, onError: _Failed<T>.new);
}

final class _Read<T> extends _Settled<T> {
  const _Read(this.value);

  final T value;
}

final class _Failed<T> extends _Settled<T> {
  const _Failed(this.error, this.stackTrace);

  final Object error;
  final StackTrace stackTrace;
}
