import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/providers.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/data/media/forget_file.dart';
import 'package:fujin/data/media/picked_media.dart';
import 'package:fujin/domain/chat/edit/edited_media.dart';
import 'package:fujin/domain/chat/edit/media_send.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/chat_media/chat_media_icon.dart';
import 'package:fujin/pages/chat_media/media_reply.dart';
import 'package:fujin/pages/chat_media/media_tray_notifier.dart';
import 'package:fujin/pages/chat_media/photo_editor_page.dart';
import 'package:fujin/pages/chat_media/video_editor_page.dart';
import 'package:fujin/pages/chat_media/widgets/caption_bar.dart';
import 'package:fujin/pages/chat_media/widgets/discard_sheet.dart';
import 'package:fujin/pages/chat_media/widgets/media_glyph.dart';
import 'package:fujin/pages/chat_media/widgets/media_strip.dart';
import 'package:fujin/pages/chat_media/widgets/tray_preview.dart';
import 'package:fujin/pages/chat_media/widgets/tray_reply_card.dart';
import 'package:fujin/pages/common/fade_through.dart';
import 'package:fujin/pages/common/fujin_icon_button.dart';
import 'package:fujin/pages/common/glass_fill.dart';
import 'package:fujin/pages/common/glass_finish.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MediaTrayPage extends HookConsumerWidget {
  const MediaTrayPage({
    required this.coach,
    required this.reply,
    required this.picked,
    required this.onSend,
    super.key,
  });

  final String coach;
  final MediaReply? reply;
  final List<PickedMedia> picked;
  final ValueChanged<MediaSend> onSend;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tray = ref.watch(mediaTrayProvider);
    final notifier = ref.read(mediaTrayProvider.notifier);
    final caption = useTextEditingController();
    useListenable(caption);
    final replying = useState(reply);
    final sent = useRef(false);
    final colors = context.colors;
    final intl = context.intl;
    final navigator = Navigator.of(context);

    useEffect(() {
      Future<void> load() async {
        await notifier.add(picked);
        if (context.mounted && ref.read(mediaTrayProvider).media.isEmpty) {
          navigator.pop();
        }
      }

      WidgetsBinding.instance.addPostFrameCallback((_) => unawaited(load()));
      return null;
    }, const []);

    void close() {
      switch (tray.isDirty(caption.text)) {
        case true:
          unawaited(showDiscardSheet(context, onDiscard: navigator.pop));
        case false:
          navigator.pop();
      }
    }

    Future<void> open(int index) async {
      final media = tray.media[index];
      final flight = switch (FujinMotion.reduced(context)) {
        true => FujinMotion.effectsFast,
        false => FujinMotion.flight,
      };
      final edited = await navigator.push<EditedMedia>(
        PageRouteBuilder(
          transitionDuration: flight.duration,
          reverseTransitionDuration: flight.duration,
          transitionsBuilder: (context, animation, secondary, child) =>
              FadeTransition(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: flight.curve,
                ),
                child: child,
              ),
          pageBuilder: (context, animation, secondary) => switch (media) {
            final EditedPhoto photo => PhotoEditorPage(
              photo: photo,
              position: index + 1,
              count: tray.media.length,
            ),
            final EditedVideo video => VideoEditorPage(
              video: video,
              position: index + 1,
              count: tray.media.length,
            ),
          },
        ),
      );
      if (edited != null && context.mounted) notifier.replace(index, edited);
    }

    Future<void> addMore() async {
      try {
        final more = await ref
            .read(mediaPickerProvider)
            .gallery(limit: tray.room);
        switch (context.mounted) {
          case true:
            await notifier.add(more);
          case false:
            for (final media in more) {
              unawaited(forgetFile(media.path));
            }
        }
      } on PlatformException {
        return;
      }
    }

    void send() {
      sent.value = true;
      onSend(
        notifier.send(
          caption: caption.text,
          replyToId: replying.value?.messageId,
        ),
      );
      navigator.pop();
    }

    void remove(int index) {
      if (tray.media.length == 1) {
        navigator.pop();
        return;
      }
      notifier.remove(index);
    }

    final shown = tray.shown;
    return PopScope<Object?>(
      canPop: !tray.isDirty(caption.text),
      onPopInvokedWithResult: (didPop, result) {
        switch ((didPop, sent.value)) {
          case (true, false):
            notifier.discard();
          case (true, true):
            return;
          case (false, _):
            close();
        }
      },
      child: Scaffold(
        backgroundColor: colors.backgroundPage,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: FujinSpace.s1),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: FujinSize.screenMargin,
                ),
                child: Row(
                  spacing: FujinSpace.s3,
                  children: [
                    FujinIconButton(
                      icon: Icons.close,
                      tooltip: intl.close,
                      floating: true,
                      onPressed: close,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: FujinSize.textGap,
                        children: [
                          FadeThrough(
                            scale: 1,
                            child: Text(
                              intl.chatTrayCount(tray.media.length),
                              key: ValueKey(tray.media.length),
                              style: FujinText.inter16Medium.copyWith(
                                color: colors.textPrimary,
                              ),
                            ),
                          ),
                          Text(
                            intl.chatTrayFor(coach),
                            style: FujinText.inter13Regular.copyWith(
                              color: colors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    if (shown != null)
                      FilledButton.icon(
                        onPressed: () => unawaited(open(tray.selected)),
                        icon: MediaGlyph(
                          switch (shown) {
                            EditedPhoto() => ChatMediaIcon.crop,
                            EditedVideo() => ChatMediaIcon.scissors,
                          },
                          size: FujinSize.tileIcon,
                          color: colors.textPrimary,
                        ),
                        label: Text(intl.chatTrayEdit),
                        style: GlassFill.style(colors, GlassFinish.clear).merge(
                          FilledButton.styleFrom(
                            minimumSize: const Size(
                              0,
                              FujinSize.buttonCompact,
                            ),
                            tapTargetSize: MaterialTapTargetSize.padded,
                            padding: const EdgeInsets.symmetric(
                              horizontal: FujinSpace.s4,
                            ),
                            textStyle: FujinText.inter14Medium,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: FujinSpace.s4),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: FujinSize.screenMargin,
                  ),
                  child: FadeThrough(
                    child: switch (shown) {
                      final shown? => TrayPreview(
                        key: ValueKey(shown.path),
                        media: shown,
                        onOpen: () => unawaited(open(tray.selected)),
                      ),
                      null => const SizedBox.shrink(),
                    },
                  ),
                ),
              ),
              const SizedBox(height: FujinSpace.s4),
              MediaStrip(
                media: tray.media,
                selected: tray.selected,
                onSelected: notifier.select,
                onRemoved: remove,
                onAdd: switch (tray.isFull) {
                  true => null,
                  false => () => unawaited(addMore()),
                },
              ),
              if (tray.isFull)
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    FujinSize.screenMargin,
                    FujinSize.trayLimitGap,
                    FujinSize.screenMargin,
                    0,
                  ),
                  child: Text(
                    intl.chatTrayLimit(MediaSend.maximumMedia),
                    style: FujinText.inter12Regular.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ),
              if (replying.value case final reply?)
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    FujinSize.screenMargin,
                    FujinSpace.s3,
                    FujinSize.screenMargin,
                    0,
                  ),
                  child: TrayReplyCard(
                    reply: reply,
                    onCancel: () => replying.value = null,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  FujinSize.screenMargin,
                  FujinSpace.s2,
                  FujinSize.screenMargin,
                  FujinSpace.s2,
                ),
                child: CaptionBar(
                  controller: caption,
                  onSend: switch (tray.media.isEmpty) {
                    true => null,
                    false => send,
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
