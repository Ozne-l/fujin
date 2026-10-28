import 'package:fujin/data/database/calendar_date_hook.dart';
import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/pages/scanner/scanner_exit.dart';

enum FujinRoute {
  splash('/splash'),
  journal('/'),
  memory('/memory'),
  memoryFood('/memory/food/:${FujinRoute.foodParameter}'),
  settings('/settings'),
  goals('/settings/${FujinRoute.goalsSegment}'),
  welcome('/welcome'),
  mfpSignIn('/mfp-sign-in'),
  ekkloSignIn('/ekklo-sign-in'),
  send('/send/:${FujinRoute.dateParameter}'),
  addFood('/add/:${FujinRoute.dateParameter}'),
  editFood('/edit/:${FujinRoute.dateParameter}'),
  scanner('/scan/:${FujinRoute.dateParameter}');

  const FujinRoute(this.path);

  static const dateParameter = 'date';
  static const mealParameter = 'meal';
  static const queryParameter = 'query';
  static const barcodeParameter = 'barcode';
  static const unresolvedParameter = 'unresolved';
  static const foodParameter = 'food';
  static const unitParameter = 'unit';
  static const entryParameter = 'entry';
  static const goalsSegment = 'goals';

  final String path;

  String forDate(DateTime date) =>
      path.replaceFirst(':$dateParameter', CalendarDateHook.format(date));

  String forMeal(DateTime date, String meal) => Uri(
    path: forDate(date),
    queryParameters: {mealParameter: meal},
  ).toString();

  String forEntry(DateTime date, String entryId) => Uri(
    path: forDate(date),
    queryParameters: {entryParameter: entryId},
  ).toString();

  String forScanSearch(DateTime date, String meal, ScannerSearch search) => Uri(
    path: forDate(date),
    queryParameters: {
      mealParameter: meal,
      queryParameter: search.query,
      barcodeParameter: ?search.barcode,
      unresolvedParameter: '${search.unresolved}',
    },
  ).toString();

  String forRemembered(DateTime date, String meal, RememberedFood food) => Uri(
    path: forDate(date),
    queryParameters: {
      mealParameter: meal,
      foodParameter: food.mfpFoodId,
      if (food case OwnCopy(:final mfpUnit)) unitParameter: mfpUnit,
    },
  ).toString();

  static ScannerSearch? scanSearchOf(Map<String, String> parameters) =>
      switch (parameters[queryParameter]) {
        final query? => ScannerSearch(
          query: query,
          barcode: parameters[barcodeParameter],
          unresolved:
              bool.tryParse(parameters[unresolvedParameter] ?? '') ?? false,
        ),
        null => null,
      };

  String forFood(RememberedFood food) => Uri(
    path: path.replaceFirst(':$foodParameter', food.mfpFoodId),
    queryParameters: switch (food) {
      OwnCopy(:final mfpUnit) => {unitParameter: mfpUnit},
      MatchedFood() => null,
    },
  ).toString();
}
