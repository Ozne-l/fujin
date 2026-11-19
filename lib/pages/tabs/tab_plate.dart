import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/chat/chat_text.dart';
import 'package:fujin/pages/common/compact_text_scaling.dart';
import 'package:fujin/pages/common/glass_lens.dart';
import 'package:fujin/pages/common/glass_surface.dart';
import 'package:fujin/pages/common/lens_swell.dart';
import 'package:fujin/pages/common/slot_row.dart';
import 'package:fujin/pages/tabs/fujin_tab.dart';
import 'package:fujin/pages/tabs/messages_item.dart';
import 'package:fujin/pages/tabs/tab_slot.dart';
import 'package:motor/motor.dart';

class TabPlate extends HookWidget {
  const TabPlate({
    required this.selected,
    required this.onSelect,
    this.messages,
    super.key,
  });

  final FujinTab selected;
  final ValueChanged<FujinTab> onSelect;
  final MessagesItem? messages;

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
    final items = TabSlot.of(messages: messages);
    final at = items.indexOf(BranchSlot(target)).toDouble();
    return LayoutBuilder(
      builder: (context, constraints) {
        final slots = SlotRow(
          width: constraints.maxWidth,
          count: items.length,
          inset: FujinSize.tabPlateInset,
          gap: FujinSize.tabGap,
        );
        void land(TabSlot slot) {
          held.value = null;
          switch (slot) {
            case BranchSlot(:final tab):
              if (tab != selected) landing.value = tab;
              onSelect(tab);
            case MessagesSlot(:final item):
              item.onOpen();
          }
        }

        final tabs = Row(
          spacing: FujinSize.tabGap,
          children: [
            for (final slot in items)
              Expanded(
                child: switch (slot) {
                  BranchSlot(:final tab) => _TabButton(
                    icon: tab.icon,
                    label: tab.label(context.intl),
                    active: tab == target,
                    onTap: () => land(slot),
                  ),
                  MessagesSlot(item: MessagesItem(:final unread)) => _TabButton(
                    icon: MessagesItem.icon,
                    label: context.intl.chatTab,
                    semanticsLabel: switch (unread) {
                      <= 0 => null,
                      _ => context.intl.chatTabUnread(unread),
                    },
                    badge: ChatText.badge(context.intl, unread),
                    active: false,
                    onTap: () => land(slot),
                  ),
                },
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
            items[slots.landing(
              held.value ?? at,
              details.velocity.pixelsPerSecond.dx,
            )],
          ),
          child: VelocityMotionBuilder<double>(
            converter: const SingleMotionConverter(),
            motion: FujinMotion.of(context, switch (held.value) {
              null => FujinMotion.tabSlide,
              _ => FujinMotion.lensFollow,
            }),
            value: held.value ?? at,
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
                target: at,
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
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
    this.semanticsLabel,
    this.badge,
  });

  final String icon;
  final String label;
  final String? semanticsLabel;
  final String? badge;
  final bool active;
  final VoidCallback onTap;

  static const double _badgeRise = 5;
  static const EdgeInsets _badgePadding = EdgeInsets.symmetric(
    horizontal: 5,
    vertical: 1,
  );

  @override
  Widget build(BuildContext context) {
    final foreground = switch (active) {
      true => context.colors.textLink,
      false => context.colors.textPrimary,
    };
    final glyph = SvgPicture.asset(
      icon,
      width: FujinSize.icon,
      height: FujinSize.icon,
      theme: SvgTheme(currentColor: foreground),
      excludeFromSemantics: true,
    );
    return Semantics(
      button: true,
      selected: active,
      label: semanticsLabel,
      excludeSemantics: semanticsLabel != null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          height: FujinSize.tab,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: FujinSize.textGap,
            children: [
              switch (badge) {
                null => glyph,
                final badge => Stack(
                  clipBehavior: Clip.none,
                  children: [
                    glyph,
                    Positioned(
                      left: FujinSize.icon / 2,
                      top: -_badgeRise,
                      child: DecoratedBox(
                        decoration: ShapeDecoration(
                          shape: const StadiumBorder(),
                          color: context.colors.backgroundAccent,
                        ),
                        child: Padding(
                          padding: _badgePadding,
                          child: Text(
                            badge,
                            maxLines: 1,
                            style: FujinText.inter11Semibold.copyWith(
                              color: context.colors.textOnAccent,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              },
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
