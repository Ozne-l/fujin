import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/domain/chat/pending_text.dart';

EkkloMessage? sentText(
  PendingText pending,
  List<EkkloMessage> newestPage, {
  required String ownerId,
  Set<String> taken = const {},
}) {
  final text = pending.message;
  final start = switch (pending.after) {
    null => -1,
    final after => newestPage.indexWhere((message) => message.id == after),
  };
  final candidates = switch (start) {
    < 0 => newestPage.where(
      (message) => !message.createdAt.isBefore(text.createdAt),
    ),
    _ => newestPage.skip(start + 1),
  };
  return candidates
      .where(
        (message) =>
            !taken.contains(message.id) &&
            message.senderId == ownerId &&
            message.type == EkkloMessageType.text &&
            message.content == text.content,
      )
      .firstOrNull;
}
