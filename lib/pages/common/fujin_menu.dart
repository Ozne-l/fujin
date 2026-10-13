import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_theme.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/check_icon.dart';
import 'package:motor/motor.dart';

class FujinMenu<T> extends HookWidget {
  const FujinMenu({
    required this.items,
    required this.selected,
    required this.labelOf,
    required this.onSelected,
    required this.itemPadding,
    required this.builder,
    this.itemStyle = FujinText.inter14Medium,
    super.key,
  });

  static const _visibleItems = 6;
  static const _foldedScale = 0.96;
  static const double _gap = FujinSpace.s1;

  final List<T> items;
  final T selected;
  final String Function(T item) labelOf;
  final ValueChanged<T> onSelected;
  final EdgeInsetsGeometry itemPadding;
  final TextStyle itemStyle;
  final Widget Function(
    BuildContext context, {
    required bool expanded,
    required VoidCallback toggle,
  })
  builder;

  @override
  Widget build(BuildContext context) {
    final controller = useMemoized(MenuController.new);
    final expanded = useState(false);
    final pendingHide = useRef<VoidCallback?>(null);

    void toggle() {
      switch ((controller.isOpen, expanded.value)) {
        case (true, true):
          controller.close();
        case (true, false):
          pendingHide.value = null;
          expanded.value = true;
        case (false, _):
          if (items.isNotEmpty) controller.open();
      }
    }

    void choose(T item) {
      controller.close();
      onSelected(item);
    }

    void settle(AnimationStatus status) {
      if (!status.isDismissed) return;
      final hide = pendingHide.value;
      pendingHide.value = null;
      hide?.call();
    }

    Future<bool> back() async {
      if (!expanded.value) return false;
      controller.close();
      return true;
    }

    return RawMenuAnchor(
      controller: controller,
      useRootOverlay: true,
      consumeOutsideTaps: true,
      onOpenRequested: (position, showOverlay) {
        pendingHide.value = null;
        expanded.value = true;
        showOverlay();
      },
      onCloseRequested: (hideOverlay) {
        pendingHide.value = hideOverlay;
        expanded.value = false;
      },
      overlayBuilder: (context, info) {
        final insets = MediaQuery.paddingOf(context);
        final anchor = info.anchorRect;
        final overlay = info.overlaySize;
        final contentHeight =
            math.min(items.length, _visibleItems) * FujinSize.touchTarget +
            2 * FujinSpace.s1;
        final below =
            overlay.height -
            insets.bottom -
            FujinSize.screenMargin -
            anchor.bottom -
            _gap;
        final above = anchor.top - insets.top - FujinSize.screenMargin - _gap;
        final opensDown = below >= contentHeight || below >= above;
        final height = math.max<double>(
          0,
          math.min(contentHeight, opensDown ? below : above),
        );
        final width = math.max(anchor.width, FujinSize.menuWidth);
        final start = switch (Directionality.of(context)) {
          TextDirection.ltr => anchor.left,
          TextDirection.rtl => anchor.right - width,
        };
        final left = math.max(
          FujinSize.screenMargin,
          math.min(start, overlay.width - FujinSize.screenMargin - width),
        );
        return BackButtonListener(
          onBackButtonPressed: back,
          child: Stack(
            children: [
              Positioned(
                left: left,
                top: switch (opensDown) {
                  true => anchor.bottom + _gap,
                  false => anchor.top - _gap - height,
                },
                width: width,
                height: height,
                child: TapRegion(
                  groupId: info.tapRegionGroupId,
                  onTapOutside: (event) => controller.close(),
                  child: SingleMotionBuilder(
                    motion: FujinMotion.mealFold,
                    from: 0,
                    value: switch (expanded.value) {
                      true => 1,
                      false => 0,
                    },
                    onAnimationStatusChanged: settle,
                    builder: (context, fold, child) => Opacity(
                      opacity: fold.clamp(0, 1),
                      child: Transform.scale(
                        scaleY: lerpDouble(_foldedScale, 1, fold),
                        alignment: switch (opensDown) {
                          true => Alignment.topCenter,
                          false => Alignment.bottomCenter,
                        },
                        child: child,
                      ),
                    ),
                    child: _Panel(
                      children: [
                        for (final (index, item) in items.indexed)
                          _Item(
                            label: labelOf(item),
                            selected: item == selected,
                            separated: index > 0,
                            padding: itemPadding,
                            style: itemStyle,
                            onTap: () => choose(item),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      builder: (context, _, _) =>
          builder(context, expanded: expanded.value, toggle: toggle),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(FujinRadius.menu);
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: FujinColorRole.backgroundCard,
        borderRadius: radius,
        boxShadow: const [FujinTheme.floatingShadow],
      ),
      foregroundDecoration: BoxDecoration(
        borderRadius: radius,
        border: Border.all(color: FujinColorRole.borderCard),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: FujinSpace.s1),
          itemExtent: FujinSize.touchTarget,
          children: children,
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.label,
    required this.selected,
    required this.separated,
    required this.padding,
    required this.style,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool separated;
  final EdgeInsetsGeometry padding;
  final TextStyle style;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = switch (selected) {
      true => FujinColorRole.textLink,
      false => FujinColorRole.textPrimary,
    };
    return Semantics(
      button: true,
      selected: selected,
      inMutuallyExclusiveGroup: true,
      child: InkWell(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: switch (separated) {
              true => const Border(
                top: BorderSide(color: FujinColorRole.borderHairline),
              ),
              false => null,
            },
          ),
          child: Padding(
            padding: padding,
            child: Row(
              spacing: FujinSpace.s2,
              children: [
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: style.copyWith(color: color),
                  ),
                ),
                if (selected)
                  SvgPicture.asset(
                    CheckIcon.asset,
                    width: FujinSize.menuChevron,
                    height: FujinSize.menuChevron,
                    theme: const SvgTheme(
                      currentColor: FujinColorRole.textLink,
                    ),
                    excludeFromSemantics: true,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
