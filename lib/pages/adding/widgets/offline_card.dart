import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';

class OfflineCard extends StatelessWidget {
  const OfflineCard({required this.onRetry, super.key});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: FujinSize.screenMargin),
      padding: const EdgeInsets.all(FujinSpace.s4),
      decoration: BoxDecoration(
        color: FujinColorRole.borderCard,
        borderRadius: BorderRadius.circular(FujinRadius.card),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: FujinSpace.s3,
        children: [
          const CircleAvatar(
            radius: FujinSize.tile / 2,
            backgroundColor: FujinColorRole.backgroundCard,
            child: Icon(
              Icons.wifi_off,
              size: FujinSize.searchIcon,
              color: FujinColorRole.textPrimary,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: FujinSpace.s1,
              children: [
                Text(
                  l10n.addOfflineTitle,
                  style: FujinText.inter15Medium.copyWith(
                    color: FujinColorRole.textPrimary,
                  ),
                ),
                Text(
                  l10n.addOfflineDetail,
                  style: FujinText.inter13Regular.copyWith(
                    color: FujinColorRole.textSecondary,
                  ),
                ),
                const SizedBox(height: FujinSpace.s2),
                OutlinedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: Text(l10n.tryAgain),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
