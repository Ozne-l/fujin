import 'package:flutter/widgets.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/breeze_streaks.dart';
import 'package:motor/motor.dart';

class BreezeIndicator extends StatelessWidget {
  const BreezeIndicator({
    required this.streaks,
    this.drifting = false,
    super.key,
  });

  final BreezeStreaks streaks;
  final bool drifting;

  @override
  Widget build(BuildContext context) => switch (drifting) {
    true => SequenceMotionBuilder<int, double>(
      sequence: FujinMotion.driftCycle,
      converter: MotionConverter.single,
      builder: (context, drift, _, _) => _layout(context, drift),
    ),
    false => _layout(context, null),
  };

  Widget _layout(BuildContext context, double? drift) {
    final direction = switch (Directionality.of(context)) {
      TextDirection.ltr => 1,
      TextDirection.rtl => -1,
    };
    final count = streaks.streaks.length;

    Widget streakAt(int index, ({double start, double length}) streak) {
      final line = _Streak(start: streak.start, length: streak.length);
      return switch (drift) {
        null => line,
        final drift => _Drifting(
          phase: FujinMotion.driftPhase(drift, index, count),
          direction: direction,
          child: line,
        ),
      };
    }

    return Container(
      width: streaks.width,
      padding: streaks.padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: streaks.alignment,
        spacing: streaks.gap,
        children: [
          for (final (index, streak) in streaks.streaks.indexed)
            streakAt(index, streak),
        ],
      ),
    );
  }
}

class _Drifting extends StatelessWidget {
  const _Drifting({
    required this.phase,
    required this.direction,
    required this.child,
  });

  final double phase;
  final int direction;
  final Widget child;

  @override
  Widget build(BuildContext context) => Opacity(
    opacity: FujinMotion.driftFade(phase),
    child: Transform.translate(
      offset: Offset((phase * 2 - 1) * FujinSize.streakOffset * direction, 0),
      child: child,
    ),
  );
}

class _Streak extends StatelessWidget {
  const _Streak({required this.start, required this.length});

  final double start;
  final double length;

  @override
  Widget build(BuildContext context) => Container(
    margin: EdgeInsetsDirectional.only(start: start),
    width: length,
    height: FujinStroke.streak,
    decoration: const BoxDecoration(
      color: FujinColor.sora,
      borderRadius: BorderRadius.all(Radius.circular(FujinRadius.pill)),
    ),
  );
}
