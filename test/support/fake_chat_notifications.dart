import 'dart:async';

import 'package:fujin/data/notifications/chat_notification.dart';
import 'package:fujin/data/notifications/chat_notifications.dart';

final class FakeChatNotifications implements ChatNotifications {
  FakeChatNotifications({this.launchConversation});

  String? launchConversation;
  final Map<String, ChatNotification> shown = {};
  final List<String> cancelled = [];
  int permissionRequests = 0;
  bool checking = false;
  final StreamController<String> _opened = StreamController.broadcast();

  void open(String conversationId) => _opened.add(conversationId);

  @override
  Stream<String> get opened => _opened.stream;

  @override
  String? takeLaunchConversation() {
    final conversation = launchConversation;
    launchConversation = null;
    return conversation;
  }

  @override
  Future<void> show(ChatNotification notification) async =>
      shown[notification.conversationId] = notification;

  @override
  Future<void> cancel(String conversationId) async {
    cancelled.add(conversationId);
    shown.remove(conversationId);
  }

  @override
  Future<void> cancelAll() async {
    cancelled.addAll(shown.keys);
    shown.clear();
  }

  @override
  Future<bool> requestPermission() async {
    permissionRequests++;
    return true;
  }

  @override
  Future<void> startChecks() async => checking = true;

  @override
  Future<void> stopChecks() async => checking = false;
}
