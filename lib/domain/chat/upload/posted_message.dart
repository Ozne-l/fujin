import 'package:ekklo_client/ekklo_client.dart';

EkkloMessage? postedMessage(
  List<EkkloMessage> newestPage,
  Iterable<String> publicUrls,
) {
  final wanted = publicUrls.toSet();
  if (wanted.isEmpty) return null;
  for (final message in newestPage.reversed) {
    final held = {
      ...message.mediaUrls,
      for (final media in message.media) '${media.url}',
    };
    if (held.any(wanted.contains)) return message;
  }
  return null;
}
