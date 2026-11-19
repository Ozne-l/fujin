import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/chat/chat_day_kind.dart';
import 'package:fujin/pages/chat/chat_text.dart';
import 'package:fujin/pages/common/title_text.dart';

abstract final class ChatViewerText {
  static String moment(
    AppLocalizations intl,
    DateTime createdAt, {
    required DateTime now,
    required int index,
    required int count,
  }) {
    final local = createdAt.toLocal();
    final kind = ChatText.dayKind(local, now: now);
    return switch (count) {
      <= 1 => switch (kind) {
        ChatDayKind.today => intl.chatViewerToday(local),
        ChatDayKind.yesterday => intl.chatViewerYesterday(local),
        ChatDayKind.earlier => TitleText.capitalized(
          intl.chatViewerEarlier(local, local),
        ),
      },
      _ => intl.chatViewerPosition(index + 1, count, switch (kind) {
        ChatDayKind.today => intl.chatViewerTodayInline(local),
        ChatDayKind.yesterday => intl.chatViewerYesterdayInline(local),
        ChatDayKind.earlier => intl.chatViewerEarlier(local, local),
      }),
    };
  }
}
