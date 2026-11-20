import 'package:flutter/widgets.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/chat/chat_files.dart';
import 'package:fujin/pages/chat_viewer/widgets/viewer_veil.dart';
import 'package:fujin/pages/chat_viewer/widgets/viewer_zoom.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PhotoStage extends ConsumerWidget {
  const PhotoStage({required this.url, required this.onZoomed, super.key});

  final Uri url;
  final ValueChanged<bool> onZoomed;

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      switch (ref.watch(chatFileProvider(url))) {
        AsyncValue(value: final file?) => ViewerZoom(
          onZoomed: onZoomed,
          child: Center(
            child: Image.file(
              file,
              fit: BoxFit.contain,
              semanticLabel: context.intl.chatPhoto,
            ),
          ),
        ),
        AsyncValue(isLoading: true) => const ViewerVeil.loading(),
        AsyncValue(hasError: true) => ViewerVeil.failed(
          onRetry: () => ref.invalidate(chatFileProvider(url)),
        ),
        AsyncValue() => const ViewerVeil.loading(),
      };
}
