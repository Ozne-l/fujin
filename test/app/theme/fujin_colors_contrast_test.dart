import 'dart:math';
import 'dart:ui';

import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart' show group, test;
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/glass_finish.dart';

const _minimumContrast = 4.5;
const _flare = 0.05;

double _contrast(Color a, Color b) {
  final (lighter, darker) = (
    max(a.computeLuminance(), b.computeLuminance()),
    min(a.computeLuminance(), b.computeLuminance()),
  );
  return (lighter + _flare) / (darker + _flare);
}

void main() {
  for (final (theme, colors, brightness) in [
    ('light', FujinColors.light, Brightness.light),
    ('dark', FujinColors.dark, Brightness.dark),
  ]) {
    group('in the $theme theme', () {
      final texts = {
        'textPrimary': colors.textPrimary,
        'textSecondary': colors.textSecondary,
        'textTertiary': colors.textTertiary,
        'textLink': colors.textLink,
        'textGold': colors.textGold,
        'textAlert': colors.textAlert,
        'textInfo': colors.textInfo,
      };
      final backgrounds = {
        'backgroundPage': colors.backgroundPage,
        'backgroundCard': colors.backgroundCard,
      };
      final glassOver = [
        for (final finish in [
          GlassFinish.validated,
          GlassFinish.attention,
          GlassFinish.alert,
          GlassFinish.muted,
        ])
          for (final surface in backgrounds.entries) (finish, surface),
        (
          GlassFinish.alert,
          MapEntry('backgroundAlert', colors.backgroundAlert),
        ),
      ];
      final pairs = [
        for (final text in texts.entries)
          for (final background in backgrounds.entries) (text, background),
        (
          MapEntry('textSecondary', colors.textSecondary),
          MapEntry('backgroundNeutral', colors.backgroundNeutral),
        ),
        (
          MapEntry('textGold', colors.textGold),
          MapEntry('backgroundHighlight', colors.backgroundHighlight),
        ),
        (
          MapEntry('textOnDark', colors.textOnDark),
          MapEntry('backgroundDark', colors.backgroundDark),
        ),
        (
          MapEntry('textOnDarkSecondary', colors.textOnDarkSecondary),
          MapEntry('backgroundDark', colors.backgroundDark),
        ),
        (
          MapEntry('cameraTextSecondary', colors.cameraTextSecondary),
          MapEntry('cameraBackground', colors.cameraBackground),
        ),
        (
          MapEntry('buttonAlertText', colors.buttonAlertText),
          MapEntry('buttonAlertBackground', colors.buttonAlertBackground),
        ),
        for (final (finish, surface) in glassOver)
          (
            MapEntry('${finish.name} glass text', finish.foreground(colors)),
            MapEntry(
              'its tint over ${surface.key}',
              Color.alphaBlend(
                finish.fill(colors, brightness),
                surface.value,
              ),
            ),
          ),
      ];
      for (final (
            MapEntry(key: textName, value: text),
            MapEntry(key: backgroundName, value: background),
          )
          in pairs) {
        test('$textName reads at 4.5:1 on $backgroundName', () {
          check(
            _contrast(text, background),
          ).isGreaterOrEqual(_minimumContrast);
        });
      }
    });
  }
}
