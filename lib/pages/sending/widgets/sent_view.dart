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
    final rows = _rows(context.intl);
    return SentFrame(
      report: report,
      note: TitleText.capitalized(
        context.intl.sentAt(report.date, report.sentAt),
      ),
      children: [
        if (rows.isNotEmpty) ...[
          const SizedBox(height: FujinSpace.s3),
          SentFrame.card(
            rows,
            dividerIndent: FujinSize.tile + FujinSpace.s3,
          ),
        ],
      ],
    );
  }

  List<_Row> _rows(AppLocalizations intl) {
    final separator = intl.listSeparator;
    return [
      if (report.reused > 0)
        _Row(
          label: intl.sentReused(report.reused),
          tile: FujinColorRole.backgroundSuccess,
          icon: Icons.refresh,
          iconColor: FujinColorRole.textLink,
        ),
      if (report.newAssociations case final names when names.isNotEmpty)
        _Row(
          label: intl.sentAssociations(names.length, names.join(separator)),
          tile: FujinColor.kinLight,
          icon: Icons.auto_awesome_outlined,
          iconColor: FujinColorRole.textGold,
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
          tile: FujinColor.kinari,
          icon: Icons.scale_outlined,
          iconColor: FujinColorRole.textPrimary,
        ),
      if (report.ownCopies case final names when names.isNotEmpty)
        _Row(
          label: intl.sentOwnCopies(names.length, names.join(separator)),
          tile: FujinColor.kinari,
          icon: Icons.add,
          iconColor: FujinColorRole.textPrimary,
        ),
      if (report.updated > 0)
        _Row(
          label: intl.sentUpdated(report.updated),
          tile: FujinColorRole.backgroundInfo,
          icon: Icons.refresh,
          iconColor: FujinColor.sora,
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
              color: FujinColorRole.textPrimary,
            ),
          ),
        ),
      ],
    ),
  );
}
