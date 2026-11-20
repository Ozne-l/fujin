import 'dart:async';

import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/providers.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_system_bars.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/chat/person_name.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/chat/widgets/chat_media_hero.dart';
import 'package:fujin/pages/chat/widgets/media_gallery.dart';
import 'package:fujin/pages/chat_viewer/chat_viewer_read.dart';
import 'package:fujin/pages/chat_viewer/chat_viewer_text.dart';
import 'package:fujin/pages/chat_viewer/video_phase.dart';
import 'package:fujin/pages/chat_viewer/widgets/page_dots.dart';
import 'package:fujin/pages/chat_viewer/widgets/photo_stage.dart';
import 'package:fujin/pages/chat_viewer/widgets/video_controls.dart';
import 'package:fujin/pages/chat_viewer/widgets/video_stage.dart';
import 'package:fujin/pages/chat_viewer/widgets/viewer_dismiss.dart';
import 'package:fujin/pages/chat_viewer/widgets/viewer_header.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:motor/motor.dart';
import 'package:video_player/video_player.dart';

class ChatViewerPage extends HookConsumerWidget {
  const ChatViewerPage({
    required this.conversationId,
    required this.messageId,
    required this.initialIndex,
    super.key,
  });

  final String conversationId;
  final String messageId;
  final int initialIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final travel = useValueNotifier<double>(0);
    final read = switch (ref.watch(conversationProvider(conversationId))) {
      AsyncValue(value: final state?) => ChatViewerRead.of(state, messageId),
      AsyncValue() => null,
    };
    final colors = context.colors;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: FujinSystemBars.camera(colors),
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            Positioned.fill(
              child: ValueListenableBuilder<double>(
                valueListenable: travel,
                builder: (context, offset, child) => ColoredBox(
                  color: colors.cameraBackground.withValues(
                    alpha: ViewerDismiss.backdropOf(
                      offset,
                      MediaQuery.sizeOf(context).width,
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: switch (read) {
                final read? => _Viewer(
                  read: read,
                  messageId: messageId,
                  initialIndex: initialIndex,
                  travel: travel,
                ),
                null => Align(
                  alignment: Alignment.topCenter,
                  child: ViewerHeader(
                    title: '',
                    moment: '',
                    onClose: () => context.pop(),
                  ),
                ),
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Viewer extends HookConsumerWidget {
  const _Viewer({
    required this.read,
    required this.messageId,
    required this.initialIndex,
    required this.travel,
  });

  static const double _silent = 0;
  static const double _sound = 1;

  final ChatViewerRead read;
  final String messageId;
  final int initialIndex;
  final ValueNotifier<double> travel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = read.media.length;
    final last = count - 1;
    final start = initialIndex.clamp(0, last);
    final pages = usePageController(initialPage: start);
    final selected = useState(start);
    final index = selected.value.clamp(0, last);
    final chrome = useState(true);
    final zoomed = useState(false);
    final dragging = useState(false);
    final touches = useState(0);
    final muted = useState(false);
    final attempt = useState(0);
    final failed = useState<VideoPlayerController?>(null);
    final media = read.media[index];
    final video = ref.watch(urlVideoProvider);
    final controller = useMemoized(
      () => switch (media.kind) {
        EkkloMediaKind.video => video(media.url),
        EkkloMediaKind.image || EkkloMediaKind.voice => null,
      },
      [media.url, media.kind, attempt.value],
    );
    useEffect(() {
      if (controller == null) return null;
      var open = true;
      Future<void> start() async {
        try {
          await controller.initialize();
          if (open) await controller.play();
        } on Exception {
          if (open) failed.value = controller;
        }
      }

      unawaited(start());
      return () {
        open = false;
        unawaited(controller.dispose());
      };
    }, [controller]);
    useEffect(() {
      if (controller != null) {
        unawaited(controller.setVolume(muted.value ? _silent : _sound));
      }
      return null;
    }, [controller, muted.value]);
    final value = useListenable(controller)?.value;
    final phase = switch ((controller, value)) {
      (final controller?, final value?) => VideoPhase.of(
        value,
        failed: failed.value == controller,
      ),
      _ => null,
    };
    final playing = value?.isPlaying ?? false;
    useEffect(() {
      if (!chrome.value || !playing) return null;
      final idle = Timer(FujinMotion.viewerIdle, () => chrome.value = false);
      return idle.cancel;
    }, [chrome.value, playing, touches.value]);
    final now = ref.watch(clockProvider)();
    final single = count == 1;
    final radius = MediaGallery.radiusOf(single: single);

    Widget pageOf(int page) {
      final item = read.media[page];
      final moving = item.kind == EkkloMediaKind.video;
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: FujinSize.viewerPageGap / 2,
        ),
        child: ChatMediaHero(
          messageId: messageId,
          index: page,
          url: item.url,
          video: moving,
          thumb: MediaGallery.sizeOf(video: moving, single: single),
          radius: radius,
          child: switch (moving) {
            true => VideoStage(
              url: item.url,
              controller: page == index ? controller : null,
              phase: page == index ? phase : null,
              onRetry: () {
                failed.value = null;
                attempt.value++;
              },
            ),
            false => PhotoStage(
              url: item.url,
              onZoomed: (now) => zoomed.value = now,
            ),
          },
        ),
      );
    }

    return Listener(
      onPointerDown: (event) => touches.value++,
      child: Column(
        children: [
          _Chrome(
            shown: chrome.value && !dragging.value,
            child: ViewerHeader(
              title: switch (read) {
                ChatViewerRead(mine: true) => context.intl.chatViewerYou,
                ChatViewerRead(:final coach) =>
                  personName(coach) ?? context.intl.chatCoach,
              },
              moment: ChatViewerText.moment(
                context.intl,
                read.createdAt,
                now: now,
                index: index,
                count: count,
              ),
              onClose: () => context.pop(),
            ),
          ),
          Expanded(
            child: ViewerDismiss(
              enabled: !zoomed.value,
              travel: travel,
              onDragging: (now) => dragging.value = now,
              onDismiss: () => context.pop(),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => chrome.value = !chrome.value,
                child: LayoutBuilder(
                  builder: (context, box) => OverflowBox(
                    minWidth: box.maxWidth + FujinSize.viewerPageGap,
                    maxWidth: box.maxWidth + FujinSize.viewerPageGap,
                    child: PageView.builder(
                      controller: pages,
                      physics: zoomed.value
                          ? const NeverScrollableScrollPhysics()
                          : null,
                      itemCount: count,
                      onPageChanged: (page) => selected.value = page,
                      itemBuilder: (context, page) => pageOf(page),
                    ),
                  ),
                ),
              ),
            ),
          ),
          _Chrome(
            shown: !dragging.value,
            child: Column(
              children: [
                if (count > 1)
                  Padding(
                    padding: const EdgeInsets.only(top: FujinSpace.s4),
                    child: PageDots(count: count, index: index),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    FujinSize.screenMargin,
                    FujinSpace.s6,
                    FujinSize.screenMargin,
                    FujinSpace.s8,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      read.caption,
                      style: FujinText.inter15Regular.copyWith(
                        color: context.colors.cameraText,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: FujinSize.searchField,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: FujinSize.screenMargin,
              ),
              child: switch ((controller, value, phase)) {
                (
                  final controller?,
                  final value?,
                  VideoPhase.ready || VideoPhase.buffering,
                ) =>
                  _Chrome(
                    shown: chrome.value && !dragging.value,
                    child: VideoControls(
                      value: value,
                      muted: muted.value,
                      onPlay: () => unawaited(controller.play()),
                      onPause: () => unawaited(controller.pause()),
                      onSeek: controller.seekTo,
                      onMute: (mute) => muted.value = mute,
                    ),
                  ),
                _ => const SizedBox.shrink(),
              },
            ),
          ),
          const SizedBox(height: FujinSize.cameraActionGap),
        ],
      ),
    );
  }
}

class _Chrome extends StatelessWidget {
  const _Chrome({required this.shown, required this.child});

  final bool shown;
  final Widget child;

  @override
  Widget build(BuildContext context) => IgnorePointer(
    ignoring: !shown,
    child: SingleMotionBuilder(
      motion: FujinMotion.dissolve,
      value: switch (shown) {
        true => 1.0,
        false => 0.0,
      },
      builder: (context, opacity, child) =>
          Opacity(opacity: opacity.clamp(0, 1), child: child),
      child: child,
    ),
  );
}
