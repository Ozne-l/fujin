import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fujin/data/notifications/chat_notification_text.dart';
import 'package:fujin/data/notifications/chat_notifications.dart';
import 'package:fujin/domain/chat/notifications/chat_notification.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:workmanager/workmanager.dart';

final class LocalChatNotifications implements ChatNotifications {
  LocalChatNotifications._(this._plugin, this._intl);

  static const channelId = 'chat';
  static const checkName = 'chat-check';
  static const checkPeriod = Duration(minutes: 15);
  static const _icon = '@mipmap/ic_launcher_monochrome';
  static const _coachKey = 'coach';
  static const _ownerKey = 'owner';
  static const _idBytes = 4;
  static const _idMask = 0x7fffffff;
  static const _requestInProgress = 'permissionRequestInProgress';

  final FlutterLocalNotificationsPlugin _plugin;
  final AppLocalizations _intl;
  final StreamController<String> _opened = StreamController.broadcast();
  String? _launchConversation;

  static Future<LocalChatNotifications> forApp({
    required AppLocalizations intl,
    required Function backgroundDispatcher,
  }) async {
    final plugin = FlutterLocalNotificationsPlugin();
    final notifications = LocalChatNotifications._(plugin, intl);
    await plugin.initialize(
      settings: _settings,
      onDidReceiveNotificationResponse: (response) {
        if (response.payload case final conversation?) {
          notifications._opened.add(conversation);
        }
      },
    );
    notifications._launchConversation = switch (await plugin
        .getNotificationAppLaunchDetails()) {
      NotificationAppLaunchDetails(
        didNotificationLaunchApp: true,
        notificationResponse: NotificationResponse(:final payload?),
      ) =>
        payload,
      _ => null,
    };
    await plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channelOf(intl));
    if (_checksRun) await Workmanager().initialize(backgroundDispatcher);
    return notifications;
  }

  static Future<LocalChatNotifications> forBackground({
    required AppLocalizations intl,
  }) async {
    final plugin = FlutterLocalNotificationsPlugin();
    await plugin.initialize(settings: _settings);
    return LocalChatNotifications._(plugin, intl);
  }

  static const InitializationSettings _settings = InitializationSettings(
    android: AndroidInitializationSettings(_icon),
    iOS: DarwinInitializationSettings(
      requestAlertPermission: false,
      requestSoundPermission: false,
      requestBadgePermission: false,
    ),
  );

  static bool get _checksRun => defaultTargetPlatform == TargetPlatform.android;

  static AndroidNotificationChannel _channelOf(AppLocalizations intl) =>
      AndroidNotificationChannel(
        channelId,
        intl.chatNotificationChannelName,
        description: intl.chatNotificationChannelDescription,
        importance: Importance.high,
      );

  static int idOf(String conversationId) {
    final digest = sha256.convert(utf8.encode(conversationId)).bytes;
    return digest.take(_idBytes).fold(0, (id, byte) => (id << 8) | byte) &
        _idMask;
  }

  @override
  Stream<String> get opened => _opened.stream;

  @override
  String? takeLaunchConversation() {
    final conversation = _launchConversation;
    _launchConversation = null;
    return conversation;
  }

  @override
  Future<void> show(ChatNotification notification) async {
    final coach = Person(
      key: _coachKey,
      name: notification.coachName ?? _intl.chatNotificationCoach,
    );
    final messages = [
      for (final message in notification.messages)
        Message(
          ChatNotificationText.of(_intl, message.content),
          message.sentAt,
          coach,
        ),
    ];
    final channel = _channelOf(_intl);
    await _plugin.show(
      id: idOf(notification.conversationId),
      title: coach.name,
      body: messages.lastOrNull?.text,
      payload: notification.conversationId,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          importance: channel.importance,
          priority: Priority.high,
          category: AndroidNotificationCategory.message,
          visibility: NotificationVisibility.private,
          onlyAlertOnce: true,
          when: notification.messages.lastOrNull?.sentAt.millisecondsSinceEpoch,
          styleInformation: MessagingStyleInformation(
            Person(
              key: _ownerKey,
              name: notification.ownerName ?? _intl.appName,
            ),
            groupConversation: false,
            messages: messages,
          ),
        ),
        iOS: DarwinNotificationDetails(
          threadIdentifier: notification.conversationId,
        ),
      ),
    );
  }

  @override
  Future<void> cancel(String conversationId) =>
      _plugin.cancel(id: idOf(conversationId));

  @override
  Future<void> cancelAll() async {
    for (final active in await _plugin.getActiveNotifications()) {
      if (active case ActiveNotification(
        :final id?,
        channelId: LocalChatNotifications.channelId,
      )) {
        await _plugin.cancel(id: id);
      }
    }
  }

  @override
  Future<bool> requestPermission() async => switch ((
    _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >(),
    _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >(),
  )) {
    (final android?, _) => await _requestOnAndroid(android),
    (null, final ios?) =>
      await ios.requestPermissions(alert: true, badge: true, sound: true) ??
          false,
    (null, null) => false,
  };

  static Future<bool> _requestOnAndroid(
    AndroidFlutterLocalNotificationsPlugin android,
  ) async {
    try {
      return await android.requestNotificationsPermission() ?? false;
    } on PlatformException catch (error) {
      if (error.code != _requestInProgress) rethrow;
      return false;
    }
  }

  @override
  Future<void> startChecks() async {
    if (!_checksRun) return;
    await Workmanager().registerPeriodicTask(
      checkName,
      checkName,
      frequency: checkPeriod,
      constraints: Constraints(networkType: NetworkType.connected),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.update,
    );
  }

  @override
  Future<void> stopChecks() async {
    if (!_checksRun) return;
    await Workmanager().cancelByUniqueName(checkName);
  }
}
