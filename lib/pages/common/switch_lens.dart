import 'package:flutter/widgets.dart';
import 'package:fujin/app/theme/fujin_glass.dart';
import 'package:fujin/app/theme/fujin_theme.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class SwitchLens extends StatelessWidget {
  const SwitchLens({required this.rect, required this.visibility, super.key});

  final Rect rect;
  final double visibility;

  static const double _unscaled = 1;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fade = visibility.clamp(0, 1).toDouble();
    final shape = LiquidRoundedRectangle(borderRadius: rect.height / 2);
    return IgnorePointer(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fromRect(
            rect: rect,
            child: RawMagnifier(
              size: rect.size,
              clipBehavior: Clip.antiAlias,
              magnificationScale:
                  _unscaled +
                  (FujinGlass.switchLensScale - _unscaled) * visibility,
              decoration: MagnifierDecoration(
                shape: shape,
                opacity: fade,
                shadows: [FujinTheme.smallFloatingShadow(colors)],
              ),
            ),
          ),
          Positioned.fromRect(
            rect: rect,
            child: LiquidGlass.withOwnLayer(
              settings: FujinGlass.switchLensEdge(visibility: visibility),
              shape: shape,
              child: CustomPaint(
                painter: _RimPainter(
                  shape: shape,
                  edge: colors.borderLensEdge,
                  highlight: colors.borderGlassHighlight,
                  reflection: colors.backgroundLensReflection,
                  fade: fade,
                ),
                child: const SizedBox.expand(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RimPainter extends CustomPainter {
  const _RimPainter({
    required this.shape,
    required this.edge,
    required this.highlight,
    required this.reflection,
    required this.fade,
  });

  final OutlinedBorder shape;
  final Color edge;
  final Color highlight;
  final Color reflection;
  final double fade;

  static const double _top = 0;
  static const double _bottom = 1;

  Color _faded(Color color) => color.withValues(alpha: color.a * fade);

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    final clear = reflection.withValues(alpha: 0);
    canvas
      ..save()
      ..clipPath(shape.getOuterPath(bounds))
      ..drawRect(
        bounds,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_faded(reflection), clear, clear, _faded(reflection)],
            stops: const [
              _top,
              FujinGlass.switchLensTopReflection,
              FujinGlass.switchLensBottomReflection,
              _bottom,
            ],
          ).createShader(bounds),
      )
      ..restore()
      ..drawPath(
        shape.getOuterPath(bounds.deflate(FujinStroke.card / 2)),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = FujinStroke.card
          ..shader = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_faded(edge), _faded(highlight)],
          ).createShader(bounds),
      );
  }

  @override
  bool shouldRepaint(_RimPainter oldDelegate) =>
      oldDelegate.shape != shape ||
      oldDelegate.edge != edge ||
      oldDelegate.highlight != highlight ||
      oldDelegate.reflection != reflection ||
      oldDelegate.fade != fade;
}
