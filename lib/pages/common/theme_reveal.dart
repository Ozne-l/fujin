import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/data/settings/appearance.dart';
import 'package:fujin/pages/common/appearance_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:motor/motor.dart';

typedef _Reveal = ({ui.Image image, Offset origin, bool growing});

class ThemeReveal extends HookWidget {
  const ThemeReveal({required this.appearance, required this.child, super.key});

  final Appearance appearance;
  final Widget child;

  static void choose(
    BuildContext origin,
    WidgetRef ref,
    Appearance appearance,
  ) {
    void apply() =>
        unawaited(ref.read(appearanceProvider.notifier).choose(appearance));
    final target = switch (appearance) {
      Appearance.system => MediaQuery.platformBrightnessOf(origin),
      Appearance.light => Brightness.light,
      Appearance.dark => Brightness.dark,
    };
    if ((
          origin.getInheritedWidgetOfExactType<_RevealScope>(),
          origin.findRenderObject(),
        )
        case (final scope?, final RenderBox box)
        when target != Theme.of(origin).brightness) {
      final centre = box.localToGlobal(box.size.center(Offset.zero));
      scope.start((host) => host.globalToLocal(centre), apply);
    } else {
      apply();
    }
  }

  @override
  Widget build(BuildContext context) {
    final boundary = useMemoized(GlobalKey.new);
    final shown = useState<_Reveal?>(null);
    useEffect(
      () =>
          () => shown.value?.image.dispose(),
      const [],
    );

    void clear() {
      shown.value?.image.dispose();
      shown.value = null;
    }

    void start(Offset Function(RenderBox host) origin, VoidCallback apply) {
      if ((
            shown.value,
            FujinMotion.reduced(context),
            context.findRenderObject(),
            boundary.currentContext?.findRenderObject(),
          )
          case (
            null,
            false,
            final RenderBox host,
            final RenderRepaintBoundary capture,
          )) {
        final image = capture.toImageSync(
          pixelRatio: View.of(context).devicePixelRatio,
        );
        final at = origin(host);
        shown.value = (image: image, origin: at, growing: false);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted && shown.value?.image == image) {
            shown.value = (image: image, origin: at, growing: true);
          }
        });
      }
      apply();
    }

    useOnPlatformBrightnessChange((_, _) {
      switch (appearance) {
        case Appearance.system:
          start((host) => host.size.center(Offset.zero), () {});
        case Appearance.light || Appearance.dark:
          break;
      }
    });

    return _RevealScope(
      start: start,
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          RepaintBoundary(key: boundary, child: child),
          if (shown.value case final reveal?)
            Positioned.fill(
              child: AbsorbPointer(
                child: SingleMotionBuilder(
                  key: ObjectKey(reveal.image),
                  motion: FujinMotion.of(context, FujinMotion.themeReveal),
                  value: switch (reveal.growing) {
                    false => 0,
                    true => 1,
                  },
                  onAnimationStatusChanged: (status) {
                    if (status case AnimationStatus.completed) clear();
                  },
                  builder: (context, progress, _) => CustomPaint(
                    painter: _RevealPainter(reveal: reveal, progress: progress),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _RevealScope extends InheritedWidget {
  const _RevealScope({required this.start, required super.child});

  final void Function(
    Offset Function(RenderBox host) origin,
    VoidCallback apply,
  )
  start;

  @override
  bool updateShouldNotify(_RevealScope oldWidget) => false;
}

class _RevealPainter extends CustomPainter {
  const _RevealPainter({required this.reveal, required this.progress});

  final _Reveal reveal;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    final reach = [
      bounds.topLeft,
      bounds.topRight,
      bounds.bottomLeft,
      bounds.bottomRight,
    ].map((corner) => (corner - reveal.origin).distance).reduce(math.max);
    final image = reveal.image;
    canvas
      ..clipPath(
        Path()
          ..fillType = PathFillType.evenOdd
          ..addRect(bounds)
          ..addOval(
            Rect.fromCircle(center: reveal.origin, radius: reach * progress),
          ),
      )
      ..drawImageRect(
        image,
        Offset.zero & Size(image.width.toDouble(), image.height.toDouble()),
        bounds,
        Paint(),
      );
  }

  @override
  bool shouldRepaint(_RevealPainter oldDelegate) =>
      oldDelegate.reveal != reveal || oldDelegate.progress != progress;
}
