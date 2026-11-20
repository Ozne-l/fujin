import 'package:dart_mappable/dart_mappable.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/domain/chat/chat_link.dart';
import 'package:fujin/domain/chat/conversation_state.dart';
import 'package:fujin/domain/chat/pending_text_state.dart';
import 'package:fujin/domain/chat/upload/message_upload.dart';
import 'package:fujin/pages/chat/chat_text.dart';
import 'package:fujin/pages/chat/message_delivery.dart';
import 'package:fujin/pages/chat/thread_item.dart';

part 'conversation_view.mapper.dart';

@MappableClass()
final class ConversationView with ConversationViewMappable {
  const ConversationView({
    required this.conversationId,
    required this.ownerId,
    required this.coach,
    required this.newestFirst,
    required this.link,
    required this.loadingNewest,
    required this.loadingOlder,
    required this.hasOlder,
    required this.canSend,
    required this.protectsCapture,
  });

  factory ConversationView.of(
    ConversationState state, {
    List<MessageUpload> uploads = const [],
  }) {
    final byId = {for (final message in state.messages) message.id: message};
    final seenId = state.messages
        .where((message) => state.isMine(message) && message.readByOther)
        .lastOrNull
        ?.id;
    final items = <ThreadItem>[];
    DateTime? shown;
    final shownMessages = [
      for (final message in state.messages)
        (
          message,
          switch (state.deleting.contains(message.id)) {
            true => MessageDelivery.deleting,
            false => MessageDelivery.sent,
          },
        ),
      for (final pending in state.pendingTexts)
        (
          pending.message,
          switch (pending.state) {
            PendingTextState.sending => MessageDelivery.sending,
            PendingTextState.failed => MessageDelivery.failed,
          },
        ),
    ];
    void separate(DateTime at) {
      final day = ChatText.calendarDay(at);
      if (day != shown) {
        items.add(ThreadDay(day));
        shown = day;
      }
    }

    for (final (message, delivery) in shownMessages) {
      separate(message.createdAt);
      items.add(
        ThreadMessage(
          message: message,
          mine: state.isMine(message),
          quoted: switch (message.replyTo) {
            null => null,
            final reply => byId[reply.id],
          },
          quotesMine: message.replyTo?.senderId == state.ownerId,
          delivery: delivery,
          seen: message.id == seenId,
        ),
      );
    }
    for (final upload in uploads) {
      separate(upload.startedAt);
      final quoted = switch (upload.replyToId) {
        null => null,
        final id => byId[id],
      };
      items.add(
        ThreadUpload(
          upload: upload,
          quoted: quoted,
          quotesMine: quoted?.senderId == state.ownerId,
        ),
      );
    }
    return ConversationView(
      conversationId: state.conversationId,
      ownerId: state.ownerId,
      coach: state.conversation?.coach,
      newestFirst: items.reversed.toList(),
      link: state.link,
      loadingNewest: state.loadingNewest,
      loadingOlder: state.loadingOlder,
      hasOlder: state.hasOlder,
      canSend: state.canSend,
      protectsCapture: state.protectsCapture,
    );
  }

  final String conversationId;
  final String? ownerId;
  final EkkloPerson? coach;
  final List<ThreadItem> newestFirst;
  final ChatLink link;
  final bool loadingNewest;
  final bool loadingOlder;
  final bool hasOlder;
  final bool canSend;
  final bool protectsCapture;

  bool get writable => switch ((link, canSend)) {
    (ChatLink.online || ChatLink.connecting, true) => true,
    (ChatLink.online || ChatLink.connecting, false) => false,
    (ChatLink.offline || ChatLink.expired, _) => false,
  };

  bool isMine(EkkloMessage message) => message.senderId == ownerId;
}
