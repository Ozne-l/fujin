import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/providers.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/chat_viewer/video_phase.dart';
import 'package:fujin/pages/chat_viewer/widgets/viewer_veil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:video_player/video_player.dart';

class VideoStage extends HookConsumerWidget {
  const VideoStage({
    required this.url,
    required this.controller,
    required this.phase,
    required this.onRetry,
    super.key,
  });

  final Uri url;
  final VideoPlayerController? controller;
  final VideoPhase? phase;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final poster = useFuture(
      useMemoized(() => ref.read(chatMediaCacheProvider).poster(url), [url]),
    ).data;
    final playing = switch (controller) {
      final controller? when controller.value.isInitialized => controller,
      _ => null,
    };
    final aspectRatio = switch ((playing, poster)) {
      (final playing?, _) => playing.value.aspectRatio,
      (null, final poster?) when poster.height > 0 =>
        poster.width / poster.height,
      _ => null,
    };
    final stage = Stack(
      fit: StackFit.expand,
      children: [
        switch ((playing, poster)) {
          (final playing?, _) => VideoPlayer(playing),
          (null, final poster?) => Image.file(
            poster.file,
            fit: BoxFit.contain,
            excludeFromSemantics: true,
          ),
          (null, null) => const SizedBox.shrink(),
        },
        switch (phase) {
          VideoPhase.loading => ViewerVeil.loading(
            title: context.intl.chatViewerLoading,
          ),
          VideoPhase.failed => ViewerVeil.failed(
            title: context.intl.chatViewerNotLoaded,
            onRetry: onRetry,
          ),
          VideoPhase.ready || null => const SizedBox.shrink(),
        },
      ],
    );
    return switch (aspectRatio) {
      final aspectRatio? => Center(
        child: AspectRatio(aspectRatio: aspectRatio, child: stage),
      ),
      null => stage,
    };
  }
}
