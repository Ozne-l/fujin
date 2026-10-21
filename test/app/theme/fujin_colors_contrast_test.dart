import 'dart:math';
import 'dart:ui';

import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart' show group, test;
import 'package:fujin/app/theme/fujin_tokens.g.dart';

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
  for (final (theme, colors) in [
    ('light', FujinColors.light),
    ('dark', FujinColors.dark),
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
      final pairs = [
        for (final text in texts.entries)
          for (final background in backgrounds.entries) (text, background),
        (
          MapEntry('cameraTextSecondary', colors.cameraTextSecondary),
          MapEntry('cameraBackground', colors.cameraBackground),
        ),
        (
          MapEntry('buttonAlertText', colors.buttonAlertText),
          MapEntry('buttonAlertBackground', colors.buttonAlertBackground),
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
