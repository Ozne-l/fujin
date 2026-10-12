import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';

class FoodChangedBanner extends StatelessWidget {
  const FoodChangedBanner({
    required this.before,
    required this.after,
    required this.serving,
    super.key,
  });

  final double before;
  final double after;
  final String serving;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: FujinSize.screenMargin),
      padding: const EdgeInsets.all(FujinSpace.s3),
      decoration: BoxDecoration(
        color: FujinColorRole.backgroundInfo,
        borderRadius: BorderRadius.circular(FujinRadius.field),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: FujinSpace.s3,
        children: [
          const CircleAvatar(
            radius: FujinSize.tile / 2,
            backgroundColor: FujinColorRole.textInfo,
            child: Icon(
              Icons.refresh,
              size: FujinSize.searchIcon,
              color: FujinColorRole.textOnDark,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: FujinSpace.s1,
              children: [
                Text(
                  l10n.addFoodChangedTitle,
                  style: FujinText.inter15Medium.copyWith(
                    color: FujinColorRole.textPrimary,
                  ),
                ),
                Text(
                  l10n.addFoodChangedDetail(before, after, serving),
                  style: FujinText.inter13Regular.copyWith(
                    color: FujinColorRole.textInfo,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
