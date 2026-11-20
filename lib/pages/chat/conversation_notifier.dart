import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/app/providers.dart';
import 'package:fujin/domain/chat/edit/media_send.dart';
import 'package:fujin/domain/chat/upload/message_upload.dart';
import 'package:fujin/domain/journal/read_problem.dart';
import 'package:fujin/pages/chat/conversation_view.dart';
import 'package:fujin/pages/chat/delete_outcome.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart';

final NotifierProviderFamily<
  ConversationNotifier,
  AsyncValue<ConversationView>,
  String
>
conversationViewProvider = NotifierProvider.autoDispose
    .family<ConversationNotifier, AsyncValue<ConversationView>, String>(
      ConversationNotifier.new,
    );

final StreamProviderFamily<List<MessageUpload>, String> messageUploadsProvider =
    StreamProvider.autoDispose.family<List<MessageUpload>, String>(
      (ref, conversationId) =>
          ref.watch(chatUploadServiceProvider).watch(conversationId),
    );

final class ConversationNotifier
    extends Notifier<AsyncValue<ConversationView>> {
  ConversationNotifier(this._conversationId);

  final String _conversationId;

  @override
  AsyncValue<ConversationView> build() {
    final uploads =
        ref.watch(messageUploadsProvider(_conversationId)).value ??
        const <MessageUpload>[];
    return ref
        .watch(conversationProvider(_conversationId))
        .whenData((state) => ConversationView.of(state, uploads: uploads));
  }

  Future<void> sendMedia(MediaSend send) =>
      ref.read(chatUploadServiceProvider).sendMedia(_conversationId, send);

  Future<void> retryUpload(String uploadId) =>
      ref.read(chatUploadServiceProvider).retry(uploadId);

  Future<void> loadOlder() async {
    if (state case AsyncValue(
      value: ConversationView(hasOlder: true, loadingOlder: false),
    )) {
      await ref.read(chatServiceProvider).loadOlder(_conversationId);
    }
  }

  Future<void> signedInAgain() => ref.read(chatServiceProvider).refresh();

  Future<bool> send(String content, {EkkloMessage? replyTo}) => ref
      .read(chatServiceProvider)
      .sendText(_conversationId, content, replyTo: replyTo);

  Future<bool> retry(String pendingId) =>
      ref.read(chatServiceProvider).retryText(_conversationId, pendingId);

  Future<bool> react(String messageId, String emoji) async {
    try {
      await ref.read(chatServiceProvider).react(messageId, emoji);
      return true;
    } on EkkloException {
      return false;
    }
  }

  Future<DeleteOutcome> delete(String messageId) async {
    try {
      await ref
          .read(chatServiceProvider)
          .deleteMessage(_conversationId, messageId);
      return const MessageDeleted();
    } on EkkloMessageNotDeletedException {
      return const KeptByEkklo();
    } on EkkloException catch (error) {
      return NotDeleted(ReadProblem.of(error));
    }
  }
}
