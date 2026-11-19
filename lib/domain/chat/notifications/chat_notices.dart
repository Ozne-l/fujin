import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/domain/chat/notifications/chat_notification.dart';
import 'package:fujin/domain/chat/notifications/conversation_notice.dart';
import 'package:fujin/domain/chat/notifications/media_label.dart';
import 'package:fujin/domain/chat/notifications/notified_content.dart';
import 'package:fujin/domain/chat/notifications/notified_message.dart';
import 'package:fujin/domain/chat/person_name.dart';

List<ConversationNotice> chatNotices(
  List<EkkloConversation> conversations, {
  required Map<String, EkkloConversation> previous,
  required String? ownerId,
}) {
  final listed = {for (final conversation in conversations) conversation.id};
  return [
    for (final conversation in conversations)
      ?_noticeOf(conversation, previous[conversation.id], ownerId),
    for (final id in previous.keys)
      if (!listed.contains(id)) RemoveNotice(id),
  ];
}

ConversationNotice? _noticeOf(
  EkkloConversation conversation,
  EkkloConversation? before,
  String? ownerId,
) => switch ((
  _unreadOf(conversation, ownerId),
  switch (before) {
    final before? => _unreadOf(before, ownerId),
    null => null,
  },
)) {
  ([], _) => RemoveNotice(conversation.id),
  ([..., final newest], [..., final seen]) when newest.id == seen.id => null,
  (final unread, _) => ShowNotice(
    ChatNotification(
      conversationId: conversation.id,
      coachName: personName(conversation.coach),
      ownerName: personName(conversation.customer),
      messages: [
        for (final message in unread)
          NotifiedMessage(
            id: message.id,
            sentAt: message.createdAt,
            content: _contentOf(message),
          ),
      ],
    ),
  ),
};

List<EkkloMessage> _unreadOf(
  EkkloConversation conversation,
  String? ownerId,
) {
  final owner = ownerId ?? conversation.customer?.id;
  final newestFirst = [
    for (final message in conversation.lastMessages)
      if (!message.internal && message.senderId != owner) message,
  ]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return newestFirst.take(conversation.unreadCount).toList().reversed.toList();
}

NotifiedContent _contentOf(EkkloMessage message) => switch ((
  message.contentRef,
  message.type,
  message.mediaUrls,
  message.media,
)) {
  (_?, _, _, _) => const NotifiedUnsupported(),
  (null, EkkloMessageType.text, _, _) => NotifiedText(message.content),
  (null, EkkloMessageType.unknown, _, _) => const NotifiedUnsupported(),
  (null, EkkloMessageType.image, [], _) => _media(
    const PhotosLabel(1),
    message,
  ),
  (null, EkkloMessageType.video, [], _) => _media(
    const VideosLabel(1),
    message,
  ),
  (null, EkkloMessageType.audio || EkkloMessageType.voice, [], _) => _media(
    const VoiceLabel(),
    message,
  ),
  (null, EkkloMessageType.mixed, [], _) => _media(
    const MixedLabel(null),
    message,
  ),
  (null, _, _, []) => const NotifiedUnsupported(),
  (null, _, _, final media) => _media(_labelOf(media), message),
};

NotifiedMedia _media(MediaLabel label, EkkloMessage message) => NotifiedMedia(
  label,
  caption: switch (message.content.trim()) {
    '' => null,
    _ => message.content,
  },
);

MediaLabel _labelOf(List<EkkloMedia> media) =>
    switch ({for (final item in media) item.kind}) {
      Set(length: 1, first: EkkloMediaKind.image) => PhotosLabel(media.length),
      Set(length: 1, first: EkkloMediaKind.video) => VideosLabel(media.length),
      Set(length: 1, first: EkkloMediaKind.voice) => const VoiceLabel(),
      _ => MixedLabel(media.length),
    };
