import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';

class UnavailableMealCard extends StatelessWidget {
  const UnavailableMealCard({
    required this.name,
    required this.kilocalories,
    super.key,
  });

  final String name;
  final double kilocalories;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: FujinSize.screenMargin),
      padding: const EdgeInsets.all(FujinSpace.s5),
      decoration: BoxDecoration(
        color: FujinColorRole.backgroundCard,
        borderRadius: BorderRadius.circular(FujinRadius.card),
        border: Border.all(color: FujinColorRole.borderCard),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: FujinSpace.s3,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: FujinSpace.s2,
              children: [
                Text(
                  name,
                  style: FujinText.inter16Medium.copyWith(
                    color: FujinColorRole.textPrimary,
                  ),
                ),
                Text(
                  context.intl.ekkloUnavailable,
                  style: FujinText.inter13Regular.copyWith(
                    color: FujinColorRole.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            context.intl.kilocalories(kilocalories),
            style: FujinText.inter15Semibold.copyWith(
              color: FujinColorRole.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
