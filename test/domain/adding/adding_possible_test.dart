import 'package:checks/checks.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter_test/flutter_test.dart' show group, test;
import 'package:fujin/domain/adding/adding_possible.dart';
import 'package:fujin/domain/comparison/day_comparison.dart';
import 'package:fujin/domain/journal/journal_day.dart';
import 'package:fujin/domain/journal/journal_read.dart';
import 'package:fujin/domain/journal/read_problem.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

import '../../support/fixtures.dart';

void main() {
  final diary = MfpDiaryDay(date: day);
  final both = BothSides(
    day: JournalDay(diary: diary, comparison: const DayComparison()),
    readAt: now,
  );
  MfpOnly mfpOnly(ReadProblem problem) =>
      MfpOnly(diary: diary, ekkloProblem: problem, readAt: now);
  EkkloOnly ekkloOnly(ReadProblem problem) =>
      EkkloOnly(mfpProblem: problem, readAt: now);
  final apiUri = Uri.parse('https://api.test');

  group('adding', () {
    test('is possible before any read has finished and on a full read', () {
      check(addingPossible()).isTrue();
      check(addingPossible(read: both)).isTrue();
    });

    test('is impossible when a side is offline or its session expired', () {
      check(addingPossible(read: mfpOnly(ReadProblem.offline))).isFalse();
      check(
        addingPossible(read: mfpOnly(ReadProblem.ekkloSessionExpired)),
      ).isFalse();
      check(
        addingPossible(read: ekkloOnly(ReadProblem.mfpSessionExpired)),
      ).isFalse();
    });

    test('stays possible when a side is down or failed otherwise', () {
      check(
        addingPossible(read: mfpOnly(ReadProblem.ekkloUnavailable)),
      ).isTrue();
      check(
        addingPossible(read: ekkloOnly(ReadProblem.mfpUnavailable)),
      ).isTrue();
      check(addingPossible(read: mfpOnly(ReadProblem.unknown))).isTrue();
    });

    test('follows the failed read over the figures it kept', () {
      check(
        addingPossible(
          read: both,
          error: EkkloNetworkException(method: 'GET', uri: apiUri),
        ),
      ).isFalse();
      check(
        addingPossible(
          error: const MfpAuthException(MfpAuthFailure.sessionExpired),
        ),
      ).isFalse();
      check(
        addingPossible(
          read: mfpOnly(ReadProblem.offline),
          error: MfpApiException(method: 'GET', uri: apiUri, statusCode: 503),
        ),
      ).isTrue();
    });
  });
}
