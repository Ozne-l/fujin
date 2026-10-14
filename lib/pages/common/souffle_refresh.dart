import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_theme.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/gold_volute.dart';
import 'package:motor/motor.dart';

class SouffleRefresh extends HookWidget {
  const SouffleRefresh({
    required this.onRefresh,
    required this.slivers,
    super.key,
  });

  final RefreshCallback onRefresh;
  final List<Widget> slivers;

  static const double _armedViewportFraction = 1 / 6;
  static const double _hidden = -FujinSize.controlHeight;
  static const double _rest = FujinSize.controlHeight;

  @override
  Widget build(BuildContext context) {
    final status = useState<RefreshIndicatorStatus?>(null);
    final pulled = useRef<double>(0);
    final pull = useState<double>(0);

    bool track(ScrollNotification notification) {
      if (notification.depth != 0) return false;
      final travel = switch (notification) {
        ScrollStartNotification() => -pulled.value,
        ScrollUpdateNotification(:final scrollDelta?) => -scrollDelta,
        OverscrollNotification(:final overscroll) => -overscroll,
        _ => 0.0,
      };
      pulled.value += travel;
      final armedAt =
          notification.metrics.viewportDimension * _armedViewportFraction;
      pull.value = (pulled.value / armedAt).clamp(0, 1);
      return false;
    }

    Widget placed(double progress) => Transform.translate(
      offset: Offset(0, _hidden + (_rest - _hidden) * progress),
      child: Opacity(
        opacity: progress.clamp(0, 1),
        child: _SouffleDisc(status: status.value, pull: progress),
      ),
    );

    void left(AnimationStatus animation) {
      if (animation.isCompleted &&
          status.value == RefreshIndicatorStatus.done) {
        status.value = null;
      }
    }

    Widget settle(double target) => SingleMotionBuilder(
      key: ValueKey(target),
      motion: FujinMotion.of(context, FujinMotion.progress),
      from: pull.value,
      value: target,
      builder: (context, progress, child) => placed(progress),
    );

    return RefreshIndicator.noSpinner(
      onRefresh: onRefresh,
      onStatusChange: (next) => status.value = next,
      child: Stack(
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: track,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: slivers,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Align(
                alignment: Alignment.topCenter,
                child: SingleMotionBuilder(
                  motion: FujinMotion.of(context, FujinMotion.pill),
                  value: status.value == RefreshIndicatorStatus.done ? 0 : 1,
                  onAnimationStatusChanged: left,
                  builder: (context, presence, child) => Opacity(
                    opacity: presence.clamp(0, 1),
                    child: Transform.scale(scale: presence, child: child),
                  ),
                  child: switch (status.value) {
                    RefreshIndicatorStatus.drag ||
                    RefreshIndicatorStatus.armed => placed(pull.value),
                    RefreshIndicatorStatus.snap ||
                    RefreshIndicatorStatus.refresh => settle(1),
                    RefreshIndicatorStatus.canceled => settle(0),
                    RefreshIndicatorStatus.done => placed(1),
                    null => const SizedBox.shrink(),
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SouffleDisc extends StatelessWidget {
  const _SouffleDisc({required this.status, required this.pull});

  final RefreshIndicatorStatus? status;
  final double pull;

  static const double _quarterTurn = math.pi / 2;
  static const double _fullTurn = math.pi * 2;

  @override
  Widget build(BuildContext context) {
    final (armed, refreshing) = switch (status) {
      RefreshIndicatorStatus.armed => (true, false),
      RefreshIndicatorStatus.snap || RefreshIndicatorStatus.refresh => (
        true,
        true,
      ),
      RefreshIndicatorStatus.drag ||
      RefreshIndicatorStatus.done ||
      RefreshIndicatorStatus.canceled ||
      null => (false, false),
    };
    return Container(
      width: FujinSize.controlHeight,
      height: FujinSize.controlHeight,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: FujinColorRole.backgroundCard,
        shape: BoxShape.circle,
        border: Border.all(color: FujinColorRole.borderCard),
        boxShadow: const [FujinTheme.floatingShadow],
      ),
      child: SingleMotionBuilder(
        motion: FujinMotion.of(context, FujinMotion.pill),
        value: armed ? _quarterTurn : 0,
        builder: (context, armedTurn, child) =>
            SequenceMotionBuilder<int, double>(
              sequence: FujinMotion.spinTurns,
              converter: MotionConverter.single,
              playing: refreshing,
              builder: (context, turn, phase, child) => Transform.rotate(
                angle: pull * _quarterTurn + armedTurn + turn * _fullTurn,
                child: child,
              ),
              child: child,
            ),
        child: const SizedBox.square(
          dimension: FujinSize.volute,
          child: GoldVolute(),
        ),
      ),
    );
  }
}
