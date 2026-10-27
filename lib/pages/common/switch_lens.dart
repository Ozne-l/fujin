import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_glass.dart';
import 'package:fujin/app/theme/fujin_theme.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/glass_shadow.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class SwitchLens extends StatelessWidget {
  const SwitchLens({required this.rect, required this.visibility, super.key});

  final Rect rect;
  final double visibility;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fade = visibility.clamp(0, 1).toDouble();
    final shape = LiquidRoundedRectangle(borderRadius: rect.height / 2);
    final shadow = FujinTheme.smallFloatingShadow(colors);
    return IgnorePointer(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fromRect(
            rect: rect,
            child: GlassShadow(
              shape: shape,
              shadow: shadow.copyWith(
                color: shadow.color.withValues(alpha: shadow.color.a * fade),
              ),
              child: LiquidGlass.withOwnLayer(
                settings: FujinGlass.switchLens(visibility),
                appearance: FujinGlass.appearance(
                  Theme.of(context).brightness,
                  visibility: visibility,
                ),
                shape: shape,
                child: CustomPaint(
                  painter: _ReflectionPainter(
                    shape: shape,
                    reflection: colors.backgroundLensReflection,
                    fade: fade,
                  ),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReflectionPainter extends CustomPainter {
  const _ReflectionPainter({
    required this.shape,
    required this.reflection,
    required this.fade,
  });

  final OutlinedBorder shape;
  final Color reflection;
  final double fade;

  static const double _top = 0;
  static const double _bottom = 1;

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    final faded = reflection.withValues(alpha: reflection.a * fade);
    final clear = reflection.withValues(alpha: 0);
    canvas
      ..clipPath(shape.getOuterPath(bounds))
      ..drawRect(
        bounds,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [faded, clear, clear, faded],
            stops: const [
              _top,
              FujinGlass.switchLensTopReflection,
              FujinGlass.switchLensBottomReflection,
              _bottom,
            ],
          ).createShader(bounds),
      );
  }

  @override
  bool shouldRepaint(_ReflectionPainter oldDelegate) =>
      oldDelegate.shape != shape ||
      oldDelegate.reflection != reflection ||
      oldDelegate.fade != fade;
}
