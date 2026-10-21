import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/fujin_glass_button_size.dart';
import 'package:fujin/pages/common/glass_surface.dart';
import 'package:motor/motor.dart';

class FujinGlassButton extends HookWidget {
  const FujinGlassButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.size,
    super.key,
  });

  final String icon;
  final String label;
  final VoidCallback? onPressed;
  final FujinGlassButtonSize size;

  static const double _rest = 1;

  @override
  Widget build(BuildContext context) {
    final settled = useState(icon);
    final held = useState(false);
    final colour = switch (onPressed) {
      null => context.colors.textDisabled,
      _ => context.colors.textPrimary,
    };

    Widget drawn(String asset) => SvgPicture.asset(
      asset,
      width: size.icon,
      height: size.icon,
      theme: SvgTheme(currentColor: colour),
      excludeFromSemantics: true,
    );

    Widget turned(double turn, Widget child) => Opacity(
      opacity: (1 - turn.abs()).clamp(0, 1),
      child: Transform.rotate(
        angle: turn * FujinMotion.iconTurnAngle,
        child: child,
      ),
    );

    final leaving = settled.value;
    final face = switch (leaving == icon) {
      true => drawn(icon),
      false => SingleMotionBuilder(
        key: ValueKey(icon),
        motion: FujinMotion.of(context, FujinMotion.iconTurn),
        from: 0,
        value: 1,
        onAnimationStatusChanged: (status) {
          if (status.isCompleted) settled.value = icon;
        },
        builder: (context, progress, child) => Stack(
          alignment: Alignment.center,
          children: [
            turned(progress, drawn(leaving)),
            turned(progress - 1, child ?? drawn(icon)),
          ],
        ),
        child: drawn(icon),
      ),
    };

    return Semantics(
      container: true,
      button: true,
      enabled: onPressed != null,
      label: label,
      excludeSemantics: true,
      onTap: onPressed,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        onTapDown: (_) => held.value = onPressed != null,
        onTapUp: (_) => held.value = false,
        onTapCancel: () => held.value = false,
        child: SizedBox.square(
          dimension: size.target,
          child: OverflowBox(
            maxWidth: double.infinity,
            maxHeight: double.infinity,
            child: SingleMotionBuilder(
              motion: FujinMotion.of(context, FujinMotion.lensSwell),
              value: switch (held.value) {
                true => FujinMotion.buttonSwell,
                false => _rest,
              },
              builder: (context, swell, child) => GlassSurface(
                height: size.drop * swell,
                glows: true,
                shadow: size.shadow,
                child: SizedBox.square(
                  dimension: size.drop * swell,
                  child: child,
                ),
              ),
              child: Center(child: face),
            ),
          ),
        ),
      ),
    );
  }
}
