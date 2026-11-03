import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/data/connectors/connector_roles.dart';
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/database/fujin_id.dart';
import 'package:fujin/data/entries/day_changes.dart';
import 'package:fujin/data/entries/entry_repository.dart';
import 'package:fujin/data/entries/logged_entry.dart';
import 'package:fujin/data/entries/mfp_write.dart';
import 'package:fujin/data/entries/stored_day.dart';
import 'package:fujin/data/foods/food.dart';
import 'package:fujin/data/foods/food_repository.dart';
import 'package:fujin/data/links/sent_link.dart';
import 'package:fujin/data/links/sent_link_repository.dart';
import 'package:fujin/data/meals/meal.dart';
import 'package:fujin/data/meals/meal_repository.dart';
import 'package:fujin/data/memory/memory_repository.dart';
import 'package:fujin/data/unattended/unattended_item_repository.dart';
import 'package:fujin/domain/comparison/adopt_waiting.dart';
import 'package:fujin/domain/comparison/compare_day.dart';
import 'package:fujin/domain/comparison/compare_mfp_day.dart';
import 'package:fujin/domain/comparison/day_comparison.dart';
import 'package:fujin/domain/comparison/day_draft.dart';
import 'package:fujin/domain/comparison/replacement.dart';
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
    required this._roles,
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
  final ConnectorRoles Function() _roles;

  Future<JournalDay> readDay(
    DateTime date, {
    List<String> mealNames = const [],
  }) async {
    final diary = Fetch.of(fetchDiary(date));
    final meals = Fetch.of(fetchEkkloMeals(date));
    return switch ((await diary, await meals)) {
      (final Fetched<MfpDiaryDay> diary, Fetched(value: final meals)) => _day(
        date,
        _stored(date, diary, meals).comparison,
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
      Fetched(readAt: final mfpAt) && final Fetched<MfpDiaryDay> diary,
      Fetched(value: final meals, readAt: final ekkloAt),
    ) =>
      BothSides(
        day: _day(
          date,
          _comparison(date, _entries.forDate(date), diary, meals).held(),
          meals,
          mealNames,
        ),
        readAt: switch (mfpAt.isBefore(ekkloAt)) {
          true => mfpAt,
          false => ekkloAt,
        },
      ),
    (Fetched(), FetchFailed(:final error)) || (FetchFailed(:final error), _)
        when ReadProblem.of(error) == ReadProblem.offline =>
      FujinOnly(meals: _storedMeals(date, mealNames), readAt: _clock()),
    (
      Fetched(:final readAt) && final Fetched<MfpDiaryDay> diary,
      FetchFailed(:final error),
    ) =>
      MfpOnly(
        meals: _mfpMeals(
          mealNames,
          _mfpDraft(date, _entries.forDate(date), diary),
        ),
        ekkloProblem: ReadProblem.of(error),
        readAt: readAt,
      ),
    (FetchFailed(:final error), Fetched(value: final meals, :final readAt)) =>
      EkkloOnly(
        ekkloMeals: meals,
        mfpProblem: ReadProblem.of(error),
        readAt: readAt,
      ),
    (FetchFailed(:final error, :final stackTrace), _) =>
      Error.throwWithStackTrace(error, stackTrace),
  };

  ({List<Replacement> replaced, List<String> adopted}) settleDay(
    DateTime date, {
    required Fetch<MfpDiaryDay> diary,
    required Fetch<List<EkkloDailyMeal>> meals,
  }) => switch ((diary, meals)) {
    (final Fetched<MfpDiaryDay> diary, Fetched(value: final meals)) =>
      switch (_stored(
        date,
        diary,
        meals,
      )) {
        (:final comparison, :final adopted) => (
          replaced: comparison.replaced,
          adopted: adopted,
        ),
      },
    (final Fetched<MfpDiaryDay> diary, FetchFailed()) => _database.transaction(
      () {
        final stored = _entries.forDate(date);
        final draft = _mfpDraft(date, stored, diary);
        final changes = draft.changes;
        _entries.store(changes);
        return (replaced: draft.replaced, adopted: _adopted(stored, changes));
      },
    ),
    (FetchFailed(), _) => (replaced: const [], adopted: const []),
  };

  Future<List<String>> mealNames() async {
    final names = await _mfp.diary.mealNames();
    _meals.arrange(names);
    return names;
  }

  static List<String> _adopted(StoredDay stored, DayChanges changes) {
    final unlinked = {
      for (final logged in stored.entries)
        if (logged.mfpLink == null) logged.entry.id,
    };
    return [
      for (final link in changes.addedMfpLinks)
        if (unlinked.contains(link.entryId)) link.entryId,
    ];
  }

  ({DayComparison comparison, List<String> adopted}) _stored(
    DateTime date,
    Fetched<MfpDiaryDay> diary,
    List<EkkloDailyMeal> meals,
  ) => _database.transaction(() {
    final stored = _entries.forDate(date);
    final comparison = _comparison(date, stored, diary, meals);
    _entries.store(comparison.changes);
    return (
      comparison: comparison,
      adopted: _adopted(stored, comparison.changes),
    );
  });

  DayComparison _comparison(
    DateTime date,
    StoredDay stored,
    Fetched<MfpDiaryDay> diary,
    List<EkkloDailyMeal> meals,
  ) {
    final links = _links.forDate(date);
    final catalog = _catalogOf(diary.value.entries, links);
    return compareDay(
      date: date,
      stored: stored,
      diary: diary.value.entries,
      meals: meals,
      waitingLinks: links,
      waitingUnattended: _unattended.forDate(date),
      memory: _memory.load(),
      foodOf: catalog.foodOf,
      mealOf: catalog.mealOf,
      now: _clock(),
      diaryReadAt: diary.readAt,
      ids: FujinId.source(_clock),
      roles: _roles(),
    );
  }

  DayDraft _mfpDraft(
    DateTime date,
    StoredDay stored,
    Fetched<MfpDiaryDay> fetched,
  ) {
    final diary = fetched.value;
    final now = _clock();
    final ids = FujinId.source(_clock);
    final role = _roles().mfp;
    final links = _links.forDate(date);
    final catalog = _catalogOf(diary.entries, links);
    return compareMfpDay(
      adoptWaiting(
        DayDraft.of(stored, date: date),
        diary: diary.entries,
        links: links,
        unattended: _unattended.forDate(date),
        foodOf: catalog.foodOf,
        mealOf: catalog.mealOf,
        now: now,
        ids: ids,
        role: role,
      ),
      diary: diary.entries,
      foodOf: catalog.foodOf,
      mealOf: catalog.mealOf,
      now: now,
      readAt: fetched.readAt,
      ids: ids,
      role: role,
    );
  }

  ({
    Food? Function(String mfpFoodId) foodOf,
    String? Function(String mfpMealName) mealOf,
  })
  _catalogOf(List<MfpFoodEntry> diary, List<SentLink> links) {
    final foods = {
      for (final mfpFoodId in {
        for (final row in diary) row.food.id,
        for (final link in links) link.mfpFoodId,
      })
        mfpFoodId: _foods.foodOfMfp(mfpFoodId),
    };
    final meals = {
      for (final mfpMealName in {
        for (final row in diary) row.mealName,
        for (final link in links) link.mfpMealName,
      })
        mfpMealName: _meals.mealOfMfp(mfpMealName),
    };
    return (
      foodOf: (mfpFoodId) => foods[mfpFoodId],
      mealOf: (mfpMealName) => meals[mfpMealName],
    );
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
        ...comparison.leaving,
      ]))
        JournalMeal(
          name: name,
          entries: _inMeal(name, comparison.entries, (it) => it.logged),
          leaving: _inMeal(name, comparison.leaving, _itself),
        ),
    ],
  );

  List<DiaryMeal> _diaryMeals(
    Iterable<String> names,
    List<LoggedEntry> entries, {
    required List<LoggedEntry> stored,
    List<LoggedEntry> leaving = const [],
  }) => [
    for (final name in names)
      DiaryMeal(
        name: name,
        entries: _inMeal(name, entries, _itself),
        leaving: _inMeal(name, leaving, _itself),
        mfpPending: {
          for (final logged in _inMeal(name, stored, _itself))
            if (MfpWrite.of(logged) case MfpAdd() || MfpEdit()) logged.entry.id,
        },
      ),
  ];

  static List<T> _inMeal<T>(
    String name,
    List<T> entries,
    LoggedEntry Function(T entry) logged,
  ) => [
    for (final entry in entries)
      if (logged(entry).mealName == name) entry,
  ];

  static LoggedEntry _itself(LoggedEntry logged) => logged;

  List<String> storedMealNames() => [
    for (final meal in _positioned()) meal.name,
  ];

  List<DiaryMeal> _storedMeals(DateTime date, List<String> mealNames) {
    final draft = DayDraft.of(_entries.forDate(date), date: date);
    final leaving = draft.leaving;
    return _diaryMeals(
      {
        ...mealNames,
        ...storedMealNames(),
        for (final logged in [...draft.entries, ...leaving]) logged.mealName,
      },
      draft.entries,
      stored: draft.entries,
      leaving: leaving,
    );
  }

  List<DiaryMeal> _mfpMeals(List<String> mealNames, DayDraft draft) {
    final entries = [...draft.entries, ...draft.unstored];
    return _diaryMeals(
      _mealOrder(mealNames, entries),
      entries,
      stored: draft.entries,
    );
  }

  List<String> _mealOrder(List<String> mealNames, List<LoggedEntry> entries) {
    final held = {
      for (final logged in entries) logged.entry.mealId: logged.mealName,
    };
    return {
      ...mealNames,
      for (final meal in _positioned()) ?held[meal.id],
      ...held.values,
    }.toList();
  }

  List<Meal> _positioned() =>
      [
        for (final meal in _meals.meals())
          if (meal.deletedAt == null) meal,
      ]..sort(
        (a, b) => switch (a.position.compareTo(b.position)) {
          0 => a.id.compareTo(b.id),
          final order => order,
        },
      );
}
