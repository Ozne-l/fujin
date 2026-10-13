import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/links/sent_link_repository.dart';
import 'package:fujin/data/memory/memory_repository.dart';
import 'package:fujin/data/unattended/unattended_item_repository.dart';
import 'package:fujin/domain/comparison/compare_day.dart';
import 'package:fujin/domain/comparison/day_comparison.dart';
import 'package:fujin/domain/journal/fetch.dart';
import 'package:fujin/domain/journal/journal_day.dart';
import 'package:fujin/domain/journal/journal_read.dart';
import 'package:fujin/domain/journal/read_problem.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

final class JournalService {
  const JournalService({
    required this._mfp,
    required this._ekklo,
    required this._links,
    required this._unattended,
    required this._memory,
    required this._database,
    required this._clock,
  });

  final MyFitnessPalClient _mfp;
  final EkkloClient _ekklo;
  final SentLinkRepository _links;
  final UnattendedItemRepository _unattended;
  final MemoryRepository _memory;
  final FujinDatabase _database;
  final DateTime Function() _clock;

  Future<JournalDay> readDay(
    DateTime date, {
    List<String> mealNames = const [],
  }) async {
    final diary = Fetch.of(fetchDiary(date));
    final meals = Fetch.of(fetchEkkloMeals(date));
    return switch ((await diary, await meals)) {
      (Fetched(value: final diary), Fetched(value: final meals)) => _settled(
        date,
        diary,
        meals,
        mealNames,
      ),
      (FetchFailed(:final error, :final stackTrace), _) ||
      (
        _,
        FetchFailed(:final error, :final stackTrace),
      ) => Error.throwWithStackTrace(error, stackTrace),
    };
  }

  Future<Fetched<MfpDiaryDay>> fetchDiary(DateTime date) async =>
      Fetched(await _mfp.diary.forDate(date), readAt: _clock());

  Future<Fetched<List<EkkloDailyMeal>>> fetchEkkloMeals(DateTime date) async =>
      Fetched(await _ekklo.meals.forDate(date), readAt: _clock());

  JournalRead journalOf(
    DateTime date, {
    required Fetch<MfpDiaryDay> diary,
    required Fetch<List<EkkloDailyMeal>> meals,
    List<String> mealNames = const [],
  }) => switch ((diary, meals)) {
    (
      Fetched(value: final diary, readAt: final mfpAt),
      Fetched(value: final meals, readAt: final ekkloAt),
    ) =>
      BothSides(
        day: _compare(date, diary, meals, mealNames),
        readAt: switch (mfpAt.isBefore(ekkloAt)) {
          true => mfpAt,
          false => ekkloAt,
        },
      ),
    (Fetched(value: final diary, :final readAt), FetchFailed(:final error)) =>
      MfpOnly(
        diary: diary,
        mealNames: mealNames,
        ekkloProblem: ReadProblem.of(error),
        readAt: readAt,
      ),
    (FetchFailed(:final error), Fetched(value: final meals, :final readAt))
        when ReadProblem.of(error) != ReadProblem.offline =>
      EkkloOnly(
        ekkloMeals: meals,
        mfpProblem: ReadProblem.of(error),
        readAt: readAt,
      ),
    (FetchFailed(:final error, :final stackTrace), _) =>
      Error.throwWithStackTrace(error, stackTrace),
  };

  Future<List<String>> mealNames() => _mfp.diary.mealNames();

  void settleLinks(
    DateTime date, {
    required MfpDiaryDay diary,
    required List<EkkloDailyMeal> meals,
  }) => _settle(date, diary, _comparison(date, diary, meals));

  JournalDay _compare(
    DateTime date,
    MfpDiaryDay diary,
    List<EkkloDailyMeal> ekkloMeals,
    List<String> mealNames,
  ) => JournalDay(
    diary: diary,
    mealNames: mealNames,
    ekkloMeals: ekkloMeals,
    comparison: _comparison(date, diary, ekkloMeals),
  );

  JournalDay _settled(
    DateTime date,
    MfpDiaryDay diary,
    List<EkkloDailyMeal> ekkloMeals,
    List<String> mealNames,
  ) {
    final day = _compare(date, diary, ekkloMeals, mealNames);
    _settle(date, diary, day.comparison);
    return day;
  }

  DayComparison _comparison(
    DateTime date,
    MfpDiaryDay diary,
    List<EkkloDailyMeal> ekkloMeals,
  ) => compareDay(
    entries: diary.entries,
    meals: ekkloMeals,
    links: _links.forDate(date),
    unattended: _unattended.forDate(date),
    memory: _memory.load(),
    now: _clock(),
  );

  void _settle(DateTime date, MfpDiaryDay diary, DayComparison comparison) =>
      _database.transaction(() {
        _links.replace(
          dropped: comparison.linksToDrop,
          adopted: comparison.linksToAdopt,
        );
        _unattended
          ..record(comparison.unattendedToAdopt)
          ..prune(date, {for (final entry in diary.entries) ?entry.id});
      });
}
