import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/chat/chat_day_kind.dart';
import 'package:fujin/pages/common/title_text.dart';

abstract final class ChatText {
  static const int _badgeLimit = 9;
  static const int _secondsPerMinute = 60;
  static const int _secondDigits = 2;
  static const String _zero = '0';

  static DateTime calendarDay(DateTime moment) {
    final local = moment.toLocal();
    return DateTime(local.year, local.month, local.day);
  }

  static ChatDayKind dayKind(DateTime moment, {required DateTime now}) {
    final day = calendarDay(moment);
    final today = calendarDay(now);
    return switch (day) {
      _ when day == today => ChatDayKind.today,
      _ when day == DateTime(today.year, today.month, today.day - 1) =>
        ChatDayKind.yesterday,
      _ => ChatDayKind.earlier,
    };
  }

  static String day(
    AppLocalizations intl,
    DateTime moment, {
    required DateTime now,
  }) => switch (dayKind(moment, now: now)) {
    ChatDayKind.today => intl.chatToday,
    ChatDayKind.yesterday => intl.chatYesterday,
    ChatDayKind.earlier => TitleText.capitalized(
      intl.chatDay(moment.toLocal()),
    ),
  };

  static String time(AppLocalizations intl, DateTime moment) =>
      intl.chatTime(moment.toLocal());

  static String? badge(AppLocalizations intl, int unread) => switch (unread) {
    <= 0 => null,
    > _badgeLimit => intl.chatBadgeOverflow(_badgeLimit),
    _ => '$unread',
  };

  static String clock(Duration duration) {
    final seconds = duration.inSeconds;
    final rest = '${seconds % _secondsPerMinute}'.padLeft(_secondDigits, _zero);
    return '${seconds ~/ _secondsPerMinute}:$rest';
  }

  static String spoken(AppLocalizations intl, Duration duration) {
    final seconds = duration.inSeconds;
    return switch (seconds ~/ _secondsPerMinute) {
      0 => intl.chatSeconds(seconds),
      final minutes => intl.chatMinutesSeconds(
        minutes,
        seconds % _secondsPerMinute,
      ),
    };
  }
}
