import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:fujin/app/theme/instant_motion.dart';
import 'package:motor/motor.dart';

abstract final class FujinMotion {
  static const Curve _standard = Cubic(0.2, 0, 0, 1);

  static const CurvedMotion effectsFast = CurvedMotion(
    Duration(milliseconds: 150),
    Curves.easeOut,
  );
  static const CurvedMotion effects = CurvedMotion(
    Duration(milliseconds: 300),
    Curves.easeOut,
  );
  static const CurvedMotion effectsSlow = CurvedMotion(
    Duration(milliseconds: 600),
    Curves.easeOut,
  );
  static const CurvedMotion spatialFast = CurvedMotion(
    Duration(milliseconds: 200),
    _standard,
  );
  static const CurvedMotion spatial = CurvedMotion(
    Duration(milliseconds: 250),
    _standard,
  );
  static const CurvedMotion spatialSlow = CurvedMotion(
    Duration(milliseconds: 400),
    _standard,
  );
  static const CurvedMotion flight = CurvedMotion(
    Duration(milliseconds: 300),
    Curves.fastOutSlowIn,
  );
  static const Motion gesture = CupertinoMotion.interactive(snapToEnd: true);
  static const Motion emphasis = CupertinoMotion.bouncy(
    duration: Duration(milliseconds: 350),
    snapToEnd: true,
  );
  static const double emphasisSwell = 1.2;

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

  static const Motion clockTurn = LinearMotion(Duration(seconds: 4));
  static const clockTurns = StepSequence<double>(
    [0, 1],
    motion: clockTurn,
    loop: LoopMode.seamless,
  );

  static double driftPhase(double cycle, int index, int count) =>
      (cycle + index / count) % 1;

  static double driftFade(double phase) =>
      math.sin(phase * math.pi).clamp(0, 1);

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

  static const Curve easeOutQuint = Cubic(0.23, 1, 0.32, 1);
  static const double swapScale = 0.1;
  static const CurvedMotion sendFlight = CurvedMotion(
    Duration(milliseconds: 250),
    easeOutQuint,
  );
  static const Motion lift = CupertinoMotion.snappy(
    duration: Duration(milliseconds: 250),
    snapToEnd: true,
  );
  static const double messageRise = 16;
  static const Motion sendFlightClock = LinearMotion(
    Duration(milliseconds: 250),
  );
  static const double liftScale = 1.03;
  static const Duration liftSettle = Duration(milliseconds: 300);
  static const Duration reactionStagger = Duration(milliseconds: 20);
  static const double reactionHover = 1.5;
  static const Motion reactionFlight = LinearMotion(
    Duration(milliseconds: 350),
  );
  static const Curve flightDrop = Curves.easeInOut;
  static const double pressShrink = 0.85;
  static const Motion _uploadSpin = LinearMotion(Duration(milliseconds: 2500));
  static const uploadSpinTurns = StepSequence<double>(
    [0, 1],
    motion: _uploadSpin,
    loop: LoopMode.seamless,
  );
  static const Duration uploadTick = Duration(milliseconds: 400);
  static const Duration viewerIdle = Duration(seconds: 3);
  static const Duration seekBadge = Duration(milliseconds: 700);
  static const Motion shake = LinearMotion(Duration(milliseconds: 300));
  static const int _shakeCycles = 3;
  static const double _shakeDistance = 4;

  static double shakeOffset(double shakes) {
    final progress = shakes % 1;
    return math.sin(progress * _shakeCycles * 2 * math.pi) *
        _shakeDistance *
        (1 - progress);
  }

  static const CurvedMotion gridFade = CurvedMotion(
    Duration(milliseconds: 400),
    Interval(0.5, 1, curve: Curves.easeOut),
  );
  static const recordingPulse = StepSequence<double>(
    [1, 0.35],
    motion: CurvedMotion(Duration(milliseconds: 1200), Curves.easeInOut),
    loop: LoopMode.pingPong,
  );
  static const Motion levelScroll = LinearMotion(Duration(milliseconds: 100));
  static const Motion playedFill = LinearMotion(Duration(milliseconds: 500));
  static const double scrubSwell = 1.6;

  static bool reduced(BuildContext context) =>
      MediaQuery.disableAnimationsOf(context) ||
      WidgetsBinding
          .instance
          .platformDispatcher
          .accessibilityFeatures
          .reduceMotion;

  static Motion of(BuildContext context, Motion motion) =>
      switch (reduced(context)) {
        true => const InstantMotion(),
        false => motion,
      };

  static Motion dissolveOf(BuildContext context, Motion motion) =>
      switch (reduced(context)) {
        true => effectsFast,
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
      duration: spatialSlow.duration,
      curve: spatialSlow.curve,
    ),
  };
}
