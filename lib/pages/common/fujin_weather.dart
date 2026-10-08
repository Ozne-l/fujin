import 'dart:ui';

import 'package:fujin/app/theme/fujin_tokens.g.dart';

enum FujinWeather {
  calm(
    'assets/icons/weather/calm.svg',
    FujinColorRole.backgroundSuccess,
    FujinColor.fujin,
  ),
  breeze(
    'assets/icons/weather/breeze.svg',
    FujinColorRole.backgroundInfo,
    FujinColor.sora,
  ),
  gust(
    'assets/icons/weather/gust.svg',
    FujinColor.kinLight,
    FujinColor.kinDark,
  ),
  storm('assets/icons/weather/storm.svg', FujinColor.kinu, FujinColor.shu);

  const FujinWeather(this.asset, this.background, this.foreground);

  final String asset;
  final Color background;
  final Color foreground;
}
