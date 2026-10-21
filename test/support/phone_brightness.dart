import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart'
    show Finder, WidgetTester, addTearDown;
import 'package:fujin/app/theme/fujin_tokens.g.dart';

void phoneBrightness(WidgetTester tester, Brightness brightness) {
  tester.platformDispatcher.platformBrightnessTestValue = brightness;
  addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
}

FujinColors colorsAt(WidgetTester tester, Finder target) =>
    tester.element(target).colors;
