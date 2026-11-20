import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_theme.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/chat/widgets/failure_shake.dart';
import 'package:fujin/pages/chat_media/chat_media_icon.dart';
import 'package:fujin/pages/chat_media/widgets/media_glyph.dart';
import 'package:fujin/pages/common/clock_icon.dart';
import 'package:motor/motor.dart';

class MessageStatus extends StatelessWidget {
  const MessageStatus.sending({super.key})
    : _kind = _StatusKind.sending,
      onRetry = null;

  const MessageStatus.failed({required VoidCallback this.onRetry, super.key})
    : _kind = _StatusKind.failed;

  const MessageStatus.deleting({super.key})
    : _kind = _StatusKind.deleting,
      onRetry = null;

  final _StatusKind _kind;
  final VoidCallback? onRetry;

  static const EdgeInsets _retryPadding = EdgeInsets.symmetric(
    horizontal: FujinSpace.s1,
    vertical: FujinSpace.s2,
  );

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final intl = context.intl;
    final reduced = FujinMotion.reduced(context);
    Widget turning(StepSequence<double> sequence, Widget child) =>
        switch (reduced) {
          true => child,
          false => SequenceMotionBuilder<int, double>(
            sequence: sequence,
            converter: MotionConverter.single,
            builder: (context, turns, _, child) =>
                Transform.rotate(angle: turns * 2 * pi, child: child),
            child: child,
          ),
        };
    final quiet = FujinText.inter11Regular.copyWith(color: colors.textTertiary);
    final (icon, children) = switch (_kind) {
      _StatusKind.sending => (
        Stack(
          children: [
            MediaGlyph(
              ClockIcon.face,
              size: FujinSize.messageStatusIcon,
              color: colors.textTertiary,
            ),
            turning(
              FujinMotion.clockTurns,
              MediaGlyph(
                ClockIcon.hand,
                size: FujinSize.messageStatusIcon,
                color: colors.textTertiary,
              ),
            ),
          ],
        ),
        [Text(intl.chatSending, style: quiet)],
      ),
      _StatusKind.deleting => (
        turning(
          FujinMotion.spinTurns,
          MediaGlyph(
            ChatMediaIcon.loader,
            size: FujinSize.messageStatusIcon,
            color: colors.textTertiary,
          ),
        ),
        [Text(intl.chatDeleting, style: quiet)],
      ),
      _StatusKind.failed => (
        MediaGlyph(
          ChatMediaIcon.alert,
          size: FujinSize.pillSmallIcon,
          color: colors.textAlert,
        ),
        [
          Text(
            intl.chatNotSent,
            style: FujinText.inter12Medium.copyWith(color: colors.textAlert),
          ),
          TextButton(
            onPressed: onRetry,
            style: TextButton.styleFrom(
              foregroundColor: colors.textLink,
              textStyle: FujinText.inter12Semibold,
              padding: _retryPadding,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.padded,
              visualDensity: VisualDensity.compact,
            ).copyWith(overlayColor: FujinTheme.pressedOverlay(colors)),
            child: Text(intl.tryAgain),
          ),
        ],
      ),
    };
    return FailureShake(
      failed: _kind == _StatusKind.failed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: FujinSpace.s1,
        children: [icon, ...children],
      ),
    );
  }
}

enum _StatusKind { sending, failed, deleting }
