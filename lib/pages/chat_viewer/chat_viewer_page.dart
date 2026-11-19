import 'dart:async';

import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/providers.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_system_bars.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/app/url_video.dart';
import 'package:fujin/domain/chat/person_name.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/chat_viewer/chat_viewer_read.dart';
import 'package:fujin/pages/chat_viewer/chat_viewer_text.dart';
import 'package:fujin/pages/chat_viewer/video_phase.dart';
import 'package:fujin/pages/chat_viewer/widgets/page_dots.dart';
import 'package:fujin/pages/chat_viewer/widgets/photo_stage.dart';
import 'package:fujin/pages/chat_viewer/widgets/video_controls.dart';
import 'package:fujin/pages/chat_viewer/widgets/video_stage.dart';
import 'package:fujin/pages/chat_viewer/widgets/viewer_header.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:motor/motor.dart';
import 'package:video_player/video_player.dart';

class ChatViewerPage extends ConsumerWidget {
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
    final read = switch (ref.watch(conversationProvider(conversationId))) {
      AsyncValue(value: final state?) => ChatViewerRead.of(state, messageId),
      AsyncValue() => null,
    };
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: FujinSystemBars.camera(context.colors),
      child: Scaffold(
        backgroundColor: context.colors.cameraBackground,
        body: SafeArea(
          child: switch (read) {
            final read? => _Viewer(read: read, initialIndex: initialIndex),
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
      ),
    );
  }
}

class _Viewer extends HookConsumerWidget {
  const _Viewer({required this.read, required this.initialIndex});

  static const double _silent = 0;
  static const double _sound = 1;

  final ChatViewerRead read;
  final int initialIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final last = read.media.length - 1;
    final start = initialIndex.clamp(0, last);
    final pages = usePageController(initialPage: start);
    final selected = useState(start);
    final index = selected.value.clamp(0, last);
    final chrome = useState(true);
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
    final now = ref.watch(clockProvider)();

    return Column(
      children: [
        _Chrome(
          shown: chrome.value,
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
              count: read.media.length,
            ),
            onClose: () => context.pop(),
          ),
        ),
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => chrome.value = !chrome.value,
            child: PageView.builder(
              controller: pages,
              itemCount: read.media.length,
              onPageChanged: (page) => selected.value = page,
              itemBuilder: (context, page) => switch (read.media[page]) {
                EkkloMedia(kind: EkkloMediaKind.video, :final url) =>
                  VideoStage(
                    url: url,
                    controller: page == index ? controller : null,
                    phase: page == index ? phase : null,
                    onRetry: () {
                      failed.value = null;
                      attempt.value++;
                    },
                  ),
                EkkloMedia(:final url) => PhotoStage(url: url),
              },
            ),
          ),
        ),
        if (read.media.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: FujinSpace.s4),
            child: PageDots(count: read.media.length, index: index),
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
        SizedBox(
          height: FujinSize.searchField,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: FujinSize.screenMargin,
            ),
            child: switch ((controller, value, phase)) {
              (final controller?, final value?, VideoPhase.ready) => _Chrome(
                shown: chrome.value,
                child: VideoControls(
                  value: value,
                  muted: muted.value,
                  onPlay: () => unawaited(controller.play()),
                  onPause: () => unawaited(controller.pause()),
                  onSeek: (position) => unawaited(controller.seekTo(position)),
                  onMute: (mute) => muted.value = mute,
                ),
              ),
              _ => const SizedBox.shrink(),
            },
          ),
        ),
        const SizedBox(height: FujinSize.cameraActionGap),
      ],
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
      motion: FujinMotion.of(context, FujinMotion.fadeThrough),
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
