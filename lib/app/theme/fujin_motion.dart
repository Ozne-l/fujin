import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:fujin/app/theme/instant_motion.dart';
import 'package:motor/motor.dart';

abstract final class FujinMotion {
  static const Motion progress = MaterialSpringMotion.standardSpatialDefault();
  static const Motion spin = LinearMotion(Duration(milliseconds: 1200));
  static const spinTurns = StepSequence<double>(
    [0, 1],
    motion: spin,
    loop: LoopMode.seamless,
  );
  static const Motion drift = LinearMotion(Duration(milliseconds: 2800));
  static const driftCycle = StepSequence<double>(
    [0, 1],
    motion: drift,
    loop: LoopMode.seamless,
  );

  static double driftPhase(double cycle, int index, int count) =>
      (cycle + index / count) % 1;

  static double driftFade(double phase) =>
      math.sin(phase * math.pi).clamp(0, 1);

  static const CurvedMotion pageTurn = CurvedMotion(
    Duration(milliseconds: 350),
    Curves.easeOutCubic,
  );
  static const CurvedMotion mealFold = CurvedMotion(
    Duration(milliseconds: 250),
    Curves.easeOutCubic,
  );
  static const CurvedMotion rowRemoval = CurvedMotion(
    Duration(milliseconds: 250),
    Curves.easeOutCubic,
  );
  static const Duration rowRemovalStagger = Duration(milliseconds: 70);
  static const Motion bandNudge = CupertinoMotion(
    duration: Duration(milliseconds: 300),
  );
  static const Motion pill = MaterialSpringMotion.standardEffectsDefault(
    snapToEnd: true,
  );
  static const Motion pillSettle = MaterialSpringMotion.expressiveSpatialFast(
    snapToEnd: true,
  );
  static const Motion tabSlide = MaterialSpringMotion.expressiveSpatialDefault(
    snapToEnd: true,
  );
  static const double tabSquash = 0.04;
  static const double tabSquashLimit = 0.25;
  static const double glassPress = 1.04;
  static const double glassStretch = 0.3;
  static const double buttonSwell = 1.15;
  static const Motion iconTurn = CupertinoMotion.bouncy(
    duration: Duration(milliseconds: 450),
    snapToEnd: true,
  );
  static const double iconTurnAngle = math.pi / 2;
  static const Motion lensFollow = CupertinoMotion.interactive(
    snapToEnd: true,
  );
  static const Motion lensSwell = CupertinoMotion.snappy(
    duration: Duration(milliseconds: 300),
    snapToEnd: true,
  );
  static const double lensFling = 0.3;
  static const double lensTravel = 0.3;
  static const double lensFade = 0.2;
  static const Motion barMinimize = CupertinoMotion.smooth(
    duration: Duration(milliseconds: 400),
    snapToEnd: true,
  );
  static const double minimizedBarScale = 0.86;
  static const CurvedMotion fadeThrough = CurvedMotion(
    Duration(milliseconds: 280),
    Curves.easeOutCubic,
  );
  static const double fadeThroughScale = 0.98;
  static const CurvedMotion themeReveal = CurvedMotion(
    Duration(milliseconds: 675),
    Curves.easeOutCubic,
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

  static bool reduced(BuildContext context) =>
      MediaQuery.disableAnimationsOf(context);

  static Motion of(BuildContext context, Motion motion) =>
      switch (reduced(context)) {
        true => const InstantMotion(),
        false => motion,
      };

  static Future<void> turnPage(
    BuildContext context,
    PageController controller,
    int page,
  ) => switch (reduced(context)) {
    true => Future.sync(() => controller.jumpToPage(page)),
    false => controller.animateToPage(
      page,
      duration: pageTurn.duration,
      curve: pageTurn.curve,
    ),
  };
}
