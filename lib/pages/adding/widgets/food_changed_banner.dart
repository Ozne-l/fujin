import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';
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
    return InfoBanner(
      icon: Icon(
        Icons.refresh,
        size: FujinSize.searchIcon,
        color: context.colors.textOnDark,
      ),
      title: context.intl.addFoodChangedTitle,
      detail: context.intl.addFoodChangedDetail(before, after, serving),
    );
  }
}
