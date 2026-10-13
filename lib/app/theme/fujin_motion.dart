import 'package:flutter/animation.dart';
import 'package:motor/motor.dart';

abstract final class FujinMotion {
  static const Motion progress = MaterialSpringMotion.standardSpatialDefault();
  static const Motion drift = LinearMotion(Duration(milliseconds: 2800));
  static const CurvedMotion weekTurn = CurvedMotion(
    Duration(milliseconds: 350),
    Curves.easeOutCubic,
  );
  static const CurvedMotion mealFold = CurvedMotion(
    Duration(milliseconds: 250),
    Curves.easeOutCubic,
  );
  static const Motion bandNudge = CupertinoMotion(
    duration: Duration(milliseconds: 300),
  );
  static const Motion pill = MaterialSpringMotion.standardEffectsDefault(
    snapToEnd: true,
  );
  static const Motion pillSettle = MaterialSpringMotion.expressiveSpatialFast(
    snapToEnd: true,
  );
  static const Motion sheetIn = Motion.customSpring(
    SpringDescription(mass: 1, stiffness: 110, damping: 21),
  );
  static const Motion sheetOut = Motion.customSpring(
    SpringDescription(mass: 1, stiffness: 160, damping: 26),
  );
  static final AnimationStyle sheet = AnimationStyle(
    curve: sheetIn.toCurve,
    duration: const Duration(milliseconds: 500),
    reverseCurve: sheetOut.toCurve.flipped,
    reverseDuration: const Duration(milliseconds: 300),
  );
  static const AnimationStyle snackBar = AnimationStyle(
    duration: Duration(milliseconds: 400),
    reverseDuration: Duration(milliseconds: 250),
  );
}
