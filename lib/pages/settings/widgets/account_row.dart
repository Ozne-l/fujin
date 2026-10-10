import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/common/source_dot.dart';

class AccountRow extends StatelessWidget {
  const AccountRow({
    required this.dot,
    required this.name,
    required this.onSignOut,
    super.key,
  });

  final Color dot;
  final String name;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
        FujinSpace.s5,
        FujinSpace.s3,
        FujinSpace.s2,
        FujinSpace.s3,
      ),
      child: Row(
        spacing: FujinSpace.s3,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: FujinSpace.s3,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: FujinSpace.s2),
                  child: SourceDot(color: dot),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: FujinSpace.s1,
                    children: [
                      Text(
                        name,
                        style: FujinText.inter15Medium.copyWith(
                          color: FujinColorRole.textPrimary,
                        ),
                      ),
                      Text(
                        l10n.settingsAccountActive,
                        style: FujinText.inter13Regular.copyWith(
                          color: FujinColorRole.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onSignOut,
            style: TextButton.styleFrom(
              foregroundColor: FujinColorRole.textAlert,
              textStyle: FujinText.inter14Medium,
              padding: const EdgeInsets.symmetric(horizontal: FujinSpace.s3),
              minimumSize: const Size.square(FujinSize.touchTarget),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(l10n.signOut),
          ),
        ],
      ),
    );
  }
}
