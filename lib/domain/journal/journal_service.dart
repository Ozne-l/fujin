import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/database/fujin_id.dart';
import 'package:fujin/data/entries/entry_repository.dart';
import 'package:fujin/data/entries/logged_entry.dart';
import 'package:fujin/data/foods/food_repository.dart';
import 'package:fujin/data/links/sent_link_repository.dart';
import 'package:fujin/data/meals/meal_repository.dart';
import 'package:fujin/data/memory/memory_repository.dart';
import 'package:fujin/data/unattended/unattended_item_repository.dart';
import 'package:fujin/domain/comparison/adopt_waiting.dart';
import 'package:fujin/domain/comparison/compare_day.dart';
import 'package:fujin/domain/comparison/compare_mfp_day.dart';
import 'package:fujin/domain/comparison/day_comparison.dart';
import 'package:fujin/domain/comparison/day_draft.dart';
import 'package:fujin/domain/journal/diary_meal.dart';
import 'package:fujin/domain/journal/fetch.dart';
import 'package:fujin/domain/journal/journal_day.dart';
import 'package:fujin/domain/journal/journal_meal.dart';
import 'package:fujin/domain/journal/journal_read.dart';
import 'package:fujin/domain/journal/read_problem.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

final class JournalService {
  const JournalService({
    required this._mfp,
    required this._ekklo,
    required this._entries,
    required this._links,
    required this._unattended,
    required this._memory,
    required this._foods,
    required this._meals,
    required this._database,
    required this._clock,
  });

  final MyFitnessPalClient _mfp;
  final EkkloClient _ekklo;
  final EntryRepository _entries;
  final SentLinkRepository _links;
  final UnattendedItemRepository _unattended;
  final MemoryRepository _memory;
  final FoodRepository _foods;
  final MealRepository _meals;
  final FujinDatabase _database;
  final DateTime Function() _clock;

  Future<JournalDay> readDay(
    DateTime date, {
    List<String> mealNames = const [],
  }) async {
    final diary = Fetch.of(fetchDiary(date));
    final meals = Fetch.of(fetchEkkloMeals(date));
    return switch ((await diary, await meals)) {
      (Fetched(value: final diary), Fetched(value: final meals)) => _day(
        date,
        _stored(date, diary, meals),
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
        day: _day(
          date,
          _comparison(date, diary, meals).held(),
          meals,
          mealNames,
        ),
        readAt: switch (mfpAt.isBefore(ekkloAt)) {
          true => mfpAt,
          false => ekkloAt,
        },
      ),
    (Fetched(value: final diary, :final readAt), FetchFailed(:final error)) =>
      MfpOnly(
        meals: _diaryMeals(mealNames, _mfpSide(date, diary)),
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

  void settleDay(
    DateTime date, {
    required Fetch<MfpDiaryDay> diary,
    required Fetch<List<EkkloDailyMeal>> meals,
  }) {
    switch ((diary, meals)) {
      case (Fetched(value: final diary), Fetched(value: final meals)):
        _stored(date, diary, meals);
      case (Fetched(value: final diary), FetchFailed()):
        _database.transaction(
          () => _entries.store(_mfpDraft(date, diary).changes),
        );
      case (FetchFailed(), _):
        return;
    }
  }

  Future<List<String>> mealNames() async {
    final names = await _mfp.diary.mealNames();
    _meals.arrange(names);
    return names;
  }

  DayComparison _stored(
    DateTime date,
    MfpDiaryDay diary,
    List<EkkloDailyMeal> meals,
  ) => _database.transaction(() {
    final comparison = _comparison(date, diary, meals);
    _entries.store(comparison.changes);
    return comparison;
  });

  DayComparison _comparison(
    DateTime date,
    MfpDiaryDay diary,
    List<EkkloDailyMeal> meals,
  ) => compareDay(
    date: date,
    stored: _entries.forDate(date),
    diary: diary.entries,
    meals: meals,
    waitingLinks: _links.forDate(date),
    waitingUnattended: _unattended.forDate(date),
    memory: _memory.load(),
    foodOf: _foods.foodOfMfp,
    mealOf: _meals.mealOfMfp,
    now: _clock(),
    ids: FujinId.source(_clock),
  );

  DayDraft _mfpDraft(DateTime date, MfpDiaryDay diary) {
    final now = _clock();
    final ids = FujinId.source(_clock);
    return compareMfpDay(
      adoptWaiting(
        DayDraft.of(_entries.forDate(date), date: date),
        diary: diary.entries,
        links: _links.forDate(date),
        unattended: _unattended.forDate(date),
        foodOf: _foods.foodOfMfp,
        mealOf: _meals.mealOfMfp,
        now: now,
        ids: ids,
      ),
      diary: diary.entries,
      foodOf: _foods.foodOfMfp,
      mealOf: _meals.mealOfMfp,
      now: now,
      ids: ids,
    );
  }

  List<LoggedEntry> _mfpSide(DateTime date, MfpDiaryDay diary) {
    final draft = _mfpDraft(date, diary);
    return [...draft.entries, ...draft.unstored];
  }

  JournalDay _day(
    DateTime date,
    DayComparison comparison,
    List<EkkloDailyMeal> ekkloMeals,
    List<String> mealNames,
  ) => JournalDay(
    date: date,
    comparison: comparison,
    ekkloMeals: ekkloMeals,
    meals: [
      for (final name in _mealOrder(mealNames, [
        for (final compared in comparison.entries) compared.logged,
      ]))
        JournalMeal(
          name: name,
          entries: [
            for (final compared in comparison.entries)
              if (compared.logged.mealName == name) compared,
          ],
        ),
    ],
  );

  List<DiaryMeal> _diaryMeals(
    List<String> mealNames,
    List<LoggedEntry> entries,
  ) => [
    for (final name in _mealOrder(mealNames, entries))
      DiaryMeal(
        name: name,
        entries: [
          for (final logged in entries)
            if (logged.mealName == name) logged,
        ],
      ),
  ];

  List<String> _mealOrder(List<String> mealNames, List<LoggedEntry> entries) {
    final held = {
      for (final logged in entries) logged.entry.mealId: logged.mealName,
    };
    final positioned =
        [
          for (final meal in _meals.meals())
            if (meal.deletedAt == null) meal,
        ]..sort(
          (a, b) => switch (a.position.compareTo(b.position)) {
            0 => a.id.compareTo(b.id),
            final order => order,
          },
        );
    return {
      ...mealNames,
      for (final meal in positioned) ?held[meal.id],
      ...held.values,
    }.toList();
  }
}
