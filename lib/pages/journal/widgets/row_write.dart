import 'package:fujin/app/providers.dart';
import 'package:fujin/pages/journal/background_write_notifier.dart';
import 'package:fujin/pages/journal/writer_state_ids.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract final class RowWrite {
  static ({bool mfpFailed, bool failed, bool sending, bool removing}) watch(
    WidgetRef ref,
    String id,
  ) {
    final environment = ref.watch(appEnvironmentProvider);
    return ref.watch(
      backgroundWriteProvider.select(
        (state) => (
          mfpFailed: state.mfpFailedIds(environment).contains(id),
          failed: state.failedIds(environment).contains(id),
          sending: state.ekkloSendIds.contains(id),
          removing: state.ekkloRemovalIds.contains(id),
        ),
      ),
    );
  }
}
