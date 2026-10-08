import 'dart:ui';

import 'package:fujin/app/theme/fujin_tokens.g.dart';

enum PillTone {
  validated(FujinColorRole.backgroundSuccess, FujinColorRole.textLink),
  attention(FujinColor.kinLight, FujinColorRole.textGold),
  info(FujinColorRole.backgroundInfo, FujinColor.sora),
  error(FujinColorRole.backgroundAlert, FujinColorRole.textAlert),
  neutral(FujinColor.kinari, FujinColorRole.textPrimary),
  muted(FujinColor.kinari, FujinColorRole.textSecondary),
  dark(FujinColor.sumi, FujinColor.washi);

  const PillTone(this.background, this.foreground);

  final Color background;
  final Color foreground;
}
