import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' show ImageFilter, lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_haptics.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_theme.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/chat/message_action.dart';
import 'package:fujin/pages/chat/widgets/message_row.dart';
import 'package:fujin/pages/chat/widgets/reaction_flight.dart';
import 'package:fujin/pages/chat_media/chat_media_icon.dart';
import 'package:fujin/pages/chat_media/widgets/media_glyph.dart';
import 'package:fujin/pages/common/trash_icon.dart';
import 'package:motor/motor.dart';

Future<MessageAction?> showMessageActions(
  BuildContext context, {
  required Rect bubble,
  required Widget content,
  required bool mine,
  required bool canReply,
}) async {
  final overlay = Overlay.of(context, rootOverlay: true);
  final reduced = FujinMotion.reduced(context);
  final previous = FocusManager.instance.primaryFocus;
  final closing = ValueNotifier(false);
  final chosen = Completer<MessageAction?>();
  var landing = Future<void>.value();
  late final OverlayEntry entry;
  late final LocalHistoryEntry history;

  void close(MessageAction? action) {
    if (closing.value) return;
    closing.value = true;
    history.remove();
    previous?.requestFocus();
    void finish() {
      entry
        ..remove()
        ..dispose();
      closing.dispose();
      chosen.complete(action);
    }

    switch (reduced) {
      case true:
        finish();
      case false:
        Timer(FujinMotion.liftSettle, finish);
    }
  }

  history = LocalHistoryEntry(onRemove: () => close(null));
  entry = OverlayEntry(
    builder: (context) => FocusScope(
      autofocus: true,
      child: BlockSemantics(
        child: MessageActions(
          bubble: bubble,
          content: content,
          mine: mine,
          canReply: canReply,
          closing: closing,
          onChoose: close,
          onReact: (emoji, cell) {
            landing = ReactionFlight.launch(
              context,
              emoji: emoji,
              from: cell,
              to: MessageRow.reactionLanding(bubble, mine: mine),
            );
            close(ReactAction(emoji));
          },
        ),
      ),
    ),
  );
  ModalRoute.of(context)?.addLocalHistoryEntry(history);
  overlay.insert(entry);
  final action = await chosen.future;
  await landing;
  return action;
}

class MessageActions extends HookWidget {
  const MessageActions({
    required this.bubble,
    required this.content,
    required this.mine,
    required this.canReply,
    required this.closing,
    required this.onChoose,
    required this.onReact,
    super.key,
  });

  final Rect bubble;
  final Widget content;
  final bool mine;
  final bool canReply;
  final ValueListenable<bool> closing;
  final ValueChanged<MessageAction?> onChoose;
  final void Function(String emoji, Rect cell) onReact;

  static const String heart = '❤️';
  static const List<String> _quickReactions = [
    heart,
    '😆',
    '😮',
    '😢',
    '😡',
    '👍',
  ];
  static const double _foldedScale = 0.96;
  static const double _menuFolded = 0.8;
  static const Size _cell = Size(
    FujinSize.reactionCellWidth,
    FujinSize.reactionCellHeight,
  );
  static const EdgeInsets _barPadding = EdgeInsets.symmetric(
    horizontal: FujinSize.reactionBarPaddingHorizontal,
    vertical: FujinSize.reactionBarPaddingVertical,
  );

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final intl = context.intl;
    final screen = MediaQuery.sizeOf(context);
    final padding = MediaQuery.paddingOf(context);
    final reduced = FujinMotion.reduced(context);
    final closed = useValueListenable(closing);
    final revealed = useState(switch (reduced) {
      true => _quickReactions.length + 1,
      false => 0,
    });
    final hovered = useState<int?>(null);
    final cells = useMemoized(
      () => [for (final _ in _quickReactions) GlobalKey()],
    );
    final fresh = useMemoized(() => <int>{});

    useEffect(() {
      if (revealed.value > _quickReactions.length) return null;
      final timer = Timer(
        FujinMotion.reactionStagger,
        () => revealed.value++,
      );
      return timer.cancel;
    }, [revealed.value]);

    Rect? cellRect(int index) =>
        switch (cells[index].currentContext?.findRenderObject()) {
          final RenderBox box when box.hasSize =>
            box.localToGlobal(Offset.zero) & box.size,
          _ => null,
        };

    int? under(Offset position) {
      for (var index = 0; index < _quickReactions.length; index++) {
        if (cellRect(index)?.contains(position) ?? false) return index;
      }
      return null;
    }

    void choose(int index) =>
        onReact(_quickReactions[index], cellRect(index) ?? bubble);

    useEffect(() {
      void route(PointerEvent event) {
        if (closed) return;
        switch (event) {
          case PointerDownEvent(:final pointer):
            fresh.add(pointer);
          case PointerMoveEvent(:final pointer, :final position)
              when !fresh.contains(pointer):
            final next = under(position);
            if (next != null && next != hovered.value) FujinHaptics.select();
            hovered.value = next;
          case PointerUpEvent(:final pointer, :final position)
              when !fresh.contains(pointer):
            hovered.value = null;
            if (under(position) case final index?) choose(index);
          case PointerCancelEvent(:final pointer) when !fresh.contains(pointer):
            hovered.value = null;
          case _:
            break;
        }
      }

      final router = GestureBinding.instance.pointerRouter
        ..addGlobalRoute(route);
      return () => router.removeGlobalRoute(route);
    });

    final shown = switch (closed) {
      true => 0.0,
      false => 1.0,
    };
    final actions = [
      if (canReply)
        (
          ChatMediaIcon.reply,
          intl.chatReply,
          colors.textPrimary,
          const ReplyAction(),
        ),
      if (mine)
        (
          TrashIcon.asset,
          intl.chatDelete,
          colors.textAlert,
          const DeleteAction(),
        ),
    ];
    final menuHeight = switch (actions.length) {
      0 => 0.0,
      final count =>
        count * FujinSize.touchTarget +
            (count - 1) * FujinStroke.card +
            2 * FujinStroke.card,
    };
    final top = padding.top + FujinSize.screenMargin;
    final bottom = screen.height - padding.bottom - FujinSize.screenMargin;
    final groupTop = bubble.top - FujinSpace.s2 - FujinSize.reactionBarHeight;
    final groupBottom = bubble.bottom + FujinSpace.s2 + menuHeight;
    final lowered = math.min(0, bottom - groupBottom);
    final shift = math.max(lowered, top - groupTop).toDouble();
    final lifted = bubble.shift(Offset(0, shift));
    final menuTop = math.min(
      lifted.bottom + FujinSpace.s2,
      bottom - menuHeight,
    );
    final (start, end) = switch (mine) {
      true => (null, FujinSize.screenMargin),
      false => (FujinSize.screenMargin, null),
    };

    Widget folded(
      double fold,
      double from,
      Alignment alignment,
      Widget child,
    ) => Opacity(
      opacity: fold.clamp(0, 1),
      child: Transform.scale(
        scale: lerpDouble(from, 1, fold),
        alignment: alignment,
        child: child,
      ),
    );

    final panel = BoxDecoration(
      color: colors.backgroundCard,
      border: Border.all(color: colors.borderCard),
      boxShadow: [FujinTheme.floatingShadow(colors)],
    );

    Widget reveal(int index, Widget child) => SingleMotionBuilder(
      motion: FujinMotion.of(context, FujinMotion.pop),
      value: switch (index < revealed.value && !closed) {
        true => 1,
        false => 0,
      },
      builder: (context, popped, child) => Opacity(
        opacity: popped.clamp(0, 1),
        child: Transform.scale(scale: math.max(0, popped), child: child),
      ),
      child: child,
    );

    final bar = DecoratedBox(
      decoration: panel.copyWith(
        borderRadius: BorderRadius.circular(FujinRadius.pill),
      ),
      child: Padding(
        padding: _barPadding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final (index, emoji) in _quickReactions.indexed)
              _Cell(
                key: cells[index],
                label: emoji,
                onTap: () => choose(index),
                child: reveal(
                  index,
                  SingleMotionBuilder(
                    motion: FujinMotion.of(context, FujinMotion.lift),
                    value: switch (hovered.value == index) {
                      true => FujinMotion.reactionHover,
                      false => 1,
                    },
                    builder: (context, swell, child) =>
                        Transform.scale(scale: swell, child: child),
                    child: Text(
                      emoji,
                      style: FujinText.hina24.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            _Cell(
              label: intl.chatMoreEmoji,
              onTap: () => onChoose(const MoreEmojiAction()),
              child: reveal(
                _quickReactions.length,
                MediaGlyph(
                  ChatMediaIcon.add,
                  size: FujinSize.reactionMoreIcon,
                  color: colors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    final menu = Container(
      clipBehavior: Clip.antiAlias,
      decoration: panel.copyWith(
        borderRadius: BorderRadius.circular(FujinRadius.menu),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final (index, (icon, label, colour, action))
              in actions.indexed) ...[
            if (index > 0)
              Divider(
                height: FujinStroke.card,
                thickness: FujinStroke.card,
                color: colors.borderDivider,
              ),
            Semantics(
              button: true,
              child: InkWell(
                onTap: () => onChoose(action),
                child: SizedBox(
                  height: FujinSize.touchTarget,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: FujinSpace.s4,
                    ),
                    child: Row(
                      spacing: FujinSpace.s3,
                      children: [
                        MediaGlyph(
                          icon,
                          size: FujinSize.contextMenuIcon,
                          color: colour,
                        ),
                        Expanded(
                          child: Text(
                            label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: FujinText.inter15Medium.copyWith(
                              color: colour,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );

    return Material(
      type: MaterialType.transparency,
      child: SingleMotionBuilder(
        motion: FujinMotion.of(context, FujinMotion.lift),
        from: 0,
        value: shown,
        builder: (context, lift, _) {
          final faded = lift.clamp(0.0, 1.0);
          return Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onChoose(null),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: FujinSize.liftBackdropBlur * faded,
                      sigmaY: FujinSize.liftBackdropBlur * faded,
                    ),
                    child: ColoredBox(
                      color: colors.backgroundScrim.withValues(
                        alpha: colors.backgroundScrim.a * faded,
                      ),
                    ),
                  ),
                ),
              ),
              PositionedDirectional(
                start: start,
                end: end,
                top: lifted.top - FujinSpace.s2 - FujinSize.reactionBarHeight,
                height: FujinSize.reactionBarHeight,
                child: folded(
                  lift,
                  _foldedScale,
                  switch (mine) {
                    true => Alignment.bottomRight,
                    false => Alignment.bottomLeft,
                  },
                  bar,
                ),
              ),
              Positioned.fromRect(
                rect: Rect.lerp(bubble, lifted, lift) ?? lifted,
                child: IgnorePointer(
                  child: Transform.scale(
                    scale: lerpDouble(1, FujinMotion.liftScale, lift),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(FujinRadius.field),
                        boxShadow: [
                          ?BoxShadow.lerp(
                            null,
                            FujinTheme.floatingShadow(colors),
                            faded,
                          ),
                        ],
                      ),
                      child: OverflowBox(
                        alignment: Alignment.topLeft,
                        maxHeight: double.infinity,
                        child: content,
                      ),
                    ),
                  ),
                ),
              ),
              if (actions.isNotEmpty)
                PositionedDirectional(
                  start: start,
                  end: end,
                  top: menuTop,
                  width: FujinSize.contextMenuWidth,
                  child: folded(
                    lift,
                    _menuFolded,
                    switch (mine) {
                      true => Alignment.topRight,
                      false => Alignment.topLeft,
                    },
                    menu,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({
    required this.label,
    required this.onTap,
    required this.child,
    super.key,
  });

  final String label;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: label,
    excludeSemantics: true,
    onTap: onTap,
    child: InkResponse(
      onTap: onTap,
      radius: MessageActions._cell.width / 2,
      child: SizedBox.fromSize(
        size: MessageActions._cell,
        child: Center(child: child),
      ),
    ),
  );
}
