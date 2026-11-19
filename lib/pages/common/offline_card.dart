import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';

class OfflineCard extends StatelessWidget {
  const OfflineCard({
    required this.title,
    required this.detail,
    this.onRetry,
    this.margin = const EdgeInsets.symmetric(
      horizontal: FujinSize.screenMargin,
    ),
    super.key,
  });

  final String title;
  final String detail;
  final VoidCallback? onRetry;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: const EdgeInsets.all(FujinSpace.s4),
      decoration: BoxDecoration(
        color: context.colors.borderCard,
        borderRadius: BorderRadius.circular(FujinRadius.card),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: FujinSpace.s3,
        children: [
          CircleAvatar(
            radius: FujinSize.tile / 2,
            backgroundColor: context.colors.backgroundCard,
            child: Icon(
              Icons.wifi_off,
              size: FujinSize.searchIcon,
              color: context.colors.textPrimary,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: FujinSpace.s1,
              children: [
                Text(
                  title,
                  style: FujinText.inter15Medium.copyWith(
                    color: context.colors.textPrimary,
                  ),
                ),
                Text(
                  detail,
                  style: FujinText.inter13Regular.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
                if (onRetry case final onRetry?) ...[
                  const SizedBox(height: FujinSpace.s2),
                  OutlinedButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh),
                    label: Text(context.intl.tryAgain),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
