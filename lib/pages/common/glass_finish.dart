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
    validated => colors.textGlassLink,
    attention => colors.textGlassGold,
    info => colors.textGlassInfo,
    alert => colors.textGlassAlert,
    muted => colors.textGlassSecondary,
  };

  Color fill(FujinColors colors, Brightness brightness) => switch (this) {
    clear => colors.backgroundGlass,
    ink => colors.backgroundGlassInk,
    muted => colors.textSecondary.withValues(
      alpha: FujinGlass.faintTint(brightness),
    ),
    validated => colors.textLink.withValues(
      alpha: FujinGlass.tint(brightness),
    ),
    attention => colors.textGold.withValues(
      alpha: FujinGlass.tint(brightness),
    ),
    info => colors.textInfo.withValues(alpha: FujinGlass.tint(brightness)),
    alert => colors.textAlert.withValues(alpha: FujinGlass.tint(brightness)),
  };
}
