import 'dart:async';

import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/domain/adding/food_completion_service.dart';
import 'package:fujin/domain/journal/fetch.dart';
import 'package:fujin/domain/journal/journal_read.dart';
import 'package:fujin/domain/journal/journal_service.dart';
import 'package:fujin/domain/writing/background_writer.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

final class FreshReadService {
  const FreshReadService({
    required this._journal,
    required this._completion,
    required this._writer,
  });

  final JournalService _journal;
  final FoodCompletionService _completion;
  final BackgroundWriter _writer;

  Future<JournalRead> read(
    DateTime date, {
    required Future<Fetched<MfpDiaryDay>> diary,
    required Future<Fetched<List<EkkloDailyMeal>>> meals,
    required Future<List<String>> mealNames,
    required bool thenWrite,
  }) async {
    final diaryRead = Fetch.of(diary);
    final mealsRead = Fetch.of(meals);
    final names = await mealNames.catchError(
      (Object error) => const <String>[],
    );
    final (diaryFetch, mealsFetch) = (await diaryRead, await mealsRead);
    _settle(date, diaryFetch, mealsFetch, thenWrite: thenWrite);
    return _journal.journalOf(
      date,
      diary: diaryFetch,
      meals: mealsFetch,
      mealNames: names,
    );
  }

  Future<(Fetch<MfpDiaryDay>, Fetch<List<EkkloDailyMeal>>)> settle(
    DateTime date, {
    required Future<Fetched<MfpDiaryDay>> diary,
    required Future<Fetched<List<EkkloDailyMeal>>> meals,
    required bool thenWrite,
  }) async {
    final diaryRead = Fetch.of(diary);
    final mealsRead = Fetch.of(meals);
    final (diaryFetch, mealsFetch) = (await diaryRead, await mealsRead);
    _settle(date, diaryFetch, mealsFetch, thenWrite: thenWrite);
    return (diaryFetch, mealsFetch);
  }

  void _settle(
    DateTime date,
    Fetch<MfpDiaryDay> diary,
    Fetch<List<EkkloDailyMeal>> meals, {
    required bool thenWrite,
  }) {
    final (:replaced, :adopted) = _journal.settleDay(
      date,
      diary: diary,
      meals: meals,
    );
    _writer.settled(adopted: adopted, replaced: replaced);
    if (diary case Fetched()) {
      unawaited(_completion.complete());
      if (thenWrite || adopted.isNotEmpty || replaced.isNotEmpty) {
        unawaited(_writer.run());
      }
    }
  }
}
