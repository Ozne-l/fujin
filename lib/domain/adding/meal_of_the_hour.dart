const _lunchFromHour = 11;
const _snacksFromHour = 16;
const _dinnerFromHour = 18;
const _breakfastPosition = 0;
const _lunchPosition = 1;
const _dinnerPosition = 2;
const _snacksPosition = 3;

String? mealOfTheHour(List<String> mealNames, DateTime now) {
  final position = switch (now.hour) {
    < _lunchFromHour => _breakfastPosition,
    < _snacksFromHour => _lunchPosition,
    < _dinnerFromHour => _snacksPosition,
    _ => _dinnerPosition,
  };
  return position < mealNames.length ? mealNames[position] : null;
}
