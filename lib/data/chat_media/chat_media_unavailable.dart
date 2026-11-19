final class ChatMediaUnavailable implements Exception {
  const ChatMediaUnavailable(this.url, [this.detail]);

  final Uri url;
  final String? detail;

  @override
  String toString() => 'ChatMediaUnavailable($url, $detail)';
}
