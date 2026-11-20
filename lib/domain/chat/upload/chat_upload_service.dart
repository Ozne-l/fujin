import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/data/chat/chat_media_kind.dart';
import 'package:fujin/data/chat/chat_repository.dart';
import 'package:fujin/data/chat/file_in_progress.dart';
import 'package:fujin/data/chat/message_in_progress.dart';
import 'package:fujin/data/chat/message_in_progress_repository.dart';
import 'package:fujin/data/chat/message_in_progress_state.dart';
import 'package:fujin/data/media/exported_video.dart';
import 'package:fujin/data/media/media_processing_exception.dart';
import 'package:fujin/data/media/media_processor.dart';
import 'package:fujin/data/media/video_export_event.dart';
import 'package:fujin/data/media/video_outcome.dart';
import 'package:fujin/data/upload/media_uploader.dart';
import 'package:fujin/data/upload/relay_scheduler.dart';
import 'package:fujin/data/upload/upload_completion.dart';
import 'package:fujin/data/upload/upload_folder.dart';
import 'package:fujin/data/upload/upload_notice.dart';
import 'package:fujin/data/upload/upload_notifications.dart';
import 'package:fujin/data/upload/upload_order.dart';
import 'package:fujin/data/upload/upload_update.dart';
import 'package:fujin/domain/chat/edit/edited_media.dart';
import 'package:fujin/domain/chat/edit/media_send.dart';
import 'package:fujin/domain/chat/person_name.dart';
import 'package:fujin/domain/chat/upload/message_poster.dart';
import 'package:fujin/domain/chat/upload/message_upload.dart';
import 'package:fujin/domain/chat/upload/upload_deadline.dart';
import 'package:fujin/domain/chat/upload/upload_phase.dart';
import 'package:fujin/domain/chat/upload/uploading_media.dart';
import 'package:uuid/uuid.dart';

final class ChatUploadService {
  ChatUploadService({
    required EkkloMessaging messaging,
    required this._messages,
    required this._chats,
    required this._processor,
    required this._uploader,
    required this._relay,
    required this._notifications,
    required this._folder,
    required this._cachePath,
    required this._accept,
    required this._clock,
  }) : _poster = MessagePoster(messaging),
       _messaging = messaging;

  static const maximumRenewals = 3;
  static const _full = 100;

  final EkkloMessaging _messaging;
  final MessagePoster _poster;
  final MessageInProgressRepository _messages;
  final ChatRepository _chats;
  final MediaProcessor _processor;
  final MediaUploader _uploader;
  final RelayScheduler _relay;
  final UploadNotifications _notifications;
  final UploadFolder _folder;
  final String? _cachePath;
  final void Function(EkkloMessage message) _accept;
  final DateTime Function() _clock;

  final _watchers = <String, Set<StreamController<List<MessageUpload>>>>{};
  final _messageOf = <String, String>{};
  final _exported = <String, int>{};
  final _uploaded = <String, double>{};
  final _sizes = <String, int>{};
  final _renewals = <String, int>{};
  final _waiting = <String>{};
  final _inFlight = <String>{};
  final _advancing = <String>{};
  final _again = <String>{};
  StreamSubscription<UploadUpdate>? _updates;
  bool _online = true;
  bool _disposed = false;

  Future<void> start() async {
    _updates ??= _uploader.updates.listen(_onUpdate);
    _sweep();
    final pending = _messages.all();
    for (final message in pending) {
      _remember(message.id);
    }
    await _uploader.start();
    _folder.keepOnly({for (final message in pending) message.id});
    for (final message in pending) {
      unawaited(_advance(message.id));
    }
  }

  void dispose() {
    _disposed = true;
    unawaited(_updates?.cancel());
    for (final controllers in _watchers.values) {
      for (final controller in controllers) {
        unawaited(controller.close());
      }
    }
    _watchers.clear();
  }

  Stream<List<MessageUpload>> watch(String conversationId) {
    late final StreamController<List<MessageUpload>> controller;
    controller = StreamController(
      onListen: () {
        _watchers.putIfAbsent(conversationId, () => {}).add(controller);
        controller.add(_uploadsIn(conversationId));
      },
      onCancel: () => _watchers[conversationId]?.remove(controller),
    );
    return controller.stream;
  }

  Future<void> sendMedia(String conversationId, MediaSend send) async {
    final id = const Uuid().v4();
    _messages.start(
      MessageInProgress(
        id: id,
        conversationId: conversationId,
        startedAt: _clock(),
        state: MessageInProgressState.processing,
        caption: switch (send.caption.trim()) {
          '' => null,
          _ => send.caption,
        },
        replyToId: send.replyToId,
      ),
      [
        for (final (position, media) in send.media.indexed)
          FileInProgress(
            id: const Uuid().v4(),
            messageId: id,
            position: position,
            kind: switch (media) {
              EditedPhoto() => ChatMediaKind.image,
              EditedVideo() => ChatMediaKind.video,
            },
            source: media.toMap(),
          ),
      ],
    );
    _remember(id);
    _emit(conversationId);
    unawaited(_advance(id));
  }

  Future<void> sendVoice({
    required String conversationId,
    required String path,
    required int durationSeconds,
    String? replyToId,
  }) async {
    final id = const Uuid().v4();
    final fileId = const Uuid().v4();
    final kept = _folder.adopt(
      path,
      id,
      '$fileId${_Kind.of(ChatMediaKind.voice).extension}',
    );
    _messages.start(
      MessageInProgress(
        id: id,
        conversationId: conversationId,
        startedAt: _clock(),
        state: MessageInProgressState.uploading,
        replyToId: replyToId,
        durationSeconds: durationSeconds,
      ),
      [
        FileInProgress(
          id: fileId,
          messageId: id,
          position: 0,
          kind: ChatMediaKind.voice,
          path: kept,
        ),
      ],
    );
    _remember(id);
    _emit(conversationId);
    unawaited(_advance(id));
  }

  Future<void> retry(String messageId) async {
    final message = _messages.message(messageId);
    if (message == null || message.state != MessageInProgressState.failed) {
      return;
    }
    _renewalsOf(messageId).forEach(_renewals.remove);
    _messages.save(
      message.copyWith(
        startedAt: _clock(),
        state: switch (_messages.files(messageId).any(_unprocessed)) {
          true => MessageInProgressState.processing,
          false => MessageInProgressState.uploading,
        },
      ),
    );
    await _notifications.cancel(messageId);
    _emit(message.conversationId);
    await _advance(messageId);
  }

  Future<void> discard(String messageId) async {
    final message = _messages.message(messageId);
    if (message == null) return;
    await _uploader.cancel(messageId);
    await _relay.cancel(messageId);
    await _notifications.cancel(messageId);
    _forget(messageId);
    _messages.delete(messageId);
    _folder.delete(messageId);
    _emit(message.conversationId);
  }

  void setOnline({required bool online}) {
    if (_online == online) return;
    _online = online;
    if (!online) return;
    for (final message in _messages.all()) {
      unawaited(_advance(message.id));
    }
  }

  void setForeground({required bool foreground}) {
    if (!foreground) return;
    _sweep();
    [..._watchers.keys].forEach(_emit);
    for (final message in _messages.all()) {
      unawaited(_advance(message.id));
    }
  }

  Future<void> _advance(String messageId) async {
    if (_disposed) return;
    if (!_advancing.add(messageId)) {
      _again.add(messageId);
      return;
    }
    try {
      await _step(messageId);
    } finally {
      _advancing.remove(messageId);
    }
    if (_again.remove(messageId)) await _advance(messageId);
  }

  Future<void> _step(String messageId) async {
    final message = _messages.message(messageId);
    if (message == null || message.state == MessageInProgressState.failed) {
      return;
    }
    if (UploadDeadline.passed(message, now: _clock())) {
      return _fail(message);
    }
    final processed = await _processAll(message);
    if (processed == null) return;
    final uploaded = await _uploadAll(processed);
    if (!uploaded) return;
    final files = _messages.files(messageId);
    if (files.every((file) => file.isComplete)) await _post(processed, files);
  }

  Future<MessageInProgress?> _processAll(MessageInProgress message) async {
    final files = _messages.files(message.id);
    final waiting = files.where(_unprocessed).toList();
    if (waiting.isEmpty) return message;
    final processing = message.copyWith(
      state: MessageInProgressState.processing,
    );
    _messages.save(processing);
    _emit(message.conversationId);
    final videos = [
      for (final file in files)
        if (file.kind == ChatMediaKind.video) file.id,
    ];
    try {
      for (final file in waiting) {
        final processed = await _process(
          message,
          file,
          position: videos.indexOf(file.id) + 1,
          videos: videos.length,
        );
        if (_disposed) return null;
        _messages.saveFile(processed);
        _exported.remove(file.id);
        _emit(message.conversationId);
      }
    } on Object catch (error) {
      if (_disposed) return null;
      if (error is! MediaProcessingException && error is! FormatException) {
        rethrow;
      }
      await _fail(processing);
      return null;
    }
    if (_disposed) return null;
    final uploading = processing.copyWith(
      state: MessageInProgressState.uploading,
    );
    _messages.save(uploading);
    _emit(message.conversationId);
    return uploading;
  }

  Future<FileInProgress> _process(
    MessageInProgress message,
    FileInProgress file, {
    required int position,
    required int videos,
  }) async {
    final source = switch (file.source) {
      final source? => EditedMediaMapper.fromMap(source),
      null => throw const FormatException(),
    };
    _folder.create(message.id);
    final kind = _Kind.of(file.kind);
    final output = _folder.file(message.id, '${file.id}${kind.extension}');
    switch (source) {
      case EditedPhoto(:final path, :final edit):
        final photo = await _processor.processPhoto(
          edit.request(source: path, output: output),
        );
        return file.copyWith(path: photo.path);
      case EditedVideo(:final path, :final edit):
        ExportedVideo? exported;
        await for (final event in _processor.exportVideo(
          edit.request(
            source: path,
            output: output,
            poster: _folder.file(message.id, '${file.id}$_posterExtension'),
            recipient: _coachOf(message.conversationId),
            position: position,
            count: videos,
          ),
        )) {
          switch (event) {
            case VideoExportProgress(:final percent):
              _exported[file.id] = percent;
              _emit(message.conversationId);
            case VideoExportDone(:final video):
              exported = video;
          }
        }
        return switch (exported) {
          null => throw const FormatException(),
          final video => file.copyWith(
            path: video.path,
            originalBytes: switch (video.outcome) {
              VideoOutcome.original => video.bytes,
              VideoOutcome.encoded || VideoOutcome.toneMapped => null,
            },
          ),
        };
    }
  }

  Future<bool> _uploadAll(MessageInProgress message) async {
    final active = await _uploader.activeUploads();
    if (_disposed) return false;
    final files = _messages.files(message.id);
    final pending = [
      for (final file in files)
        if (!file.isComplete && !_uploading(file, active)) file,
    ];
    if (pending.isEmpty) return true;
    if (!_online) {
      await _wait(message);
      return false;
    }
    final notice = UploadNotice(
      conversationId: message.conversationId,
      coach: _coachOf(message.conversationId),
      count: files.length,
    );
    try {
      for (final file in pending) {
        final path = file.path;
        if (path == null) throw const FormatException();
        final kind = _Kind.of(file.kind);
        final presigned = await _messaging.presignUpload(
          fileName: File(path).uri.pathSegments.last,
          fileType: kind.mimeType,
          resourceType: kind.resourceType,
          resourceId: message.conversationId,
        );
        if (_disposed) return false;
        final publicUrl = '${presigned.publicUrl}';
        _messages.saveFile(file.copyWith(publicUrl: publicUrl));
        _sizes[file.id] = max(File(path).statSync().size, 1);
        _uploaded[file.id] = 0;
        _inFlight.add(publicUrl);
        final enqueued = await _uploader.enqueue(
          UploadOrder(
            fileId: file.id,
            messageId: message.id,
            position: file.position + 1,
            path: path,
            url: presigned.uploadUrl,
            publicUrl: publicUrl,
            mimeType: kind.mimeType,
            notice: notice,
          ),
        );
        if (!enqueued) {
          _inFlight.remove(publicUrl);
          throw const FormatException();
        }
      }
    } on EkkloNetworkException {
      if (_disposed) return false;
      await _wait(message);
      return false;
    } on Object catch (error) {
      if (_disposed) return false;
      if (error is! EkkloException &&
          error is! FileSystemException &&
          error is! FormatException) {
        rethrow;
      }
      await _fail(message);
      return false;
    }
    if (_disposed) return false;
    await _relay.schedule(message.id);
    if (_waiting.remove(message.id)) await _notifications.cancel(message.id);
    _emit(message.conversationId);
    return false;
  }

  Future<void> _post(
    MessageInProgress message,
    List<FileInProgress> files,
  ) async {
    await _relay.cancel(message.id);
    final EkkloMessage sent;
    try {
      sent = await _poster.post(message, files);
    } on EkkloNetworkException {
      await _relay.schedule(message.id);
      await _wait(message);
      return;
    } on Object catch (error) {
      if (error is! EkkloException && error is! FormatException) rethrow;
      await _fail(message);
      return;
    }
    if (_disposed) return;
    _accept(sent);
    await _notifications.cancel(message.id);
    _forget(message.id);
    _messages.delete(message.id);
    _folder.delete(message.id);
    _emit(message.conversationId);
  }

  Future<void> _wait(MessageInProgress message) async {
    if (!_waiting.add(message.id)) return;
    _emit(message.conversationId);
    await _notifications.showWaiting(
      message.id,
      UploadNotice(
        conversationId: message.conversationId,
        coach: _coachOf(message.conversationId),
        count: _messages.files(message.id).length,
      ),
    );
  }

  Future<void> _fail(MessageInProgress message) async {
    _messages.save(message.copyWith(state: MessageInProgressState.failed));
    for (final file in _messages.files(message.id)) {
      _exported.remove(file.id);
      _uploaded.remove(file.id);
      _inFlight.remove(file.publicUrl);
    }
    _waiting.remove(message.id);
    _emit(message.conversationId);
    await _uploader.cancel(message.id);
    await _relay.cancel(message.id);
    await _notifications.showFailed(
      message.id,
      conversationId: message.conversationId,
    );
  }

  void _onUpdate(UploadUpdate update) {
    final messageId = _messageOf[update.fileId];
    if (messageId == null || _disposed) return;
    if (update case UploadCompleted() || UploadFailed()) {
      _inFlight.remove(update.publicUrl);
    }
    final message = _messages.message(messageId);
    final current = _messages
        .files(messageId)
        .any(
          (file) =>
              file.id == update.fileId && file.publicUrl == update.publicUrl,
        );
    if (message == null || !current) return;
    switch (update) {
      case UploadProgressed(:final fraction):
        _uploaded[update.fileId] = fraction;
        if (_waiting.remove(messageId)) {
          unawaited(_notifications.cancel(messageId));
        }
        _emit(message.conversationId);
      case UploadWaiting():
        unawaited(_wait(message));
      case UploadCompleted():
        _messages.completeFile(
          update.fileId,
          publicUrl: update.publicUrl,
          at: _clock(),
        );
        _uploaded.remove(update.fileId);
        _emit(message.conversationId);
        unawaited(_advance(messageId));
      case UploadFailed(expired: true)
          when (_renewals[update.fileId] ?? 0) < maximumRenewals:
        _renewals.update(
          update.fileId,
          (count) => count + 1,
          ifAbsent: () => 1,
        );
        unawaited(_advance(messageId));
      case UploadFailed() when !_online:
        unawaited(_wait(message));
      case UploadFailed():
        unawaited(_fail(message));
    }
  }

  void _sweep() {
    if (_cachePath case final cachePath?) {
      UploadCompletion.sweep(_messages, cachePath: cachePath);
    }
  }

  void _remember(String messageId) {
    for (final file in _messages.files(messageId)) {
      _messageOf[file.id] = messageId;
    }
  }

  Iterable<String> _renewalsOf(String messageId) => [
    for (final file in _messages.files(messageId))
      if (_renewals.containsKey(file.id)) file.id,
  ];

  void _forget(String messageId) {
    for (final file in _messages.files(messageId)) {
      _messageOf.remove(file.id);
      _exported.remove(file.id);
      _uploaded.remove(file.id);
      _sizes.remove(file.id);
      _renewals.remove(file.id);
      _inFlight.remove(file.publicUrl);
    }
    _waiting.remove(messageId);
  }

  String? _coachOf(String conversationId) {
    for (final cached in _chats.conversations()) {
      if (cached.id == conversationId) {
        return personName(EkkloConversationMapper.fromMap(cached.json).coach);
      }
    }
    return null;
  }

  void _emit(String conversationId) {
    final controllers = _watchers[conversationId];
    if (controllers == null || controllers.isEmpty) return;
    final uploads = _uploadsIn(conversationId);
    for (final controller in [...controllers]) {
      controller.add(uploads);
    }
  }

  List<MessageUpload> _uploadsIn(String conversationId) => [
    for (final message in _messages.inConversation(conversationId))
      _uploadOf(message, _messages.files(message.id)),
  ];

  MessageUpload _uploadOf(
    MessageInProgress message,
    List<FileInProgress> files,
  ) {
    final media = [
      for (final file in files)
        UploadingMedia(
          id: file.id,
          kind: file.kind,
          media: switch (file.source) {
            final source? => EditedMediaMapper.fromMap(source),
            null => null,
          },
          percent: _percentOf(file),
          originalBytes: file.originalBytes,
        ),
    ];
    final exporting = [
      for (final file in files)
        if (file.kind == ChatMediaKind.video && _unprocessed(file)) file,
    ];
    return MessageUpload(
      id: message.id,
      conversationId: message.conversationId,
      startedAt: message.startedAt,
      caption: message.caption ?? '',
      replyToId: message.replyToId,
      durationSeconds: message.durationSeconds,
      media: media,
      phase: switch ((message.state, exporting)) {
        (MessageInProgressState.failed, _) => const UploadNotSent(),
        (MessageInProgressState.processing, [final first, ...]) =>
          UploadPreparing(
            videos: exporting.length,
            percent: _exported[first.id] ?? 0,
          ),
        (
          MessageInProgressState.processing || MessageInProgressState.uploading,
          _,
        ) =>
          UploadSending(
            percent: _sentPercent(files),
            waiting: _waiting.contains(message.id),
          ),
      },
    );
  }

  int? _percentOf(FileInProgress file) => switch ((
    file.isComplete,
    _unprocessed(file),
  )) {
    (true, _) => null,
    (false, true) => _exported[file.id] ?? 0,
    (false, false) => ((_uploaded[file.id] ?? 0) * _full).floor(),
  };

  int _sentPercent(List<FileInProgress> files) {
    var total = 0;
    var sent = 0.0;
    for (final file in files) {
      final size = _sizes[file.id] ?? 1;
      total += size;
      sent +=
          size *
          switch (file.isComplete) {
            true => 1.0,
            false => _uploaded[file.id] ?? 0,
          };
    }
    return switch (total) {
      0 => 0,
      _ => (sent / total * _full).floor(),
    };
  }

  static bool _unprocessed(FileInProgress file) => file.path == null;

  bool _uploading(FileInProgress file, Set<String> active) =>
      switch (file.publicUrl) {
        final url? => active.contains(url) || _inFlight.contains(url),
        null => false,
      };

  static const _posterExtension = '.poster.jpg';
}

final class _Kind {
  const _Kind(this.mimeType, this.resourceType, this.extension);

  factory _Kind.of(ChatMediaKind kind) => switch (kind) {
    ChatMediaKind.image => const _Kind(
      'image/jpeg',
      EkkloUploadResourceType.messageImage,
      '.jpg',
    ),
    ChatMediaKind.video => const _Kind(
      'video/mp4',
      EkkloUploadResourceType.messageVideo,
      '.mp4',
    ),
    ChatMediaKind.voice => const _Kind(
      'audio/m4a',
      EkkloUploadResourceType.messageVoice,
      '.m4a',
    ),
  };

  final String mimeType;
  final EkkloUploadResourceType resourceType;
  final String extension;
}
