import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/sending/send_report.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/title_text.dart';
import 'package:fujin/pages/sending/send_text.dart';
import 'package:fujin/pages/sending/widgets/sent_frame.dart';

class SentView extends StatelessWidget {
  const SentView({required this.report, super.key});

  final SendReport report;

  @override
  Widget build(BuildContext context) {
    final rows = _rows(context.intl, context.colors);
    return SentFrame(
      report: report,
      note: TitleText.capitalized(
        context.intl.sentAt(report.date, report.sentAt),
      ),
      children: [
        if (rows.isNotEmpty) ...[
          const SizedBox(height: FujinSpace.s3),
          SentFrame.card(
            context.colors,
            rows,
            dividerIndent: FujinSize.tile + FujinSpace.s3,
          ),
        ],
      ],
    );
  }

  List<_Row> _rows(AppLocalizations intl, FujinColors colors) {
    final separator = intl.listSeparator;
    return [
      if (report.reused > 0)
        _Row(
          label: intl.sentReused(report.reused),
          tile: colors.backgroundSuccess,
          icon: Icons.refresh,
          iconColor: colors.textLink,
        ),
      if (report.newAssociations case final names when names.isNotEmpty)
        _Row(
          label: intl.sentAssociations(names.length, names.join(separator)),
          tile: colors.backgroundHighlight,
          icon: Icons.auto_awesome_outlined,
          iconColor: colors.textGold,
        ),
      if (report.weights case final weights when weights.isNotEmpty)
        _Row(
          label: intl.sentWeights(
            weights.length,
            weights
                .map(
                  (weight) => intl.unitWeight(
                    weight.unit,
                    SendText.grams(intl, weight.grams),
                  ),
                )
                .join(separator),
          ),
          tile: colors.backgroundNeutral,
          icon: Icons.scale_outlined,
          iconColor: colors.textPrimary,
        ),
      if (report.ownCopies case final names when names.isNotEmpty)
        _Row(
          label: intl.sentOwnCopies(names.length, names.join(separator)),
          tile: colors.backgroundNeutral,
          icon: Icons.add,
          iconColor: colors.textPrimary,
        ),
      if (report.updated > 0)
        _Row(
          label: intl.sentUpdated(report.updated),
          tile: colors.backgroundInfo,
          icon: Icons.refresh,
          iconColor: colors.textInfo,
        ),
    ];
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.label,
    required this.tile,
    required this.icon,
    required this.iconColor,
  });

  final String label;
  final Color tile;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: FujinSpace.s3),
    child: Row(
      spacing: FujinSpace.s3,
      children: [
        Container(
          width: FujinSize.tile,
          height: FujinSize.tile,
          decoration: BoxDecoration(
            color: tile,
            borderRadius: BorderRadius.circular(FujinRadius.tile),
          ),
          child: Icon(icon, size: FujinSize.tileIcon, color: iconColor),
        ),
        Expanded(
          child: Text(
            label,
            style: FujinText.inter14Medium.copyWith(
              color: context.colors.textPrimary,
            ),
          ),
        ),
      ],
    ),
  );
}
