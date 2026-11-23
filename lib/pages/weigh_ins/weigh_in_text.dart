import 'package:fujin/data/weigh_ins/weigh_in.dart';
import 'package:fujin/domain/weighing/weigh_in_failure.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/common/title_text.dart';

abstract final class WeighInText {
  static const _today = 0;
  static const _yesterday = 1;

  static String kilograms(AppLocalizations intl, double kilograms) =>
      intl.weighInKilograms(kilograms);

  static String day(
    AppLocalizations intl,
    DateTime date, {
    required DateTime today,
  }) => switch (_daysAgo(date, today)) {
    _today => intl.weighInToday(date),
    _yesterday => intl.weighInYesterday(date),
    _ => TitleText.capitalized(intl.addMealDate(date)),
  };

  static String dayWord(
    AppLocalizations intl,
    DateTime date, {
    required DateTime today,
  }) => switch (_daysAgo(date, today)) {
    _today => intl.weighInDayToday,
    _yesterday => intl.weighInDayYesterday,
    _ => intl.addMealDate(date),
  };

  static String longDay(AppLocalizations intl, DateTime date) =>
      TitleText.capitalized(intl.journalDay(date));

  static String saved(
    AppLocalizations intl,
    WeighIn weighIn, {
    required DateTime today,
  }) => intl.weighInSavedDetail(
    kilograms(intl, weighIn.kilograms),
    dayWord(intl, weighIn.date, today: today),
  );

  static String deleted(
    AppLocalizations intl,
    WeighIn weighIn, {
    required DateTime today,
  }) => intl.weighInDeletedDetail(
    TitleText.capitalized(dayWord(intl, weighIn.date, today: today)),
  );

  static String stillPending(
    AppLocalizations intl,
    List<WeighInFailure> reported, {
    required DateTime today,
  }) => switch (reported) {
    [final failure] when _daysAgo(failure.weighIn.date, today) == _today =>
      intl.weighInStillPendingToday,
    [final failure] => intl.weighInStillPending(failure.weighIn.date),
    _ => intl.weighInsStillPending(reported.length),
  };

  static int _daysAgo(DateTime date, DateTime today) =>
      today.difference(date).inDays;
}
