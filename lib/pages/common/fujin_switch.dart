import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/lens_swell.dart';
import 'package:fujin/pages/common/switch_lens.dart';
import 'package:motor/motor.dart';

class FujinSwitch extends HookWidget {
  const FujinSwitch({required this.value, required this.onChanged, super.key});

  final bool value;
  final ValueChanged<bool> onChanged;

  static const double _off = 0;
  static const double _on = 1;
  static const double _half = 0.5;
  static const double _inset =
      (FujinSize.switchHeight - FujinSize.switchThumbHeight) / 2;
  static const double _travel =
      FujinSize.switchWidth - FujinSize.switchThumbWidth - _inset * 2;
  static const Size _thumb = Size(
    FujinSize.switchThumbWidth,
    FujinSize.switchThumbHeight,
  );
  static const Size _lens = Size(
    FujinSize.switchLensWidth,
    FujinSize.switchLensHeight,
  );

  @override
  Widget build(BuildContext context) {
    final held = useState(false);
    final dragged = useState<double?>(null);
    final colors = context.colors;
    final target = switch (value) {
      true => _on,
      false => _off,
    };

    void toggle({required bool to}) {
      if (to == value) return;
      unawaited(HapticFeedback.lightImpact());
      onChanged(to);
    }

    void release() {
      held.value = false;
      dragged.value = null;
    }

    return Semantics(
      toggled: value,
      onTap: () => toggle(to: !value),
      child: Listener(
        onPointerDown: (_) => held.value = true,
        onPointerUp: (_) => held.value = false,
        onPointerCancel: (_) => release(),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => toggle(to: !value),
          onHorizontalDragStart: (_) => dragged.value = target,
          onHorizontalDragUpdate: (details) => dragged.value =
              ((dragged.value ?? target) + details.delta.dx / _travel).clamp(
                _off,
                _on,
              ),
          onHorizontalDragEnd: (_) {
            final at = dragged.value ?? target;
            release();
            toggle(to: at >= _half);
          },
          onHorizontalDragCancel: release,
          child: SizedBox(
            width: FujinSize.switchWidth,
            height: FujinSize.switchHeight,
            child: SingleMotionBuilder(
              motion: FujinMotion.of(context, switch (dragged.value) {
                null => FujinMotion.tabSlide,
                _ => FujinMotion.lensFollow,
              }),
              value: dragged.value ?? target,
              builder: (context, position, _) => LensSwell(
                held: held.value,
                position: position,
                target: target,
                builder: (context, swell) {
                  final at = position.clamp(_off, _on);
                  final centre = Offset(
                    _inset + at * _travel + FujinSize.switchThumbWidth / 2,
                    FujinSize.switchHeight / 2,
                  );
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: ShapeDecoration(
                            shape: const StadiumBorder(),
                            color: Color.lerp(
                              colors.backgroundNeutral,
                              colors.backgroundAccent,
                              at,
                            ),
                          ),
                        ),
                      ),
                      Positioned.fromRect(
                        rect: Rect.fromCenter(
                          center: centre,
                          width: _thumb.width,
                          height: _thumb.height,
                        ),
                        child: Opacity(
                          opacity: LensSwell.underneath(swell),
                          child: DecoratedBox(
                            decoration: ShapeDecoration(
                              shape: const StadiumBorder(),
                              color: colors.backgroundCard,
                            ),
                          ),
                        ),
                      ),
                      if (LensSwell.showing(swell))
                        switch (Size.lerp(_thumb, _lens, swell)) {
                          final size? => SwitchLens(
                            rect: Rect.fromCenter(
                              center: centre,
                              width: size.width,
                              height: size.height,
                            ),
                            visibility: swell,
                          ),
                          null => const SizedBox.shrink(),
                        },
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
