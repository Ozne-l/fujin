import 'dart:async';

import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart'
    show WidgetTester, addTearDown, find, group, testWidgets;
import 'package:fujin/pages/common/sheet_frame.dart';

import '../../support/fake_backends.dart';
import '../../support/pump_fujin.dart';

const _title = 'Supprimer ?';
const _subtitle = 'Riz basmati, 1,5 tasse';
const _primary = 'Supprimer';
const _down = Offset(0, 500);
const _outside = Offset(10, 10);
const _settle = Duration(seconds: 1);

Future<ValueNotifier<bool>> _open(
  WidgetTester tester, {
  required bool busy,
}) async {
  final running = ValueNotifier(busy);
  addTearDown(running.dispose);
  await pumpFujin(tester, FakeBackends());
  await tester.pumpAndSettle();
  unawaited(
    SheetFrame.show(
      tester.element(find.byType(Scaffold).first),
      builder: (_) => ValueListenableBuilder(
        valueListenable: running,
        builder: (context, busy, _) => SheetFrame(
          title: _title,
          subtitle: _subtitle,
          primaryLabel: _primary,
          onPrimary: () {},
          onSkip: () {},
          busy: busy,
        ),
      ),
    ),
  );
  await _pump(tester);
  return running;
}

Future<void> _pump(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(_settle);
}

Future<void> _dragHandleDown(WidgetTester tester) async {
  final sheet = tester.getRect(find.byType(BottomSheet));
  await tester.dragFrom(
    sheet.topCenter + const Offset(0, kMinInteractiveDimension / 2),
    _down,
  );
  await _pump(tester);
}

bool _shown() => find.text(_title).evaluate().isNotEmpty;

void main() {
  group('a busy sheet', () {
    testWidgets('stays open when dragged down by its content or its handle', (
      tester,
    ) async {
      await _open(tester, busy: true);

      await tester.drag(find.text(_title), _down);
      await _pump(tester);
      check(_shown()).isTrue();

      await _dragHandleDown(tester);
      check(_shown()).isTrue();
    });

    testWidgets('stays open on a tap outside and on back', (tester) async {
      await _open(tester, busy: true);

      await tester.tapAt(_outside);
      await _pump(tester);
      check(_shown()).isTrue();

      await tester.binding.handlePopRoute();
      await _pump(tester);
      check(_shown()).isTrue();
    });

    testWidgets('closes on a drag down once no longer busy', (tester) async {
      final running = await _open(tester, busy: true);

      running.value = false;
      await _pump(tester);
      await _dragHandleDown(tester);

      check(_shown()).isFalse();
    });
  });

  testWidgets('a sheet at rest closes when dragged down', (tester) async {
    await _open(tester, busy: false);

    await tester.drag(find.text(_title), _down);
    await _pump(tester);

    check(_shown()).isFalse();
  });
}
