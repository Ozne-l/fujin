import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/common/entry_text.dart';

class JournalHeader extends StatelessWidget {
  const JournalHeader({required this.day, required this.today, super.key});

  final DateTime day;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = switch (day == today) {
      true => l10n.journalToday,
      false => EntryText.capitalized(l10n.journalDay(day)),
    };
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        start: FujinSize.textInset,
        end: FujinSize.textInset,
        top: FujinSpace.s4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: FujinSpace.s4,
        children: [
          Text(
            l10n.appName,
            style: FujinText.hina22.copyWith(color: FujinColorRole.textLink),
          ),
          Text(
            title,
            style: FujinText.hina30.copyWith(color: FujinColorRole.textPrimary),
          ),
        ],
      ),
    );
  }
}
