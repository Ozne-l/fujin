import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/data/connectors/connector.dart';
import 'package:fujin/data/weigh_ins/weigh_in.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/connector_pill.dart';
import 'package:fujin/pages/weigh_ins/weigh_in_text.dart';

class WeighInRow extends StatelessWidget {
  const WeighInRow({
    required this.weighIn,
    required this.today,
    required this.owed,
    required this.failed,
    super.key,
  });

  final WeighIn weighIn;
  final DateTime today;
  final List<Connector> owed;
  final Set<Connector> failed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final deleted = weighIn.deletedAt != null;
    final main = switch (deleted) {
      true => colors.textTertiary,
      false => colors.textPrimary,
    };
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: FujinSpace.s5,
        vertical: FujinSpace.s4,
      ),
      child: Row(
        spacing: FujinSpace.s3,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: FujinSpace.s1,
              children: [
                Text(
                  WeighInText.day(context.intl, weighIn.date, today: today),
                  style: FujinText.inter15Regular.copyWith(color: main),
                ),
                if (deleted)
                  Text(
                    context.intl.weighInDeletedInFujin,
                    style: FujinText.inter13Regular.copyWith(
                      color: colors.textTertiary,
                    ),
                  ),
                if (owed.isNotEmpty)
                  Wrap(
                    spacing: FujinSpace.s2,
                    runSpacing: FujinSpace.s1,
                    children: [
                      for (final connector in Connector.values)
                        if (owed.contains(connector))
                          ConnectorPill(
                            connector: connector,
                            failed: failed.contains(connector),
                          ),
                    ],
                  ),
              ],
            ),
          ),
          Text(
            WeighInText.kilograms(context.intl, weighIn.kilograms),
            style: FujinText.inter15Semibold.copyWith(color: main),
          ),
        ],
      ),
    );
  }
}
