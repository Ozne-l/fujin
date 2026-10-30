import 'dart:math';

import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/row_action.dart';

import '../support/fake_backends.dart';
import '../support/fixtures.dart';
import '../support/logged_journal.dart';

const String _row = LoggedJournal.basmati;
const String _otherRow = LoggedJournal.oatFlakes;
const String _below = LoggedJournal.skyrNature;
const _action = 'Supprimer';
const _sheetTitle = 'Supprimer Riz basmati ?';
const _confirm = 'Supprimer de MFP et Ekklo';
const _keep = 'Garder';
const _confirmMfp = 'Supprimer de MFP';
const _mfpOnlyCopy =
    'Pas encore dans Ekklo : il sera retiré de MyFitnessPal seulement.';
const _slowDrag = Duration(seconds: 1);
const _mfpNotWritten = 'Pas écrit dans MyFitnessPal';
const _deletedInFujin = 'Supprimé dans Fūjin';

FakeBackends _backends() => LoggedJournal.backends();

Finder _snackBarText(String text) =>
    find.descendant(of: find.byType(SnackBar), matching: find.text(text));

Future<void> _pump(WidgetTester tester, FakeBackends backends) =>
    LoggedJournal.pump(tester, backends);

double _width(WidgetTester tester) =>
    tester.view.physicalSize.width / tester.view.devicePixelRatio;

Future<void> _drag(WidgetTester tester, String row, double share) async {
  await tester.timedDrag(
    find.text(row),
    Offset(-_width(tester) * share, 0),
    _slowDrag,
  );
  await tester.pumpAndSettle();
}

Iterable<String> _deletes(FakeBackends backends) => [
  for (final request in backends.requests)
    if (request.method == 'DELETE') request.url.host,
];

void main() {
  testWidgets('closes back after a short drag', (tester) async {
    await _pump(tester, _backends());

    await _drag(tester, _row, 0.1);

    check(find.text(_action).hitTestable().evaluate()).isEmpty();
  });

  testWidgets('stays open on Supprimer after a quarter of the row', (
    tester,
  ) async {
    await _pump(tester, _backends());

    await _drag(tester, _row, 0.25);

    check(find.text(_action).hitTestable().evaluate()).length.equals(1);
  });

  testWidgets('keeps the open row clear of Supprimer', (tester) async {
    await _pump(tester, _backends());

    await _drag(tester, _row, 0.25);

    final row = tester.getRect(
      find
          .ancestor(
            of: find.text(_row),
            matching: find.byType(GestureDetector),
          )
          .first,
    );
    final button = tester.getRect(find.byType(RowAction));
    check(button.left - row.right).equals(FujinSpace.s4);
  });

  testWidgets('gives Supprimer the whole height between the dividers', (
    tester,
  ) async {
    await _pump(tester, _backends());

    await _drag(tester, _row, 0.25);

    final button = tester.getRect(find.byType(RowAction));
    final found = find.byType(Divider);
    final dividers = List.generate(
      found.evaluate().length,
      (index) => tester.getRect(found.at(index)),
    );
    check(
      dividers
          .where((divider) => divider.bottom <= button.top)
          .map((divider) => divider.bottom)
          .reduce(max),
    ).equals(button.top);
    check(
      dividers
          .where((divider) => divider.top >= button.bottom)
          .map((divider) => divider.top)
          .reduce(min),
    ).equals(button.bottom);
  });

  testWidgets('asks before removing after a long swipe, with the row '
      'closed under the sheet', (tester) async {
    await _pump(tester, _backends());

    await _drag(tester, _row, 0.8);

    check(find.text(_sheetTitle).evaluate()).length.equals(1);
    check(find.text(_action).hitTestable().evaluate()).isEmpty();
  });

  testWidgets('removes nothing on Garder', (tester) async {
    final backends = _backends();
    await _pump(tester, backends);
    await _drag(tester, _row, 0.25);
    await tester.tap(find.text(_action));
    await tester.pumpAndSettle();

    await tester.tap(find.text(_keep));
    await tester.pumpAndSettle();

    check(find.text(_sheetTitle).evaluate()).isEmpty();
    check(_deletes(backends)).isEmpty();
    check(find.text(_row).evaluate()).length.equals(1);
  });

  testWidgets('removes the food from Ekklo, then MyFitnessPal, and says so', (
    tester,
  ) async {
    final backends = _backends();
    await _pump(tester, backends);
    await _drag(tester, _row, 0.8);

    await tester.tap(find.text(_confirm));
    await tester.pumpAndSettle();

    check(
      _deletes(backends),
    ).deepEquals([ekkloUri.host, mfpApiUri.host]);
    check(find.text(_sheetTitle).evaluate()).isEmpty();
    check(find.text(_row).evaluate()).isEmpty();
    check(find.text('Riz basmati supprimé').evaluate()).length.equals(1);
    check(_snackBarText(lunch).evaluate()).length.equals(1);
  });

  testWidgets('keeps the row greyed and says the removal is not written in '
      'MyFitnessPal once Ekklo let go of the food, and finishes it on '
      'Réessayer', (tester) async {
    final backends = _backends()..mfpRemoveFails = true;
    await _pump(tester, backends);
    await _drag(tester, _row, 0.8);

    await tester.tap(find.text(_confirm));
    await tester.pumpAndSettle();

    check(backends.ekkloItems.map((item) => item.id)).not(
      (it) => it.contains(LoggedJournal.basmatiItem),
    );
    check(find.text(_row).evaluate()).length.equals(1);
    check(find.text(_deletedInFujin).evaluate()).length.equals(1);
    check(find.text(_mfpNotWritten).evaluate()).length.equals(1);
    check(find.text('$_row reste en attente').evaluate()).length.equals(1);

    backends.mfpRemoveFails = false;
    await tester.tap(find.text('Réessayer'));
    await tester.pumpAndSettle();

    check(
      backends.entries.map((entry) => entry.id),
    ).not((it) => it.contains(LoggedJournal.basmatiId));
    check(find.text(_mfpNotWritten).evaluate()).isEmpty();
    check(find.text(_row).evaluate()).isEmpty();
  });

  testWidgets('removes a food still to send from MyFitnessPal only, and says '
      'so', (tester) async {
    final backends = _backends();
    await _pump(tester, backends);

    await _drag(tester, _below, 0.8);

    check(find.textContaining(_mfpOnlyCopy).evaluate()).length.equals(1);

    await tester.tap(find.text(_confirmMfp));
    await tester.pumpAndSettle();

    check(_deletes(backends)).deepEquals([mfpApiUri.host]);
    check(backends.ekkloItems).length.equals(1);
    check(find.text(_below).evaluate()).isEmpty();
    check(find.text('Skyr nature supprimé').evaluate()).length.equals(1);
    check(_snackBarText(lunch).evaluate()).length.equals(1);
  });

  testWidgets('removes the row at once and says MyFitnessPal is waiting '
      'when it refuses the removal', (tester) async {
    final backends = _backends()..mfpRemoveFails = true;
    await _pump(tester, backends);
    await _drag(tester, _below, 0.8);

    await tester.tap(find.text(_confirmMfp));
    await tester.pumpAndSettle();

    check(find.text(_below).evaluate()).isEmpty();
    check(find.text(_mfpNotWritten).evaluate()).length.equals(1);
    check(find.text('$_below reste en attente').evaluate()).length.equals(1);
    check(find.text('Réessayer').evaluate()).length.equals(1);
    check(
      backends.entries.map((entry) => entry.id),
    ).contains(LoggedJournal.skyrId);
  });

  testWidgets('slides the rows below a deleted food up into its place', (
    tester,
  ) async {
    await _pump(tester, _backends());
    final start = tester.getTopLeft(find.text(_below)).dy;
    await _drag(tester, _row, 0.8);

    await tester.tap(find.text(_confirm));
    await tester.pump();
    await tester.pump();
    final sliding = tester.getTopLeft(find.text(_below)).dy;
    await tester.pumpAndSettle();
    final end = tester.getTopLeft(find.text(_below)).dy;

    check(end).isLessThan(start);
    check(sliding).isGreaterThan(end);
  });

  testWidgets('keeps one row open at a time', (tester) async {
    await _pump(tester, _backends());
    await _drag(tester, _row, 0.25);

    await _drag(tester, _otherRow, 0.25);

    check(find.text(_action).hitTestable().evaluate()).length.equals(1);
    check(
      tester.getTopLeft(find.text(_row)).dx,
    ).isGreaterThan(tester.getTopLeft(find.text(_otherRow)).dx);
  });

  testWidgets('closes an open row on a tap without opening the fiche', (
    tester,
  ) async {
    await _pump(tester, _backends());
    await _drag(tester, _row, 0.25);

    await tester.tap(find.text(_row));
    await tester.pumpAndSettle();

    check(find.text('Modifier l’aliment').evaluate()).isEmpty();
    check(find.text(_action).hitTestable().evaluate()).isEmpty();
  });

  testWidgets('opens the fiche in edit mode on a tap on a closed row', (
    tester,
  ) async {
    await _pump(tester, _backends());

    await tester.tap(find.text(_row));
    await tester.pumpAndSettle();

    check(find.text('Modifier l’aliment').evaluate()).length.equals(1);
  });

  testWidgets('uncovers nothing offline', (tester) async {
    final backends = _backends();
    await _pump(tester, backends);
    await LoggedJournal.goOffline(tester, backends, showing: _row);
    check(find.text('Dans Ekklo').evaluate()).isEmpty();

    await _drag(tester, _row, 0.5);

    check(find.text(_action).hitTestable().evaluate()).isEmpty();
  });

  testWidgets('opens the sheet from the Supprimer semantics action', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await _pump(tester, _backends());

    tester.semantics.customAction(
      find.semantics.byLabel(RegExp(_row)).first,
      const CustomSemanticsAction(label: _action),
    );
    await tester.pumpAndSettle();

    check(find.text(_sheetTitle).evaluate()).length.equals(1);
    semantics.dispose();
  });

  testWidgets('lands the removal at once with reduced motion', (tester) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    await _pump(tester, _backends());
    await _drag(tester, _row, 0.8);

    await tester.tap(find.text(_confirm));
    await tester.pump();
    await tester.pump();
    final first = tester.getTopLeft(find.text(_below));
    await tester.pumpAndSettle();

    check(tester.getTopLeft(find.text(_below))).equals(first);
  });
}
