import 'package:fujin/l10n/generated/app_localizations.dart';

abstract final class SendLabel {
  static String? of(AppLocalizations intl, int send, int update) =>
      switch ((send, update)) {
        (0, 0) => null,
        (final send, 0) => intl.sendFoods(send),
        (0, final update) => intl.updateFoods(update),
        (final send, final update) => intl.sendAndUpdateFoods(send, update),
      };
}
