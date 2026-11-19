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

  @override
  Future<void> play() async => value = value.copyWith(isPlaying: true);

  @override
  Future<void> pause() async => value = value.copyWith(isPlaying: false);

  @override
  Future<void> setVolume(double volume) async =>
      value = value.copyWith(volume: volume);

  @override
  Future<void> seekTo(Duration position) async =>
      value = value.copyWith(position: position);

  @override
  Future<void> dispose() async {
    disposed = true;
    await super.dispose();
  }
}
