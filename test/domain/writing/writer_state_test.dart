import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart' show test;
import 'package:fujin/domain/writing/ekklo_job.dart';
import 'package:fujin/domain/writing/writer_state.dart';

import '../../support/fixtures.dart';

void main() {
  final first = loggedEntry(entry('E-1'));
  final second = loggedEntry(entry('E-2'));

  test('moving to the next entry announces the one just written', () {
    final next = WriterRunning(current: second);

    check(next.writtenSince(WriterRunning(current: first))).equals(first);
    check(next.runEndedSince(WriterRunning(current: first))).isNull();
  });

  test('a held job changed during a write announces nothing', () {
    final writing = WriterRunning(current: first);
    final held = writing.withHeld({
      second.entry.id: EkkloRemoval(
        ekkloLinkRow('L-2', entryId: second.entry.id),
      ),
    });

    check(held.writtenSince(writing)).isNull();
    check(held.runEndedSince(writing)).isNull();
  });

  test('the end of a run announces its last entry and the end', () {
    const idle = WriterIdle();

    check(idle.writtenSince(WriterRunning(current: first))).equals(first);
    check(idle.runEndedSince(WriterRunning(current: first))).equals(idle);
  });

  test('a held job changed between runs ends no run', () {
    const idle = WriterIdle();
    final held = idle.withHeld({
      first.entry.id: EkkloRemoval(
        ekkloLinkRow('L-1', entryId: first.entry.id),
      ),
    });

    check(held.runEndedSince(idle)).isNull();
    check(idle.runEndedSince(null)).isNull();
  });
}
