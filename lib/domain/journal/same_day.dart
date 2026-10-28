import 'package:fujin/data/database/calendar_date_hook.dart';

bool sameDay(DateTime first, DateTime second) =>
    CalendarDateHook.format(first) == CalendarDateHook.format(second);
