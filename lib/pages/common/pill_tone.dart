import 'dart:ui';

import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/glass_finish.dart';

enum PillTone {
  validated,
  attention,
  info,
  error,
  neutral,
  muted,
  dark;

  Color background(FujinColors colors) => switch (this) {
    validated => colors.backgroundSuccess,
    attention => colors.backgroundHighlight,
    info => colors.backgroundInfo,
    error => colors.backgroundAlert,
    neutral || muted => colors.backgroundNeutral,
    dark => colors.backgroundDark,
  };

  GlassFinish get glass => switch (this) {
    validated => GlassFinish.validated,
    attention => GlassFinish.attention,
    info => GlassFinish.info,
    error => GlassFinish.alert,
    neutral => GlassFinish.clear,
    muted => GlassFinish.muted,
    dark => GlassFinish.ink,
  };

  Color foreground(FujinColors colors) => switch (this) {
    validated => colors.textLink,
    attention => colors.textGold,
    info => colors.textInfo,
    error => colors.textAlert,
    neutral => colors.textPrimary,
    muted => colors.textSecondary,
    dark => colors.buttonPrimaryText,
  };
}
