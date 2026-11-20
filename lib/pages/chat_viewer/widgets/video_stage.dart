import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/providers.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/chat_viewer/video_phase.dart';
import 'package:fujin/pages/chat_viewer/widgets/viewer_veil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:motor/motor.dart';
import 'package:video_player/video_player.dart';

class VideoStage extends HookConsumerWidget {
  const VideoStage({
    required this.url,
    required this.controller,
    required this.phase,
    required this.onRetry,
    super.key,
  });

  static const bufferingGrace = Duration(seconds: 1);
  static const skipBy = Duration(seconds: 10);
  static const double _thirds = 3;
  static const Alignment _backBadge = Alignment(-0.6, 0);
  static const Alignment _forwardBadge = Alignment(0.6, 0);

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
          VideoPhase.buffering => _BufferingVeil(
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
    final skip = useState<int?>(null);
    final forward = useRef(true);
    final tapped = useRef(Offset.zero);
    useEffect(() {
      if (skip.value == null) return null;
      final fade = Timer(FujinMotion.seekBadge, () => skip.value = null);
      return fade.cancel;
    }, [skip.value]);

    void jump({required bool ahead}) {
      final video = playing;
      if (video == null) return;
      final value = video.value;
      final target =
          value.position +
          switch (ahead) {
            true => skipBy,
            false => -skipBy,
          };
      unawaited(
        video.seekTo(
          Duration(
            microseconds: target.inMicroseconds.clamp(
              0,
              value.duration.inMicroseconds,
            ),
          ),
        ),
      );
      forward.value = ahead;
      skip.value = (skip.value ?? 0) + 1;
    }

    void doubleTap() {
      final third = (context.size?.width ?? 0) / _thirds;
      switch (tapped.value.dx) {
        case final x when x < third:
          jump(ahead: false);
        case final x when x > third * (_thirds - 1):
          jump(ahead: true);
      }
    }

    final seekable = switch (phase) {
      VideoPhase.ready || VideoPhase.buffering => true,
      VideoPhase.loading || VideoPhase.failed || null => false,
    };

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onDoubleTapDown: seekable
          ? (details) => tapped.value = details.localPosition
          : null,
      onDoubleTap: seekable ? doubleTap : null,
      child: Stack(
        fit: StackFit.expand,
        children: [
          switch (aspectRatio) {
            final aspectRatio? => Center(
              child: AspectRatio(aspectRatio: aspectRatio, child: stage),
            ),
            null => stage,
          },
          Align(
            alignment: switch (forward.value) {
              true => _forwardBadge,
              false => _backBadge,
            },
            child: _SkipBadge(
              shown: skip.value != null,
              label: switch (forward.value) {
                true => context.intl.chatViewerSkipForward(skipBy.inSeconds),
                false => context.intl.chatViewerSkipBack(skipBy.inSeconds),
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SkipBadge extends StatelessWidget {
  const _SkipBadge({required this.shown, required this.label});

  final bool shown;
  final String label;

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: SingleMotionBuilder(
      motion: FujinMotion.dissolve,
      value: switch (shown) {
        true => 1.0,
        false => 0.0,
      },
      builder: (context, opacity, child) =>
          Opacity(opacity: opacity.clamp(0, 1), child: child),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.colors.cameraButton,
          borderRadius: BorderRadius.circular(FujinRadius.pill),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: FujinSpace.s3,
            vertical: FujinSpace.s2,
          ),
          child: Text(
            label,
            style: FujinText.inter15Medium.copyWith(
              color: context.colors.cameraText,
            ),
          ),
        ),
      ),
    ),
  );
}

class _BufferingVeil extends HookWidget {
  const _BufferingVeil({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final lasting = useState(false);
    useEffect(() {
      final grace = Timer(
        VideoStage.bufferingGrace,
        () => lasting.value = true,
      );
      return grace.cancel;
    }, const []);
    return switch (lasting.value) {
      true => ViewerVeil.loading(title: title),
      false => const SizedBox.shrink(),
    };
  }
}
