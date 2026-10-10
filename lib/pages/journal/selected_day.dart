import 'package:fujin/app/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final selectedDayProvider = NotifierProvider<SelectedDay, DateTime>(
  SelectedDay.new,
);

final todayProvider = Provider<DateTime>(
  (ref) => SelectedDay.calendarDay(ref.watch(clockProvider)()),
);

final class SelectedDay extends Notifier<DateTime> {
  @override
  DateTime build() => ref.watch(todayProvider);

  void select(DateTime day) => state = calendarDay(day);

  static DateTime calendarDay(DateTime moment) =>
      DateTime.utc(moment.year, moment.month, moment.day);
}
