import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/common/info_banner.dart';

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
    return InfoBanner(
      icon: const Icon(
        Icons.refresh,
        size: FujinSize.searchIcon,
        color: FujinColorRole.textOnDark,
      ),
      title: l10n.addFoodChangedTitle,
      detail: l10n.addFoodChangedDetail(before, after, serving),
    );
  }
}
