import 'package:video_player/video_player.dart';

enum VideoPhase {
  loading,
  buffering,
  ready,
  failed;

  static VideoPhase of(VideoPlayerValue value, {required bool failed}) =>
      switch ((failed, value)) {
        (true, _) || (_, VideoPlayerValue(hasError: true)) => VideoPhase.failed,
        (_, VideoPlayerValue(isInitialized: false)) => VideoPhase.loading,
        (_, VideoPlayerValue(isCompleted: false, isBuffering: true)) =>
          VideoPhase.buffering,
        _ => VideoPhase.ready,
      };
}
