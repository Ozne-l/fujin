import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart' show test;
import 'package:fujin/domain/journal/calendar_week.dart';

import '../../support/fixtures.dart';

final _monday = DateTime.utc(2026, 10, 5);
final _lastSunday = DateTime.utc(2026, 10, 4);

void main() {
  test('starts a week on Monday and lists its seven days', () {
    check(CalendarWeek.mondayOf(day)).equals(_monday);
    check(CalendarWeek.daysOf(day))
      ..length.equals(7)
      ..first.equals(_monday)
      ..last.equals(DateTime.utc(2026, 10, 11));
  });

  test('counts whole weeks between two days', () {
    check(CalendarWeek.weeksBetween(_lastSunday, day)).equals(1);
    check(CalendarWeek.weeksBetween(_monday, day)).equals(0);
    check(
      CalendarWeek.weeksBefore(_monday, 2),
    ).equals(DateTime.utc(2026, 9, 21));
  });

  test('keeps the weekday when changing week, never past today', () {
    check(
      CalendarWeek.sameWeekday(day, weeksBack: 1, today: day),
    ).equals(DateTime.utc(2026, 9, 30));
    check(
      CalendarWeek.sameWeekday(_lastSunday, weeksBack: 0, today: day),
    ).equals(day);
  });
}
