import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/compact_text_scaling.dart';
import 'package:fujin/pages/common/glass_layer.dart';
import 'package:fujin/pages/common/glass_surface.dart';
import 'package:fujin/pages/common/scan_button.dart';
import 'package:fujin/pages/tabs/fujin_tab.dart';
import 'package:motor/motor.dart';

class FloatingTabBar extends StatelessWidget {
  const FloatingTabBar({
    required this.selected,
    required this.onSelect,
    required this.onScan,
    super.key,
  });

  final FujinTab selected;
  final ValueChanged<FujinTab> onSelect;
  final VoidCallback? onScan;

  static const double _fadeTop =
      FujinSize.scrollFade - FujinSize.tabBar - FujinSpace.s6;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    FujinColorRole.backgroundScrollFade.withValues(alpha: 0),
                    FujinColorRole.backgroundScrollFade,
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            FujinSpace.s5,
            _fadeTop,
            FujinSpace.s5,
            0,
          ),
          child: SafeArea(
            top: false,
            minimum: const EdgeInsets.only(bottom: FujinSpace.s6),
            child: GlassLayer(
              child: Row(
                spacing: FujinSpace.s2,
                children: [
                  Expanded(
                    child: GlassSurface(
                      child: Padding(
                        padding: const EdgeInsets.all(FujinSize.tabPlateInset),
                        child: CompactTextScaling(
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: _ActiveTab(index: selected.index),
                              ),
                              Row(
                                spacing: FujinSize.tabGap,
                                children: [
                                  for (final tab in FujinTab.values)
                                    Expanded(
                                      child: _TabButton(
                                        tab: tab,
                                        label: tab.label(context.intl),
                                        active: tab == selected,
                                        onTap: () => onSelect(tab),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  ScanButton(onTap: onScan),
                ],
              ),
            ),
          ),
        ),
      ],
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
    final foreground = active ? FujinColor.fujin : FujinColorRole.textPrimary;
    return Semantics(
      button: true,
      selected: active,
      child: Material(
        type: MaterialType.transparency,
        child: SizedBox(
          height: FujinSize.tab,
          child: InkWell(
            customBorder: const StadiumBorder(),
            onTap: onTap,
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
      ),
    );
  }
}

class _ActiveTab extends StatelessWidget {
  const _ActiveTab({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: LayoutBuilder(
      builder: (context, constraints) {
        final count = FujinTab.values.length;
        final width =
            (constraints.maxWidth - FujinSize.tabGap * (count - 1)) / count;
        return VelocityMotionBuilder<double>(
          converter: const SingleMotionConverter(),
          motion: FujinMotion.of(context, FujinMotion.tabSlide),
          value: index.toDouble(),
          builder: (context, position, velocity, child) => Align(
            alignment: Alignment.centerLeft,
            child: Transform.translate(
              offset: Offset(position * (width + FujinSize.tabGap), 0),
              child: Transform.scale(
                scaleX:
                    1 +
                    (velocity.abs() * FujinMotion.tabSquash).clamp(
                      0,
                      FujinMotion.tabSquashLimit,
                    ),
                child: child,
              ),
            ),
          ),
          child: SizedBox(
            width: width,
            height: FujinSize.tab,
            child: const DecoratedBox(
              decoration: ShapeDecoration(
                shape: StadiumBorder(),
                color: FujinColorRole.backgroundTabActive,
              ),
            ),
          ),
        );
      },
    ),
  );
}
