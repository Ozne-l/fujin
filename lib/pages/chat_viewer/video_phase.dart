import 'package:video_player/video_player.dart';

enum VideoPhase {
  loading,
  ready,
  failed;

  static VideoPhase of(VideoPlayerValue value, {required bool failed}) =>
      switch ((failed, value)) {
        (true, _) || (_, VideoPlayerValue(hasError: true)) => VideoPhase.failed,
        (_, VideoPlayerValue(isInitialized: false)) ||
        (_, VideoPlayerValue(isBuffering: true)) => VideoPhase.loading,
        _ => VideoPhase.ready,
      };
}
