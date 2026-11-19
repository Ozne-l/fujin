import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/providers.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/chat_viewer/widgets/viewer_veil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PhotoStage extends HookConsumerWidget {
  const PhotoStage({required this.url, super.key});

  final Uri url;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attempt = useState(0);
    final file = useFuture(
      useMemoized(
        () => ref.read(chatMediaCacheProvider).file(url),
        [url, attempt.value],
      ),
    );
    return switch (file) {
      AsyncSnapshot(data: final file?) => Center(
        child: Image.file(
          file,
          fit: BoxFit.contain,
          semanticLabel: context.intl.chatPhoto,
        ),
      ),
      AsyncSnapshot(hasError: true) => ViewerVeil.failed(
        onRetry: () => attempt.value++,
      ),
      AsyncSnapshot() => const ViewerVeil.loading(),
    };
  }
}
