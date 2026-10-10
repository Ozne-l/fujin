import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/tabs/fujin_tab.dart';

class FloatingTabBar extends StatelessWidget {
  const FloatingTabBar({
    required this.selected,
    required this.onSelect,
    super.key,
  });

  final FujinTab selected;
  final ValueChanged<FujinTab> onSelect;

  static const _scanIcon = 'assets/icons/scan.svg';
  static const double _fadeTop =
      FujinSize.scrollFade - FujinSize.tabBar - FujinSpace.s6;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
            child: Row(
              spacing: FujinSpace.s2,
              children: [
                Expanded(
                  child: _Glass(
                    child: Padding(
                      padding: const EdgeInsets.all(FujinSize.tabPlateInset),
                      child: Row(
                        spacing: FujinSize.tabGap,
                        children: [
                          for (final tab in FujinTab.values)
                            Expanded(
                              child: _TabButton(
                                tab: tab,
                                label: tab.label(l10n),
                                active: tab == selected,
                                onTap: () => onSelect(tab),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                Semantics(
                  button: true,
                  enabled: false,
                  label: l10n.tabScanner,
                  child: _Glass(
                    child: SizedBox.square(
                      dimension: FujinSize.tabBar,
                      child: Center(
                        child: SvgPicture.asset(
                          _scanIcon,
                          width: FujinSize.scanIcon,
                          height: FujinSize.scanIcon,
                          theme: const SvgTheme(
                            currentColor: FujinColorRole.textDisabled,
                          ),
                          excludeFromSemantics: true,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Glass extends StatelessWidget {
  const _Glass({required this.child});

  final Widget child;

  static const _radius = BorderRadius.all(
    Radius.circular(FujinSize.tabBar / 2),
  );

  @override
  Widget build(BuildContext context) => CustomPaint(
    painter: const _OuterShadowPainter(_radius),
    child: ClipRRect(
      borderRadius: _radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: FujinSize.glassBlur,
          sigmaY: FujinSize.glassBlur,
        ),
        child: ColoredBox(
          color: FujinColorRole.backgroundGlass,
          child: SizedBox(height: FujinSize.tabBar, child: child),
        ),
      ),
    ),
  );
}

class _OuterShadowPainter extends CustomPainter {
  const _OuterShadowPainter(this.radius);

  final BorderRadius radius;

  static const _shadow = BoxShadow(
    color: FujinColorRole.shadowFloating,
    blurRadius: FujinSize.floatingShadowBlur,
    offset: Offset(0, FujinSize.floatingShadowOffset),
  );

  @override
  void paint(Canvas canvas, Size size) {
    final shape = radius.toRRect(Offset.zero & size);
    final reach = _shadow.blurRadius + _shadow.offset.distance;
    canvas
      ..save()
      ..clipPath(
        Path.combine(
          PathOperation.difference,
          Path()..addRect(shape.outerRect.inflate(reach)),
          Path()..addRRect(shape),
        ),
      )
      ..drawRRect(shape.shift(_shadow.offset), _shadow.toPaint())
      ..restore();
  }

  @override
  bool shouldRepaint(_OuterShadowPainter oldDelegate) =>
      radius != oldDelegate.radius;
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
        child: Ink(
          height: FujinSize.tab,
          decoration: ShapeDecoration(
            shape: const StadiumBorder(),
            color: active ? FujinColorRole.backgroundTabActive : null,
          ),
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
