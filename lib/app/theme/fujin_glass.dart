import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:fujin/app/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

abstract final class FujinGlass {
  static const double blend = 3;
  static const double switchLensScale = 0.76;
  static const double switchLensTopReflection = 0.2;
  static const double switchLensBottomReflection = 0.88;
  static const double _lightAngleDegrees = -45;
  static const double _halfTurnDegrees = 180;
  static const double _lightAngle = _lightAngleDegrees * pi / _halfTurnDegrees;
  static const double _tintLight = 0.14;
  static const double _tintDark = 0.24;
  static const double _faintTintLight = 0.04;
  static const double _faintTintDark = 0.2;
  static const double _tintRimHighlightLight = 0.75;
  static const double _tintRimHighlightDark = 0.9;
  static const double _tintRimShadeLight = 0.15;
  static const double _tintRimShadeDark = 0.25;

  static double tint(Brightness brightness) => switch (brightness) {
    Brightness.light => _tintLight,
    Brightness.dark => _tintDark,
  };

  static double faintTint(Brightness brightness) => switch (brightness) {
    Brightness.light => _faintTintLight,
    Brightness.dark => _faintTintDark,
  };

  static double tintRimHighlight(Brightness brightness) => switch (brightness) {
    Brightness.light => _tintRimHighlightLight,
    Brightness.dark => _tintRimHighlightDark,
  };

  static double tintRimShade(Brightness brightness) => switch (brightness) {
    Brightness.light => _tintRimShadeLight,
    Brightness.dark => _tintRimShadeDark,
  };

  static const LiquidGlassSettings _floatingLight = LiquidGlassSettings(
    thickness: 28,
    blur: 2,
    chromaticAberration: 0.15,
    lightIntensity: 1,
    ambientStrength: 0.5,
    lightAngle: _lightAngle,
  );

  static const LiquidGlassSettings _floatingDark = LiquidGlassSettings(
    thickness: 28,
    blur: 2,
    chromaticAberration: 0.15,
    lightIntensity: 0.4,
    ambientStrength: 0.2,
    lightAngle: _lightAngle,
  );

  static LiquidGlassSettings floating(Brightness brightness) =>
      switch (brightness) {
        Brightness.light => _floatingLight,
        Brightness.dark => _floatingDark,
      };

  static const LiquidGlassSettings _controlLight = LiquidGlassSettings(
    thickness: 12,
    blur: 4,
    chromaticAberration: 0.1,
    lightIntensity: 1,
    ambientStrength: 0.5,
    lightAngle: _lightAngle,
  );

  static const LiquidGlassSettings _controlDark = LiquidGlassSettings(
    thickness: 12,
    blur: 4,
    chromaticAberration: 0.1,
    lightIntensity: 0.4,
    ambientStrength: 0.2,
    lightAngle: _lightAngle,
  );

  static LiquidGlassSettings control(Brightness brightness) =>
      switch (brightness) {
        Brightness.light => _controlLight,
        Brightness.dark => _controlDark,
      };

  static LiquidGlassSettings lens({
    required double visibility,
    required Color tint,
  }) => LiquidGlassSettings(
    visibility: visibility,
    glassColor: tint,
    refractiveIndex: 1.15,
    blur: 0,
    chromaticAberration: 0.2,
    lightIntensity: 1,
    lightAngle: _lightAngle,
  );

  static LiquidGlassSettings switchLensEdge({required double visibility}) =>
      LiquidGlassSettings(
        visibility: visibility,
        thickness: 10,
        blur: 0,
        saturation: 1,
        chromaticAberration: 0.4,
        lightIntensity: 0.6,
        lightAngle: _lightAngle,
      );

  static bool reduced(BuildContext context, WidgetRef ref) =>
      MediaQuery.highContrastOf(context) ||
      (ref.watch(reduceTransparencyProvider).value ?? false);
}
