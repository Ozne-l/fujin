import 'dart:ui';

import 'package:fujin/app/theme/fujin_glass.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';

enum GlassFinish {
  clear,
  ink,
  validated,
  attention,
  info,
  alert,
  muted;

  Color foreground(FujinColors colors) => switch (this) {
    clear => colors.textPrimary,
    ink => colors.buttonPrimaryText,
    validated => colors.textLink,
    attention => colors.textGold,
    info => colors.textInfo,
    alert => colors.textAlert,
    muted => colors.textSecondary,
  };

  Color fill(FujinColors colors, Brightness brightness) => switch (this) {
    clear => colors.backgroundGlass,
    ink => colors.backgroundGlassInk,
    muted => foreground(
      colors,
    ).withValues(alpha: FujinGlass.faintTint(brightness)),
    validated || attention || info || alert => foreground(
      colors,
    ).withValues(alpha: FujinGlass.tint(brightness)),
  };

  Color rimHighlight(FujinColors colors, Brightness brightness) =>
      switch (this) {
        clear => colors.borderGlassHighlight,
        ink => colors.borderGlassInkHighlight,
        validated || attention || info || alert || muted => foreground(
          colors,
        ).withValues(alpha: FujinGlass.tintRimHighlight(brightness)),
      };

  Color rimShade(FujinColors colors, Brightness brightness) => switch (this) {
    clear => colors.borderGlassShade,
    ink => colors.borderGlassInkShade,
    validated || attention || info || alert || muted => foreground(
      colors,
    ).withValues(alpha: FujinGlass.tintRimShade(brightness)),
  };
}
