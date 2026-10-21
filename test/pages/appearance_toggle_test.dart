import 'dart:ui' show Tristate;

import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/data/settings/appearance.dart';
import 'package:fujin/data/settings/settings_repository.dart';
import 'package:fujin/pages/common/appearance_toggle.dart';

import '../support/fake_backends.dart';
import '../support/fixtures.dart';
import '../support/in_memory_preferences.dart';
import '../support/phone_brightness.dart';
import '../support/pump_fujin.dart';

const _toDark = 'Passer en thème sombre';
const _toLight = 'Passer en thème clair';
const _sunIcon = 'assets/icons/sun.svg';
const _appName = 'Fūjin';
const _scroll = 120.0;

Future<void> _tap(WidgetTester tester, Finder target) async {
  await tester.tap(target);
  await tester.pumpAndSettle();
}

FujinColors _colors(WidgetTester tester) =>
    colorsAt(tester, find.byType(AppearanceToggle));

void main() {
  testWidgets('sets Apparence to Sombre from the light Journal', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    phoneBrightness(tester, Brightness.light);
    final preferences = await inMemoryPreferences();
    await pumpFujin(
      tester,
      FakeBackends(mealNames: [breakfast]),
      preferences: preferences,
    );

    await _tap(tester, find.bySemanticsLabel(_toDark));

    check(SettingsRepository(preferences).appearance()).equals(Appearance.dark);
    check(_colors(tester)).identicalTo(FujinColors.dark);
    check(find.bySemanticsLabel(_toLight).evaluate()).length.equals(1);
    semantics.dispose();
  });

  testWidgets('stays in the top corner while the Journal scrolls under it and '
      'still switches the theme', (tester) async {
    final semantics = tester.ensureSemantics();
    phoneBrightness(tester, Brightness.light);
    await pumpFujin(tester, FakeBackends(mealNames: [breakfast]));
    final toggle = tester.getCenter(find.byType(AppearanceToggle));

    await tester.drag(find.text(breakfast), const Offset(0, -_scroll));
    await tester.pumpAndSettle();

    check(find.text(_appName).hitTestable().evaluate()).isEmpty();
    check(tester.getCenter(find.byType(AppearanceToggle))).equals(toggle);

    await _tap(tester, find.bySemanticsLabel(_toDark));

    check(_colors(tester)).identicalTo(FujinColors.dark);
    semantics.dispose();
  });

  testWidgets('sets Apparence to Clair from the dark Mémoire', (tester) async {
    final semantics = tester.ensureSemantics();
    phoneBrightness(tester, Brightness.light);
    final preferences = await inMemoryPreferences();
    await SettingsRepository(preferences).setAppearance(Appearance.dark);
    await pumpFujin(
      tester,
      FakeBackends(mealNames: [breakfast]),
      preferences: preferences,
    );
    await _tap(tester, find.text('Mémoire'));

    await _tap(tester, find.bySemanticsLabel(_toLight));

    check(
      SettingsRepository(preferences).appearance(),
    ).equals(Appearance.light);
    check(_colors(tester)).identicalTo(FujinColors.light);
    semantics.dispose();
  });

  testWidgets('shows the sun with Système on a dark phone and leaves Système '
      'for Clair in Réglages', (tester) async {
    final semantics = tester.ensureSemantics();
    phoneBrightness(tester, Brightness.dark);
    final preferences = await inMemoryPreferences();
    await pumpFujin(
      tester,
      FakeBackends(mealNames: [breakfast]),
      preferences: preferences,
    );
    await _tap(tester, find.text('Réglages').last);

    Tristate selected(String segment) => tester
        .getSemantics(find.bySemanticsLabel(segment))
        .flagsCollection
        .isSelected;

    check(
      find
          .descendant(
            of: find.byType(AppearanceToggle),
            matching: find.byWidgetPredicate(
              (widget) => switch (widget) {
                SvgPicture(
                  bytesLoader: SvgAssetLoader(:final assetName),
                ) =>
                  assetName == _sunIcon,
                _ => false,
              },
            ),
          )
          .evaluate(),
    ).length.equals(1);
    check(selected('Système')).equals(Tristate.isTrue);

    await _tap(tester, find.bySemanticsLabel(_toLight));

    check(
      SettingsRepository(preferences).appearance(),
    ).equals(Appearance.light);
    check(_colors(tester)).identicalTo(FujinColors.light);
    check(selected('Clair')).equals(Tristate.isTrue);
    check(selected('Système')).equals(Tristate.isFalse);
    semantics.dispose();
  });

  testWidgets('follows a phone turning dark with Système and answers the next '
      'tap once the theme has changed', (tester) async {
    final semantics = tester.ensureSemantics();
    phoneBrightness(tester, Brightness.light);
    final preferences = await inMemoryPreferences();
    await pumpFujin(
      tester,
      FakeBackends(mealNames: [breakfast]),
      preferences: preferences,
    );

    phoneBrightness(tester, Brightness.dark);
    await tester.pumpAndSettle();

    check(_colors(tester)).identicalTo(FujinColors.dark);

    await _tap(tester, find.bySemanticsLabel(_toLight));

    check(
      SettingsRepository(preferences).appearance(),
    ).equals(Appearance.light);
    check(_colors(tester)).identicalTo(FujinColors.light);
    semantics.dispose();
  });
}
