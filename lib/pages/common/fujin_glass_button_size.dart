import 'package:flutter/painting.dart';
import 'package:fujin/app/theme/fujin_theme.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';

enum FujinGlassButtonSize {
  large(
    drop: FujinSize.tabBar,
    target: FujinSize.tabBar,
    icon: FujinSize.scanIcon,
    shadow: FujinTheme.floatingShadow,
  ),
  small(
    drop: FujinSize.appearanceToggle,
    target: FujinSize.touchTarget,
    icon: FujinSize.appearanceToggleIcon,
    shadow: FujinTheme.smallFloatingShadow,
  );

  const FujinGlassButtonSize({
    required this.drop,
    required this.target,
    required this.icon,
    required this.shadow,
  });

  final double drop;
  final double target;
  final double icon;
  final BoxShadow Function(FujinColors colors) shadow;
}
