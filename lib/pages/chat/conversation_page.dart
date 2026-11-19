import 'dart:async';

import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/fujin_route.dart';
import 'package:fujin/app/providers.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/chat/chat_link.dart';
import 'package:fujin/domain/chat/chat_state.dart';
import 'package:fujin/domain/chat/person_name.dart';
import 'package:fujin/domain/journal/read_problem.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/chat/chat_text.dart';
import 'package:fujin/pages/chat/conversation_notifier.dart';
import 'package:fujin/pages/chat/conversation_view.dart';
import 'package:fujin/pages/chat/delete_outcome.dart';
import 'package:fujin/pages/chat/message_action.dart';
import 'package:fujin/pages/chat/message_delivery.dart';
import 'package:fujin/pages/chat/message_excerpt.dart';
import 'package:fujin/pages/chat/reply_notifier.dart';
import 'package:fujin/pages/chat/thread_item.dart';
import 'package:fujin/pages/chat/upload/upload_bubble.dart';
import 'package:fujin/pages/chat/voice/voice_composer.dart';
import 'package:fujin/pages/chat/voice/voice_notifier.dart';
import 'package:fujin/pages/chat/voice/voice_state.dart';
import 'package:fujin/pages/chat/widgets/cannot_reply_note.dart';
import 'package:fujin/pages/chat/widgets/chat_composer.dart';
import 'package:fujin/pages/chat/widgets/chat_header.dart';
import 'package:fujin/pages/chat/widgets/day_separator.dart';
import 'package:fujin/pages/chat/widgets/delete_message_sheet.dart';
import 'package:fujin/pages/chat/widgets/emoji_sheet.dart';
import 'package:fujin/pages/chat/widgets/message_actions.dart';
import 'package:fujin/pages/chat/widgets/message_content.dart';
import 'package:fujin/pages/chat/widgets/message_gestures.dart';
import 'package:fujin/pages/chat/widgets/message_row.dart';
import 'package:fujin/pages/chat/widgets/message_status.dart';
import 'package:fujin/pages/chat/widgets/message_time.dart';
import 'package:fujin/pages/chat/widgets/older_messages_loader.dart';
import 'package:fujin/pages/chat_media/media_menu_anchor.dart';
import 'package:fujin/pages/chat_media/widgets/tray_reply_card.dart';
import 'package:fujin/pages/common/edge_blur.dart';
import 'package:fujin/pages/common/fujin_snack_bar.dart';
import 'package:fujin/pages/common/fujin_spinner.dart';
import 'package:fujin/pages/common/header_layout.dart';
import 'package:fujin/pages/common/offline_card.dart';
import 'package:fujin/pages/common/snack_bar_content.dart';
import 'package:fujin/pages/common/snack_bar_glyph.dart';
import 'package:fujin/pages/journal/journal_text.dart';
import 'package:fujin/pages/journal/widgets/journal_problem_card.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ConversationPage extends HookConsumerWidget {
  const ConversationPage({required this.conversationId, super.key});

  final String conversationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = conversationViewProvider(conversationId);
    final view = ref.watch(provider).value;
    final chat = ref.watch(chatProvider).value;
    final now = ref.watch(clockProvider)();
    final coach =
        view?.coach ??
        switch (chat) {
          final ChatPresent chat => chat.conversation(conversationId)?.coach,
          _ => null,
        };
    final protects =
        view?.protectsCapture ??
        switch (chat) {
          final ChatPresent chat => chat.protectsCapture(conversationId),
          _ => false,
        };
    final media = ref.read(mediaProcessorProvider);
    useEffect(() {
      unawaited(media.setSecure(secure: protects));
      return null;
    }, [protects]);
    useEffect(
      () =>
          () => unawaited(media.setSecure(secure: false)),
      const [],
    );
    final notifications = ref.read(chatNotificationsProvider);
    useEffect(() {
      unawaited(() async {
        await notifications.requestPermission();
        await notifications.cancel(conversationId);
      }());
      return null;
    }, [conversationId]);
    final draft = useTextEditingController();
    final canPop = context.canPop();
    final reply = ref.watch(replyProvider(conversationId));
    final replies = ref.read(replyProvider(conversationId).notifier);
    final notifier = ref.read(provider.notifier);

    void back() => switch (canPop) {
      true => context.pop(),
      false => context.go(FujinRoute.journal.path),
    };

    Future<void> signIn() async {
      final signedIn = await context.push<bool>(FujinRoute.ekkloSignIn.path);
      if (signedIn case true) {
        await ref.read(provider.notifier).signedInAgain();
      }
    }

    final coachName = personName(coach) ?? context.intl.chatCoach;
    final statusBar = MediaQuery.paddingOf(context).top;
    final mediaReply = switch (reply) {
      null => null,
      final reply => MessageExcerpt.reply(
        context.intl,
        reply,
        mine: switch (chat) {
          ChatPresent(:final owner) => reply.senderId == owner.id,
          _ => false,
        },
        coach: coachName,
      ),
    };

    final writable = switch (view) {
      ConversationView(
        link: ChatLink.online || ChatLink.connecting,
        canSend: true,
      ) =>
        true,
      _ => false,
    };

    void replyTo(EkkloMessage message) => replies.message = message;

    void send(String text) {
      unawaited(notifier.send(text, replyTo: reply));
      draft.clear();
      replies.cancel();
    }

    Future<void> react(EkkloMessage message, String emoji) async {
      final messenger = ScaffoldMessenger.of(context);
      final intl = context.intl;
      if (await notifier.react(message.id, emoji)) return;
      messenger.showNotice(
        SnackBarContent(
          glyph: SnackBarGlyph.alert,
          title: intl.chatReactionNotSent,
        ),
        duration: FujinSnackBar.alertDuration,
      );
    }

    Future<void> delete(EkkloMessage message) async {
      final messenger = ScaffoldMessenger.of(context);
      final intl = context.intl;
      final content = switch (await notifier.delete(message.id)) {
        MessageDeleted() => null,
        KeptByEkklo() => SnackBarContent(
          glyph: SnackBarGlyph.alert,
          title: intl.chatDeleteRefusedTitle,
          detail: intl.chatDeleteRefusedDetail,
        ),
        NotDeleted(:final problem) => SnackBarContent(
          glyph: SnackBarGlyph.alert,
          title: JournalText.problemHeadline(intl, problem),
        ),
      };
      if (content case final content?) {
        messenger.showNotice(content, duration: FujinSnackBar.alertDuration);
      }
    }

    Future<void> act(ThreadMessage item, Rect bubble, Widget content) async {
      final message = item.message;
      final action = await showMessageActions(
        context,
        bubble: bubble,
        content: content,
        mine: item.mine,
        canReply: writable,
      );
      if (!context.mounted) return;
      switch (action) {
        case null:
          return;
        case ReplyAction():
          replyTo(message);
        case ReactAction(:final emoji):
          await react(message, emoji);
        case MoreEmojiAction():
          final emoji = await showEmojiSheet(context);
          if (emoji != null && context.mounted) await react(message, emoji);
        case DeleteAction():
          await showDeleteMessageSheet(
            context,
            excerpt: MessageExcerpt.deletion(context.intl, message),
            coach: coachName,
            onDelete: () => unawaited(delete(message)),
          );
      }
    }

    final platform = Theme.of(context).platform;
    final recording = switch (platform) {
      TargetPlatform.android => ref.watch(
        voiceProvider(conversationId).select((voice) => voice is! VoiceIdle),
      ),
      TargetPlatform.iOS ||
      TargetPlatform.fuchsia ||
      TargetPlatform.linux ||
      TargetPlatform.macOS ||
      TargetPlatform.windows => false,
    };
    final composer = switch (platform) {
      TargetPlatform.android => VoiceComposer(
        conversationId: conversationId,
        composer: (onVoice) => ChatComposer(
          controller: draft,
          onSend: send,
          onVoice: onVoice,
          media: (context, button) => MediaMenuAnchor(
            coach: coachName,
            reply: mediaReply,
            onSend: (media) {
              replies.cancel();
              unawaited(notifier.sendMedia(media));
            },
            builder: (context, open) => button(open),
          ),
        ),
      ),
      TargetPlatform.iOS ||
      TargetPlatform.fuchsia ||
      TargetPlatform.linux ||
      TargetPlatform.macOS ||
      TargetPlatform.windows => ChatComposer(controller: draft, onSend: send),
    };
    final bottom = switch (view) {
      null => null,
      ConversationView(link: ChatLink.expired) => JournalProblemCard(
        problem: ReadProblem.ekkloSessionExpired,
        detail: context.intl.chatExpiredDetail,
        margin: EdgeInsets.zero,
        onSignIn: (_) => unawaited(signIn()),
        onRetry: () => unawaited(signIn()),
      ),
      ConversationView(link: ChatLink.offline) when recording => composer,
      ConversationView(link: ChatLink.offline) => OfflineCard(
        title: context.intl.chatOfflineTitle,
        detail: context.intl.chatOfflineDetail,
        margin: EdgeInsets.zero,
      ),
      ConversationView(canSend: false) => const CannotReplyNote(),
      ConversationView() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: FujinSpace.s2,
        children: [
          if (mediaReply case final mediaReply?)
            TrayReplyCard(reply: mediaReply, onCancel: replies.cancel),
          composer,
        ],
      ),
    };

    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) context.go(FujinRoute.journal.path);
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: HeaderLayout(
                header: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Positioned(
                      left: 0,
                      top: 0,
                      right: 0,
                      bottom: -FujinSize.scrollEdgeFade,
                      child: EdgeBlur(),
                    ),
                    HeaderLayout.shield(
                      Padding(
                        padding: EdgeInsets.only(top: statusBar),
                        child: ChatHeader(
                          name: coachName,
                          photo: switch (coach?.profilePicture) {
                            final picture? => Uri.tryParse(picture),
                            null => null,
                          },
                          onBack: back,
                        ),
                      ),
                    ),
                  ],
                ),
                body: (context, extent) => switch (view) {
                  ConversationView(loadingNewest: true, newestFirst: []) ||
                  null => const Center(child: FujinSpinner.card()),
                  final view => _Thread(
                    view: view,
                    top: extent,
                    coachName: coachName,
                    now: now,
                    onOlder: () => unawaited(notifier.loadOlder()),
                    onReply: switch (writable) {
                      true => replyTo,
                      false => null,
                    },
                    onRetry: (pendingId) =>
                        unawaited(notifier.retry(pendingId)),
                    onRetryUpload: (uploadId) =>
                        unawaited(notifier.retryUpload(uploadId)),
                    onReact: (message, emoji) =>
                        unawaited(react(message, emoji)),
                    onActions: (item, bubble, content) =>
                        unawaited(act(item, bubble, content)),
                  ),
                },
              ),
            ),
            if (bottom case final bottom?)
              SafeArea(
                top: false,
                minimum: const EdgeInsets.only(bottom: FujinSpace.s2),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    FujinSize.screenMargin,
                    FujinSpace.s2,
                    FujinSize.screenMargin,
                    0,
                  ),
                  child: bottom,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Thread extends StatelessWidget {
  const _Thread({
    required this.view,
    required this.top,
    required this.coachName,
    required this.onOlder,
    required this.now,
    required this.onReply,
    required this.onRetry,
    required this.onRetryUpload,
    required this.onReact,
    required this.onActions,
  });

  final ConversationView view;
  final double top;
  final String coachName;
  final VoidCallback onOlder;
  final DateTime now;
  final ValueChanged<EkkloMessage>? onReply;
  final ValueChanged<String> onRetry;
  final ValueChanged<String> onRetryUpload;
  final void Function(EkkloMessage message, String emoji) onReact;
  final void Function(ThreadMessage item, Rect bubble, Widget content)
  onActions;

  Widget _message(BuildContext context, ThreadMessage item) {
    final message = item.message;
    final content = MessageContent(
      item: item,
      coachName: coachName,
      onOpenMedia: (index) => unawaited(
        context.push(
          FujinRoute.chatMedia.forMedia(
            view.conversationId,
            message.id,
            index: index,
          ),
        ),
      ),
    );
    final sent = item.delivery == MessageDelivery.sent;
    return MessageRow(
      key: ValueKey(message.id),
      mine: item.mine,
      reactions: message.reactions,
      onReaction: switch (sent) {
        true => (reaction) => onReact(message, reaction.emoji),
        false => null,
      },
      footer: switch (item.delivery) {
        MessageDelivery.sent => MessageTime(at: message.createdAt),
        MessageDelivery.sending => const MessageStatus.sending(),
        MessageDelivery.deleting => const MessageStatus.deleting(),
        MessageDelivery.failed => MessageStatus.failed(
          onRetry: () => onRetry(message.id),
        ),
      },
      content: MessageGestures(
        mine: item.mine,
        onReply: switch ((sent, onReply)) {
          (true, final onReply?) => () => onReply(message),
          _ => null,
        },
        onLongPress: switch (sent) {
          true => (bubble) => onActions(item, bubble, content),
          false => null,
        },
        child: content,
      ),
    );
  }

  static const double _spacing = 12;

  bool _nearTop(ScrollMetrics metrics) =>
      metrics.extentAfter < metrics.viewportDimension;

  @override
  Widget build(BuildContext context) {
    final items = view.newestFirst;
    final count = items.length + (view.loadingOlder ? 1 : 0);
    return NotificationListener<ScrollMetricsNotification>(
      onNotification: (notification) {
        if (_nearTop(notification.metrics)) onOlder();
        return false;
      },
      child: NotificationListener<ScrollUpdateNotification>(
        onNotification: (notification) {
          if (_nearTop(notification.metrics)) onOlder();
          return false;
        },
        child: ListView.separated(
          reverse: true,
          padding: EdgeInsets.fromLTRB(
            FujinSize.screenMargin,
            top + _spacing,
            FujinSize.screenMargin,
            _spacing,
          ),
          itemCount: count,
          separatorBuilder: (context, index) =>
              const SizedBox(height: _spacing),
          itemBuilder: (context, index) => switch (items.elementAtOrNull(
            index,
          )) {
            null => const OlderMessagesLoader(),
            ThreadDay(:final day) => DaySeparator(
              label: ChatText.day(context.intl, day, now: now),
            ),
            final ThreadMessage item => _message(context, item),
            final ThreadUpload item => UploadBubble(
              item: item,
              coachName: coachName,
              onRetry: () => onRetryUpload(item.upload.id),
            ),
          },
        ),
      ),
    );
  }
}
