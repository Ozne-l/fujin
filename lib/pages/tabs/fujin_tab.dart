import 'package:fujin/l10n/generated/app_localizations.dart';

enum FujinTab {
  journal('assets/icons/book.svg'),
  memory('assets/icons/link.svg'),
  settings('assets/icons/sliders.svg');

  const FujinTab(this.icon);

  final String icon;

  String label(AppLocalizations intl) => switch (this) {
    FujinTab.journal => intl.tabJournal,
    FujinTab.memory => intl.tabMemory,
    FujinTab.settings => intl.tabSettings,
  };
}
