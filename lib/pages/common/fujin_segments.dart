import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/glass_fill.dart';
import 'package:fujin/pages/common/glass_finish.dart';
import 'package:fujin/pages/common/glass_lens.dart';
import 'package:fujin/pages/common/lens_swell.dart';
import 'package:fujin/pages/common/slot_row.dart';
import 'package:motor/motor.dart';

class FujinSegments extends HookWidget {
  const FujinSegments({
    required this.position,
    required this.motion,
    required this.labels,
    required this.onSelect,
    super.key,
  });

  final double position;
  final Motion motion;
  final List<String> labels;
  final void Function(int index, BuildContext segment) onSelect;

  static const double outset =
      (FujinSize.touchTarget - FujinSize.controlHeight) / 2;
  static const double _trackRadius = FujinSize.controlHeight / 2;
  static const double _pillTop = outset + FujinSpace.s1;
  static const double _pillHeight = FujinSize.controlHeight - FujinSpace.s1 * 2;
  static const double _lensOutset = FujinSpace.s1 * 2;

  @override
  Widget build(BuildContext context) {
    final held = useState<double?>(null);
    final landing = useState<int?>(null);
    final shown = useRef(position);
    final keys = useMemoized(
      () => [for (final _ in labels) GlobalKey()],
      [labels.length],
    );
    final colors = context.colors;
    final last = labels.length - 1;

    void settle(int index) {
      held.value = null;
      landing.value = switch (shown.value == index) {
        true => null,
        false => index,
      };
    }

    void select(int index) {
      settle(index);
      if (position == index) return;
      unawaited(HapticFeedback.selectionClick());
      if (keys[index].currentContext case final segment?) {
        onSelect(index, segment);
      }
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final slots = SlotRow(
          width: constraints.maxWidth,
          count: labels.length,
          inset: FujinSpace.s1,
        );
        return GestureDetector(
          onHorizontalDragDown: (details) =>
              held.value = slots.at(details.localPosition.dx),
          onHorizontalDragUpdate: (details) =>
              held.value = slots.at(details.localPosition.dx),
          onHorizontalDragCancel: () => settle(position.round()),
          onHorizontalDragEnd: (details) => select(
            slots.landing(
              held.value ?? position,
              details.velocity.pixelsPerSecond.dx,
            ),
          ),
          child: SingleMotionBuilder(
            motion: FujinMotion.of(context, switch ((
              held.value,
              landing.value,
            )) {
              (_?, _) => FujinMotion.lensFollow,
              (null, _?) => FujinMotion.tabSlide,
              (null, null) => motion,
            }),
            value: held.value ?? landing.value?.toDouble() ?? position,
            onAnimationStatusChanged: (status) {
              if (status.isCompleted && held.value == null) {
                landing.value = null;
              }
            },
            builder: (context, moving, _) {
              shown.value = moving;
              final at = moving.clamp(0, last).toDouble();
              return LensSwell(
                held: held.value != null,
                position: moving,
                target: landing.value?.toDouble(),
                builder: (context, swell) {
                  final pill = slots.rect(
                    at,
                    top: _pillTop,
                    height: _pillHeight,
                  );
                  return SizedBox(
                    height: FujinSize.touchTarget,
                    child: Stack(
                      fit: StackFit.expand,
                      clipBehavior: Clip.none,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: outset,
                          ),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: colors.backgroundNeutral,
                              borderRadius: BorderRadius.circular(
                                _trackRadius,
                              ),
                            ),
                          ),
                        ),
                        Positioned.fromRect(
                          rect: pill,
                          child: Opacity(
                            opacity: LensSwell.underneath(swell),
                            child: const GlassFill(
                              finish: GlassFinish.clear,
                              child: SizedBox.expand(),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: FujinSpace.s1,
                          ),
                          child: Row(
                            children: [
                              for (final (index, label) in labels.indexed)
                                Expanded(
                                  child: _Segment(
                                    key: keys[index],
                                    label: label,
                                    active: (1 - (at - index).abs()).clamp(
                                      0,
                                      1,
                                    ),
                                    onSelect: () => select(index),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (LensSwell.showing(swell))
                          GlassLens(
                            rect: pill.inflate(_lensOutset * swell),
                            visibility: swell,
                          ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.active,
    required this.onSelect,
    super.key,
  });

  final String label;
  final double active;
  final VoidCallback onSelect;

  static const double _selectedFrom = 0.5;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      button: true,
      selected: active >= _selectedFrom,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onSelect,
        child: Center(
          child: Text(
            label,
            style: FujinText.inter14Medium.copyWith(
              color: Color.alphaBlend(
                colors.textPrimary.withValues(alpha: active),
                colors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
