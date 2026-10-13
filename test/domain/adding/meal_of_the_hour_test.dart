import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart' show group, test;
import 'package:fujin/domain/adding/meal_of_the_hour.dart';

void main() {
  const diary = ['Breakfast', 'Lunch', 'Dinner', 'Snacks'];
  DateTime at(int hour, int minute) => DateTime(2026, 10, 13, hour, minute);

  group('the meal of the hour', () {
    test('is breakfast from midnight until 10:59', () {
      check(mealOfTheHour(diary, at(0, 0))).equals('Breakfast');
      check(mealOfTheHour(diary, at(10, 59))).equals('Breakfast');
    });

    test('is lunch from 11:00 until 15:59', () {
      check(mealOfTheHour(diary, at(11, 0))).equals('Lunch');
      check(mealOfTheHour(diary, at(15, 59))).equals('Lunch');
    });

    test('is the fourth meal from 16:00 until 17:59', () {
      check(mealOfTheHour(diary, at(16, 0))).equals('Snacks');
      check(mealOfTheHour(diary, at(17, 59))).equals('Snacks');
    });

    test('is the third meal from 18:00 until 23:59', () {
      check(mealOfTheHour(diary, at(18, 0))).equals('Dinner');
      check(mealOfTheHour(diary, at(23, 59))).equals('Dinner');
    });

    test('is absent when the diary has no meal at that position', () {
      check(
        mealOfTheHour(['Breakfast', 'Lunch', 'Dinner'], at(16, 0)),
      ).isNull();
    });
  });
}
