import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/title_text.dart';

class JournalHeader extends StatelessWidget {
  const JournalHeader({
    required this.day,
    required this.today,
    this.link,
    super.key,
  });

  final DateTime day;
  final DateTime today;
  final (String, VoidCallback)? link;

  @override
  Widget build(BuildContext context) {
    final title = switch (day == today) {
      true => context.intl.journalToday,
      false => TitleText.capitalized(context.intl.journalMonth(day)),
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
            context.intl.appName,
            style: FujinText.hina22.copyWith(color: FujinColorRole.textLink),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: FujinSize.touchTarget,
            ),
            child: OverflowBar(
              alignment: MainAxisAlignment.spaceBetween,
              overflowAlignment: OverflowBarAlignment.end,
              spacing: FujinSpace.s3,
              children: [
                Text(
                  title,
                  style: FujinText.hina30.copyWith(
                    color: FujinColorRole.textPrimary,
                  ),
                ),
                if (link case (final label, final onTap))
                  TextButton(
                    onPressed: onTap,
                    style: TextButton.styleFrom(
                      textStyle: FujinText.inter13Medium,
                      padding: EdgeInsets.zero,
                    ),
                    child: Text(label),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
