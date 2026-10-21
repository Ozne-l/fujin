import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';

class OfflineCard extends StatelessWidget {
  const OfflineCard({required this.onRetry, super.key});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: FujinSize.screenMargin),
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
                  context.intl.addOfflineTitle,
                  style: FujinText.inter15Medium.copyWith(
                    color: context.colors.textPrimary,
                  ),
                ),
                Text(
                  context.intl.addOfflineDetail,
                  style: FujinText.inter13Regular.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
                const SizedBox(height: FujinSpace.s2),
                OutlinedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: Text(context.intl.tryAgain),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
