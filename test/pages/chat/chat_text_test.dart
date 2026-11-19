import 'package:checks/checks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart' show setUpAll, test;
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/chat/chat_text.dart';
import 'package:intl/date_symbol_data_local.dart';

final AppLocalizations _french = lookupAppLocalizations(const Locale('fr'));
final DateTime _now = DateTime(2026, 10, 7, 9, 30);

void main() {
  setUpAll(() => initializeDateFormatting('fr'));

  test('a message of today, of yesterday and of earlier days', () {
    check(
      ChatText.day(_french, DateTime(2026, 10, 7, 0, 5), now: _now),
    ).equals('Aujourd’hui');
    check(
      ChatText.day(_french, DateTime(2026, 10, 6, 23, 59), now: _now),
    ).equals('Hier');
    check(
      ChatText.day(_french, DateTime(2026, 10, 5, 12), now: _now),
    ).equals('Lundi 5 octobre');
  });

  test('yesterday crosses a month boundary', () {
    check(
      ChatText.day(
        _french,
        DateTime(2026, 9, 30, 18),
        now: DateTime(2026, 10, 1, 8),
      ),
    ).equals('Hier');
  });

  test('the badge shows nothing, the count, or 9+ past nine', () {
    check(ChatText.badge(_french, 0)).isNull();
    check(ChatText.badge(_french, 1)).equals('1');
    check(ChatText.badge(_french, 9)).equals('9');
    check(ChatText.badge(_french, 10)).equals('9+');
  });

  test('a duration reads as minutes and padded seconds', () {
    check(ChatText.clock(const Duration(seconds: 7))).equals('0:07');
    check(ChatText.clock(const Duration(minutes: 1, seconds: 12))).equals(
      '1:12',
    );
    check(
      ChatText.spoken(_french, const Duration(minutes: 1, seconds: 12)),
    ).equals('1 min 12 s');
    check(
      ChatText.spoken(_french, const Duration(seconds: 37)),
    ).equals('37 s');
  });
}
