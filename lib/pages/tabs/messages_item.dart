import 'package:flutter/foundation.dart';

final class MessagesItem {
  const MessagesItem({required this.unread, required this.onOpen});

  static const String icon = 'assets/icons/message_circle.svg';

  final int unread;
  final VoidCallback onOpen;
}
