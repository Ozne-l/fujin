import 'package:flutter/widgets.dart';
import 'package:fujin/app/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

abstract final class FujinGlass {
  static const double blend = 3;
  static const double switchLensTopReflection = 0.2;
  static const double switchLensBottomReflection = 0.88;
  static const double _tintLight = 0.14;
  static const double _tintDark = 0.24;
  static const double _faintTintLight = 0.04;
  static const double _faintTintDark = 0.2;
  static const double _darkContourStrength = 0.88;
  static const double _darkContourDirectionality = 1;
  static const double _floatingRefraction = 28;
  static const double _floatingFrost = 2.25;
  static const double _controlRefraction = 12;
  static const double _controlFrost = 4;
  static const double _switchLensRefraction = 10;
  static const double _switchLensShrink = 0.24;

  static double tint(Brightness brightness) => switch (brightness) {
    Brightness.light => _tintLight,
    Brightness.dark => _tintDark,
  };

  static double faintTint(Brightness brightness) => switch (brightness) {
    Brightness.light => _faintTintLight,
    Brightness.dark => _faintTintDark,
  };

  static LiquidGlassAppearance appearance(
    Brightness brightness, {
    Color? tint,
    double visibility = 1,
  }) => switch (tint) {
    null => LiquidGlassAppearance.ios27Regular(
      brightness: brightness,
      visibility: visibility,
    ),
    final tint => LiquidGlassAppearance.ios27Regular(
      brightness: brightness,
      tint: tint,
      visibility: visibility,
    ),
  };

  static const LiquidGlassSettings _floatingLight = LiquidGlassSettings(
    refractionHeight: _floatingRefraction,
    frost: _floatingFrost,
  );

  static const LiquidGlassSettings _floatingDark = LiquidGlassSettings(
    refractionHeight: _floatingRefraction,
    frost: _floatingFrost,
    contourStrength: _darkContourStrength,
    contourDirectionality: _darkContourDirectionality,
  );

  static LiquidGlassSettings floating(Brightness brightness) =>
      switch (brightness) {
        Brightness.light => _floatingLight,
        Brightness.dark => _floatingDark,
      };

  static const LiquidGlassSettings _controlLight = LiquidGlassSettings(
    refractionHeight: _controlRefraction,
    frost: _controlFrost,
  );

  static const LiquidGlassSettings _controlDark = LiquidGlassSettings(
    refractionHeight: _controlRefraction,
    frost: _controlFrost,
    contourStrength: _darkContourStrength,
    contourDirectionality: _darkContourDirectionality,
  );

  static LiquidGlassSettings control(Brightness brightness) =>
      switch (brightness) {
        Brightness.light => _controlLight,
        Brightness.dark => _controlDark,
      };

  static const LiquidGlassSettings lens = LiquidGlassSettings(frost: 0);

  static const LiquidGlassSettings _switchLens = LiquidGlassSettings(
    refractionHeight: _switchLensRefraction,
    frost: 0,
  );

  static LiquidGlassSettings switchLens(double visibility) =>
      _switchLens.copyWith(backdropShrink: _switchLensShrink * visibility);

  static bool reduced(BuildContext context, WidgetRef ref) =>
      MediaQuery.highContrastOf(context) ||
      (ref.watch(reduceTransparencyProvider).value ?? false);
}
