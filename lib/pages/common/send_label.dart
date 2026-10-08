import 'package:fujin/l10n/generated/app_localizations.dart';

abstract final class SendLabel {
  static String? of(AppLocalizations l10n, int send, int update) =>
      switch ((send, update)) {
        (0, 0) => null,
        (final send, 0) => l10n.sendFoods(send),
        (0, final update) => l10n.updateFoods(update),
        (final send, final update) => l10n.sendAndUpdateFoods(send, update),
      };
}
