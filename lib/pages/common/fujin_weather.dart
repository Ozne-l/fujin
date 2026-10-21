import 'dart:ui';

import 'package:fujin/app/theme/fujin_tokens.g.dart';

enum FujinWeather {
  calm('assets/icons/weather/calm.svg'),
  breeze('assets/icons/weather/breeze.svg'),
  gust('assets/icons/weather/gust.svg'),
  storm('assets/icons/weather/storm.svg');

  const FujinWeather(this.asset);

  final String asset;

  Color background(FujinColors colors) => switch (this) {
    calm => colors.backgroundSuccess,
    breeze => colors.backgroundInfo,
    gust => colors.backgroundHighlight,
    storm => colors.backgroundCard,
  };

  Color foreground(FujinColors colors) => switch (this) {
    calm => colors.textLink,
    breeze => colors.textInfo,
    gust => colors.textGold,
    storm => colors.textAlert,
  };
}
