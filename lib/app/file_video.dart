import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:video_player/video_player.dart';

typedef FileVideo = VideoPlayerController Function(File file);

final fileVideoProvider = Provider<FileVideo>(
  (ref) => VideoPlayerController.file,
);
