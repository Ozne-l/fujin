import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/compact_text_scaling.dart';
import 'package:fujin/pages/common/glass_lens.dart';
import 'package:fujin/pages/common/glass_surface.dart';
import 'package:fujin/pages/common/lens_swell.dart';
import 'package:fujin/pages/common/slot_row.dart';
import 'package:fujin/pages/tabs/fujin_tab.dart';
import 'package:motor/motor.dart';

class TabPlate extends HookWidget {
  const TabPlate({required this.selected, required this.onSelect, super.key});

  final FujinTab selected;
  final ValueChanged<FujinTab> onSelect;

  static const double _lensOutset = FujinSize.tabPlateInset * 2;

  @override
  Widget build(BuildContext context) {
    final held = useState<double?>(null);
    final landing = useState<FujinTab?>(null);
    useEffect(() {
      landing.value = null;
      return null;
    }, [selected]);
    final target = landing.value ?? selected;
    return LayoutBuilder(
      builder: (context, constraints) {
        final slots = SlotRow(
          width: constraints.maxWidth,
          count: FujinTab.values.length,
          inset: FujinSize.tabPlateInset,
          gap: FujinSize.tabGap,
        );
        void land(FujinTab tab) {
          held.value = null;
          if (tab != selected) landing.value = tab;
          onSelect(tab);
        }

        final tabs = Row(
          spacing: FujinSize.tabGap,
          children: [
            for (final tab in FujinTab.values)
              Expanded(
                child: _TabButton(
                  tab: tab,
                  label: tab.label(context.intl),
                  active: tab == target,
                  onTap: () => land(tab),
                ),
              ),
          ],
        );

        return GestureDetector(
          onHorizontalDragDown: (details) =>
              held.value = slots.at(details.localPosition.dx),
          onHorizontalDragUpdate: (details) =>
              held.value = slots.at(details.localPosition.dx),
          onHorizontalDragCancel: () => held.value = null,
          onHorizontalDragEnd: (details) => land(
            FujinTab.values[slots.landing(
              held.value ?? target.index.toDouble(),
              details.velocity.pixelsPerSecond.dx,
            )],
          ),
          child: VelocityMotionBuilder<double>(
            converter: const SingleMotionConverter(),
            motion: FujinMotion.of(context, switch (held.value) {
              null => FujinMotion.tabSlide,
              _ => FujinMotion.lensFollow,
            }),
            value: held.value ?? target.index.toDouble(),
            builder: (context, position, velocity, _) {
              final squash =
                  1 +
                  (velocity.abs() * FujinMotion.tabSquash)
                      .clamp(
                        0,
                        FujinMotion.tabSquashLimit,
                      )
                      .toDouble();
              return LensSwell(
                held: held.value != null,
                position: position,
                target: target.index.toDouble(),
                builder: (context, swell) => GlassSurface(
                  overlay: switch (LensSwell.showing(swell)) {
                    true => GlassLens(
                      rect: slots
                          .rect(
                            position,
                            top: FujinSize.tabPlateInset,
                            height: FujinSize.tab,
                          )
                          .inflate(_lensOutset * swell),
                      visibility: swell,
                      squash: squash,
                    ),
                    false => null,
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(FujinSize.tabPlateInset),
                    child: CompactTextScaling(
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: _Pill(
                              left: slots.offset(position),
                              width: slots.slot,
                              squash: squash,
                              opacity: LensSwell.underneath(swell),
                            ),
                          ),
                          tabs,
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.left,
    required this.width,
    required this.squash,
    required this.opacity,
  });

  final double left;
  final double width;
  final double squash;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Transform.translate(
          offset: Offset(left, 0),
          child: Transform.scale(
            scaleX: squash,
            child: Opacity(
              opacity: opacity,
              child: SizedBox(
                width: width,
                height: FujinSize.tab,
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    shape: const StadiumBorder(),
                    color: context.colors.backgroundTabActive,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.tab,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final FujinTab tab;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = switch (active) {
      true => context.colors.textLink,
      false => context.colors.textPrimary,
    };
    return Semantics(
      button: true,
      selected: active,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          height: FujinSize.tab,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: FujinSize.textGap,
            children: [
              SvgPicture.asset(
                tab.icon,
                width: FujinSize.icon,
                height: FujinSize.icon,
                theme: SvgTheme(currentColor: foreground),
                excludeFromSemantics: true,
              ),
              Text(
                label,
                maxLines: 1,
                style: FujinText.inter11Medium.copyWith(color: foreground),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
