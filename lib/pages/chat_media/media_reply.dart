final class MediaReply {
  const MediaReply({
    required this.messageId,
    required this.title,
    required this.excerpt,
    required this.mine,
  });

  final String messageId;
  final String title;
  final String excerpt;
  final bool mine;
}
