import 'package:fujin/data/database/calendar_date_hook.dart';
import 'package:fujin/data/memory/remembered_food.dart';

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
  send('/send/:${FujinRoute.dateParameter}');

  const FujinRoute(this.path);

  static const dateParameter = 'date';
  static const foodParameter = 'food';
  static const unitParameter = 'unit';
  static const goalsSegment = 'goals';

  final String path;

  String forDate(DateTime date) =>
      path.replaceFirst(':$dateParameter', CalendarDateHook.format(date));

  String forFood(RememberedFood food) => Uri(
    path: path.replaceFirst(':$foodParameter', food.mfpFoodId),
    queryParameters: switch (food) {
      OwnCopy(:final mfpUnit) => {unitParameter: mfpUnit},
      MatchedFood() => null,
    },
  ).toString();
}
