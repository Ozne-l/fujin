import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/chat/voice/voice_notifier.dart';
import 'package:fujin/pages/chat/voice/voice_send_outcome.dart';
import 'package:fujin/pages/chat/voice/voice_start_outcome.dart';
import 'package:fujin/pages/chat/voice/voice_state.dart';
import 'package:fujin/pages/chat/voice/widgets/voice_bar.dart';
import 'package:fujin/pages/common/fade_through.dart';
import 'package:fujin/pages/common/fujin_snack_bar.dart';
import 'package:fujin/pages/common/snack_bar_content.dart';
import 'package:fujin/pages/common/snack_bar_glyph.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class VoiceComposer extends HookConsumerWidget {
  const VoiceComposer({
    required this.conversationId,
    required this.composer,
    super.key,
  });

  final String conversationId;
  final Widget Function(VoidCallback? onVoice) composer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = voiceProvider(conversationId);
    final state = ref.watch(provider);
    final notifier = ref.read(provider.notifier);
    final current = ModalRoute.isCurrentOf(context) ?? true;
    useEffect(() {
      if (!current) unawaited(notifier.keep());
      return null;
    }, [current]);

    void alert(String title, String detail) =>
        ScaffoldMessenger.of(context).showNotice(
          SnackBarContent(
            glyph: SnackBarGlyph.alert,
            title: title,
            detail: detail,
          ),
          duration: FujinSnackBar.alertDuration,
        );

    Future<void> start() async {
      final intl = context.intl;
      switch (await notifier.start()) {
        case VoiceStartOutcome.refused when context.mounted:
          alert(intl.chatVoiceRefusedTitle, intl.chatVoiceRefusedDetail);
        case VoiceStartOutcome.refused ||
            VoiceStartOutcome.recording ||
            VoiceStartOutcome.failed:
          return;
      }
    }

    Future<void> send() async {
      final intl = context.intl;
      switch (await notifier.send()) {
        case VoiceSendOutcome.tooShort when context.mounted:
          alert(intl.chatVoiceTooShortTitle, intl.chatVoiceTooShortDetail);
        case VoiceSendOutcome.tooShort ||
            VoiceSendOutcome.sent ||
            VoiceSendOutcome.notSent:
          return;
      }
    }

    final swap = FadeThrough(
      child: switch (state) {
        VoiceIdle() => KeyedSubtree(
          key: const ValueKey(VoiceIdle),
          child: composer(() => unawaited(start())),
        ),
        VoiceStarting() ||
        VoiceRecording() ||
        VoiceKept() ||
        VoiceSending() => VoiceBar(
          key: const ValueKey(VoiceBar),
          state: state,
          onDelete: () => unawaited(notifier.discard()),
          onSend: () => unawaited(send()),
        ),
      },
    );
    return switch (FujinMotion.reduced(context)) {
      true => swap,
      false => AnimatedSize(
        duration: FujinMotion.grow.duration,
        curve: FujinMotion.grow.curve,
        alignment: Alignment.bottomCenter,
        child: swap,
      ),
    };
  }
}
