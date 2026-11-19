import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_theme.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/chat/message_action.dart';
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
}) => Navigator.of(context, rootNavigator: true).push(
  PageRouteBuilder<MessageAction>(
    opaque: false,
    transitionDuration: Duration.zero,
    reverseTransitionDuration: Duration.zero,
    pageBuilder: (context, _, _) => MessageActions(
      bubble: bubble,
      content: content,
      mine: mine,
      canReply: canReply,
    ),
  ),
);

class MessageActions extends StatelessWidget {
  const MessageActions({
    required this.bubble,
    required this.content,
    required this.mine,
    required this.canReply,
    super.key,
  });

  final Rect bubble;
  final Widget content;
  final bool mine;
  final bool canReply;

  static const List<String> quickReactions = [
    '❤️',
    '😆',
    '😮',
    '😢',
    '😡',
    '👍',
  ];
  static const double _barHeight = 58;
  static const double _menuWidth = 220;
  static const double _divider = 1;
  static const double _border = 1;
  static const double _actionIcon = 20;
  static const double _moreIcon = 30;
  static const double _foldedScale = 0.96;
  static const Size _cell = Size(40, 44);
  static const EdgeInsets _barPadding = EdgeInsets.symmetric(
    horizontal: 10,
    vertical: 6,
  );

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final intl = context.intl;
    final navigator = Navigator.of(context);
    final screen = MediaQuery.sizeOf(context);
    final padding = MediaQuery.paddingOf(context);
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
        count * FujinSize.touchTarget + (count - 1) * _divider + 2 * _border,
    };
    final top = padding.top + FujinSize.screenMargin;
    final bottom = screen.height - padding.bottom - FujinSize.screenMargin;
    final groupTop = bubble.top - FujinSpace.s2 - _barHeight;
    final groupBottom = bubble.bottom + FujinSpace.s2 + menuHeight;
    final lowered = math.min(0, bottom - groupBottom);
    final shift = math.max(lowered, top - groupTop).toDouble();
    final lifted = bubble.shift(Offset(0, shift));
    final (start, end) = switch (mine) {
      true => (null, FujinSize.screenMargin),
      false => (FujinSize.screenMargin, null),
    };

    Widget folded(double fold, Alignment alignment, Widget child) => Opacity(
      opacity: fold.clamp(0, 1),
      child: Transform.scale(
        scale: lerpDouble(_foldedScale, 1, fold),
        alignment: alignment,
        child: child,
      ),
    );

    final panel = BoxDecoration(
      color: colors.backgroundCard,
      border: Border.all(color: colors.borderCard),
      boxShadow: [FujinTheme.floatingShadow(colors)],
    );

    return Material(
      type: MaterialType.transparency,
      child: SingleMotionBuilder(
        motion: FujinMotion.of(context, FujinMotion.mealFold),
        from: 0,
        value: 1,
        builder: (context, fold, _) => Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: navigator.pop,
                child: ColoredBox(
                  color: colors.backgroundScrim.withValues(
                    alpha: colors.backgroundScrim.a * fold.clamp(0, 1),
                  ),
                ),
              ),
            ),
            PositionedDirectional(
              start: start,
              end: end,
              top: lifted.top - FujinSpace.s2 - _barHeight,
              height: _barHeight,
              child: folded(
                fold,
                switch (mine) {
                  true => Alignment.bottomRight,
                  false => Alignment.bottomLeft,
                },
                DecoratedBox(
                  decoration: panel.copyWith(
                    borderRadius: BorderRadius.circular(FujinRadius.pill),
                  ),
                  child: Padding(
                    padding: _barPadding,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (final emoji in quickReactions)
                          _Cell(
                            label: emoji,
                            onTap: () => navigator.pop(ReactAction(emoji)),
                            child: Text(
                              emoji,
                              style: FujinText.hina24.copyWith(
                                color: colors.textPrimary,
                              ),
                            ),
                          ),
                        _Cell(
                          label: intl.chatMoreEmoji,
                          onTap: () => navigator.pop(const MoreEmojiAction()),
                          child: MediaGlyph(
                            ChatMediaIcon.add,
                            size: _moreIcon,
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fromRect(
              rect: lifted,
              child: IgnorePointer(
                child: OverflowBox(
                  alignment: Alignment.topLeft,
                  maxHeight: double.infinity,
                  child: content,
                ),
              ),
            ),
            if (actions.isNotEmpty)
              PositionedDirectional(
                start: start,
                end: end,
                top: lifted.bottom + FujinSpace.s2,
                width: _menuWidth,
                child: folded(
                  fold,
                  switch (mine) {
                    true => Alignment.topRight,
                    false => Alignment.topLeft,
                  },
                  Container(
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
                              height: _divider,
                              thickness: _divider,
                              color: colors.borderDivider,
                            ),
                          Semantics(
                            button: true,
                            child: InkWell(
                              onTap: () => navigator.pop(action),
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
                                        size: _actionIcon,
                                        color: colour,
                                      ),
                                      Expanded(
                                        child: Text(
                                          label,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: FujinText.inter15Medium
                                              .copyWith(color: colour),
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
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({required this.label, required this.onTap, required this.child});

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
