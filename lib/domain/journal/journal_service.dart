import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/data/links/sent_link_repository.dart';
import 'package:fujin/data/memory/memory_repository.dart';
import 'package:fujin/domain/comparison/compare_day.dart';
import 'package:fujin/domain/journal/journal_day.dart';
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
  }) async {
    final (diary, ekkloMeals) = await _bothSides(date);
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

  Future<List<String>> mealNames() => _mfp.diary.mealNames();

  Future<(MfpDiaryDay, List<EkkloDailyMeal>)> _bothSides(DateTime date) async {
    final diary = _mfp.diary.forDate(date)..ignore();
    final ekkloMeals = _ekklo.meals.forDate(date)..ignore();
    return (await diary, await ekkloMeals);
  }
}
