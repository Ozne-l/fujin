abstract final class CalendarWeek {
  static const _daysPerWeek = 7;

  static List<DateTime> daysOf(DateTime day) {
    final monday = mondayOf(day);
    return [
      for (var offset = 0; offset < _daysPerWeek; offset++)
        DateTime.utc(monday.year, monday.month, monday.day + offset),
    ];
  }

  static DateTime mondayOf(DateTime day) =>
      DateTime.utc(day.year, day.month, day.day - (day.weekday - 1));

  static DateTime weeksBefore(DateTime monday, int weeks) => DateTime.utc(
    monday.year,
    monday.month,
    monday.day - _daysPerWeek * weeks,
  );

  static int weeksBetween(DateTime earlier, DateTime later) =>
      mondayOf(later).difference(mondayOf(earlier)).inDays ~/ _daysPerWeek;

  static DateTime sameWeekday(
    DateTime day, {
    required int weeksBack,
    required DateTime today,
  }) {
    final monday = weeksBefore(mondayOf(today), weeksBack);
    final moved = DateTime.utc(
      monday.year,
      monday.month,
      monday.day + day.weekday - 1,
    );
    return switch (moved.isAfter(today)) {
      true => today,
      false => moved,
    };
  }
}
