import 'dart:async';

import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

final class FakeVideoPlayer {
  FakeVideoPlayer({
    this.duration = const Duration(seconds: 42),
    this.failures = 0,
  });

  static const _size = Size(1280, 720);

  final Duration duration;
  int failures;
  Completer<void>? gate;
  Completer<void>? seekBuffer;
  final List<FakeVideoController> controllers = [];

  FakeVideoController get last => controllers.last;

  VideoPlayerController build(Uri url) {
    final controller = FakeVideoController._(url, this);
    controllers.add(controller);
    return controller;
  }
}

final class FakeVideoController extends VideoPlayerController {
  FakeVideoController._(super.url, this._player) : super.networkUrl();

  final FakeVideoPlayer _player;
  final List<Duration> seeks = [];
  bool disposed = false;

  @override
  Future<void> initialize() async {
    await _player.gate?.future;
    if (disposed) return;
    if (_player.failures > 0) {
      _player.failures--;
      throw PlatformException(code: 'VideoError');
    }
    value = value.copyWith(
      isInitialized: true,
      duration: _player.duration,
      size: FakeVideoPlayer._size,
    );
  }

  Future<void> complete() async {
    value = value.copyWith(isCompleted: true);
    await pause();
    await seekTo(value.duration);
  }

  @override
  Future<void> play() async {
    if (value.position == value.duration) await seekTo(Duration.zero);
    value = value.copyWith(isPlaying: true, isCompleted: false);
  }

  @override
  Future<void> pause() async => value = value.copyWith(isPlaying: false);

  @override
  Future<void> setVolume(double volume) async =>
      value = value.copyWith(volume: volume);

  @override
  Future<void> seekTo(Duration position) async {
    seeks.add(position);
    value = value.copyWith(
      position: position,
      isCompleted: position == value.duration,
    );
    if (_player.seekBuffer case final buffer?) {
      value = value.copyWith(isBuffering: true);
      unawaited(_bufferUntil(buffer.future));
    }
  }

  Future<void> _bufferUntil(Future<void> buffered) async {
    await buffered;
    if (!disposed) value = value.copyWith(isBuffering: false);
  }

  @override
  Future<void> dispose() async {
    disposed = true;
    await super.dispose();
  }
}
