import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:video_player/video_player.dart';

typedef UrlVideo = VideoPlayerController Function(Uri url);

final urlVideoProvider = Provider<UrlVideo>(
  (ref) => VideoPlayerController.networkUrl,
);
