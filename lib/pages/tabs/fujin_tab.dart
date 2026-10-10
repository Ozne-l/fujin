import 'package:fujin/l10n/generated/app_localizations.dart';

enum FujinTab {
  journal('assets/icons/book.svg'),
  memory('assets/icons/link.svg'),
  settings('assets/icons/sliders.svg');

  const FujinTab(this.icon);

  final String icon;

  String label(AppLocalizations l10n) => switch (this) {
    FujinTab.journal => l10n.tabJournal,
    FujinTab.memory => l10n.tabMemory,
    FujinTab.settings => l10n.tabSettings,
  };
}
