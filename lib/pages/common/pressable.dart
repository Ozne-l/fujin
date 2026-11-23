import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:motor/motor.dart';

enum _Press { row, card, glass }

class Pressable extends HookWidget {
  const Pressable.row({required this.onTap, required this.child, super.key})
    : _press = _Press.row;

  const Pressable.card({required this.onTap, required this.child, super.key})
    : _press = _Press.card;

  const Pressable.glass({required this.onTap, required this.child, super.key})
    : _press = _Press.glass;

  final _Press _press;
  final VoidCallback? onTap;
  final Widget child;

  static const double _rest = 1;
  static const double _untinted = 0;
  static const double _tinted = 1;

  @override
  Widget build(BuildContext context) {
    final touched = useState(false);
    final onTap = this.onTap;
    final held = touched.value && onTap != null;

    Widget shrunk(double scale) => SingleMotionBuilder(
      motion: FujinMotion.of(context, FujinMotion.lift),
      value: switch (held) {
        true => scale,
        false => _rest,
      },
      builder: (context, scale, child) =>
          Transform.scale(scale: scale, child: child),
      child: child,
    );

    final pressed = switch (_press) {
      _Press.row => SingleMotionBuilder(
        motion: FujinMotion.of(context, FujinMotion.effectsFast),
        value: switch (held) {
          true => _tinted,
          false => _untinted,
        },
        builder: (context, tint, child) {
          final colour = context.colors.backgroundPressed;
          return ColoredBox(
            color: colour.withValues(alpha: colour.a * tint.clamp(0, 1)),
            child: child,
          );
        },
        child: child,
      ),
      _Press.card => shrunk(FujinMotion.cardShrink),
      _Press.glass => shrunk(FujinMotion.pressShrink),
    };

    void release() => touched.value = false;

    return Semantics(
      button: onTap != null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        onTapDown: switch (onTap) {
          null => null,
          _ => (_) => touched.value = true,
        },
        onTapUp: switch (onTap) {
          null => null,
          _ => (_) => release(),
        },
        onTapCancel: switch (onTap) {
          null => null,
          _ => release,
        },
        child: pressed,
      ),
    );
  }
}
