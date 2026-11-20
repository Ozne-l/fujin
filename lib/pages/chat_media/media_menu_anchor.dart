import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/providers.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_theme.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/data/media/picked_media.dart';
import 'package:fujin/domain/chat/edit/media_send.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/chat_media/chat_media_icon.dart';
import 'package:fujin/pages/chat_media/media_reply.dart';
import 'package:fujin/pages/chat_media/media_tray_page.dart';
import 'package:fujin/pages/chat_media/widgets/media_glyph.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:motor/motor.dart';

class MediaMenuAnchor extends HookConsumerWidget {
  const MediaMenuAnchor({
    required this.coach,
    required this.reply,
    required this.onSend,
    required this.builder,
    super.key,
  });

  static const double _overhang = FujinSpace.s2;
  static const double _gap = FujinSpace.s3;
  static const double _foldedScale = 0.96;

  final String coach;
  final MediaReply? reply;
  final ValueChanged<MediaSend> onSend;
  final Widget Function(BuildContext context, VoidCallback open) builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useMemoized(MenuController.new);
    final expanded = useState(false);
    final pendingHide = useRef<VoidCallback?>(null);
    final busy = useRef(false);

    Future<void> openTray(List<PickedMedia> picked) async {
      if (picked.isEmpty || !context.mounted) return;
      busy.value = true;
      await Navigator.of(context, rootNavigator: true).push<void>(
        MaterialPageRoute(
          builder: (context) => MediaTrayPage(
            coach: coach,
            reply: reply,
            picked: picked,
            onSend: onSend,
          ),
        ),
      );
      busy.value = false;
    }

    Future<void> pick(_Source source) async {
      if (busy.value) return;
      final picker = ref.read(mediaPickerProvider);
      try {
        final picked = switch (source) {
          _Source.gallery => await picker.gallery(
            limit: MediaSend.maximumMedia,
          ),
          _Source.photo => [?await picker.photo()],
          _Source.video => [?await picker.video()],
        };
        await openTray(picked);
      } on PlatformException {
        return;
      }
    }

    useEffect(() {
      Future<void> recover() async {
        try {
          await openTray(await ref.read(mediaPickerProvider).lost());
        } on PlatformException {
          return;
        }
      }

      unawaited(recover());
      return null;
    }, const []);

    void open() {
      switch ((controller.isOpen, expanded.value)) {
        case (true, true):
          controller.close();
        case (true, false):
          pendingHide.value = null;
          expanded.value = true;
        case (false, _):
          controller.open();
      }
    }

    void choose(_Source source) {
      controller.close();
      unawaited(pick(source));
    }

    void settle(AnimationStatus status) {
      if (!status.isDismissed) return;
      final hide = pendingHide.value;
      pendingHide.value = null;
      hide?.call();
    }

    Future<bool> back() async {
      if (!expanded.value) return false;
      controller.close();
      return true;
    }

    return RawMenuAnchor(
      controller: controller,
      useRootOverlay: true,
      consumeOutsideTaps: true,
      onOpenRequested: (position, showOverlay) {
        pendingHide.value = null;
        expanded.value = true;
        showOverlay();
      },
      onCloseRequested: (hideOverlay) {
        pendingHide.value = hideOverlay;
        expanded.value = false;
      },
      overlayBuilder: (context, info) {
        final anchor = info.anchorRect;
        final overlay = info.overlaySize;
        final right = math.min(
          anchor.right + _overhang,
          overlay.width - FujinSize.screenMargin,
        );
        return BackButtonListener(
          onBackButtonPressed: back,
          child: Stack(
            children: [
              Positioned(
                left: math.max(
                  FujinSize.screenMargin,
                  right - FujinSize.contextMenuWidth,
                ),
                bottom: overlay.height - anchor.top + _gap,
                width: FujinSize.contextMenuWidth,
                child: TapRegion(
                  groupId: info.tapRegionGroupId,
                  onTapOutside: (event) => controller.close(),
                  child: SingleMotionBuilder(
                    motion: FujinMotion.of(context, FujinMotion.mealFold),
                    from: 0,
                    value: switch (expanded.value) {
                      true => 1,
                      false => 0,
                    },
                    onAnimationStatusChanged: settle,
                    builder: (context, fold, child) => Opacity(
                      opacity: fold.clamp(0, 1),
                      child: Transform.scale(
                        scaleY: lerpDouble(_foldedScale, 1, fold),
                        alignment: Alignment.bottomCenter,
                        child: child,
                      ),
                    ),
                    child: _Panel(onChosen: choose),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      builder: (context, _, _) => builder(context, open),
    );
  }
}

enum _Source {
  gallery(ChatMediaIcon.image),
  photo(ChatMediaIcon.camera),
  video(ChatMediaIcon.video);

  const _Source(this.icon);

  final String icon;

  String label(AppLocalizations intl) => switch (this) {
    gallery => intl.chatMediaMenuGallery,
    photo => intl.chatMediaMenuPhoto,
    video => intl.chatMediaMenuVideo,
  };
}

class _Panel extends StatelessWidget {
  const _Panel({required this.onChosen});

  final ValueChanged<_Source> onChosen;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = BorderRadius.circular(FujinRadius.menu);
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.backgroundCard,
        borderRadius: radius,
        boxShadow: [FujinTheme.floatingShadow(colors)],
      ),
      foregroundDecoration: BoxDecoration(
        borderRadius: radius,
        border: Border.all(color: colors.borderCard),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final (index, source) in _Source.values.indexed) ...[
              if (index > 0)
                Divider(height: FujinStroke.card, color: colors.borderDivider),
              Semantics(
                button: true,
                child: InkWell(
                  onTap: () => onChosen(source),
                  child: SizedBox(
                    height: FujinSize.touchTarget,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: FujinSpace.s4,
                      ),
                      child: Row(
                        spacing: FujinSpace.s3,
                        children: [
                          MediaGlyph(
                            source.icon,
                            size: FujinSize.contextMenuIcon,
                            color: colors.textPrimary,
                          ),
                          Expanded(
                            child: Text(
                              source.label(context.intl),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: FujinText.inter15Medium.copyWith(
                                color: colors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
