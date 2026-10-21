import 'package:flutter/services.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';

abstract final class FujinSystemBars {
  static SystemUiOverlayStyle of(FujinColors colors, Brightness brightness) =>
      _over(colors.backgroundPage, brightness);

  static SystemUiOverlayStyle camera(FujinColors colors) =>
      _over(colors.cameraBackground, Brightness.dark);

  static SystemUiOverlayStyle _over(Color background, Brightness brightness) {
    final icons = switch (brightness) {
      Brightness.light => Brightness.dark,
      Brightness.dark => Brightness.light,
    };
    return SystemUiOverlayStyle(
      statusBarIconBrightness: icons,
      statusBarBrightness: brightness,
      systemNavigationBarColor: background,
      systemNavigationBarIconBrightness: icons,
    );
  }
}
