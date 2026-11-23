import 'package:fujin/pages/journal/background_write_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract final class RowWrite {
  static ({bool mfpFailed, bool failed, bool sending, bool removing}) watch(
    WidgetRef ref,
    String id,
  ) {
    return ref.watch(
      backgroundWriteProvider.select(
        (state) => (
          mfpFailed: state.mfpFailedIds.contains(id),
          failed: state.failedIds.contains(id),
          sending: state.ekkloSendIds.contains(id),
          removing: state.ekkloRemovalIds.contains(id),
        ),
      ),
    );
  }
}
