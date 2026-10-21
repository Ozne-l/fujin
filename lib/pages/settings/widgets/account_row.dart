import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_theme.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';
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
    final colors = context.colors;
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
                          color: colors.textPrimary,
                        ),
                      ),
                      Text(
                        context.intl.settingsAccountActive,
                        style: FujinText.inter13Regular.copyWith(
                          color: colors.textSecondary,
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
              foregroundColor: colors.textAlert,
              textStyle: FujinText.inter14Medium,
              padding: const EdgeInsets.symmetric(horizontal: FujinSpace.s3),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ).copyWith(overlayColor: FujinTheme.pressedOverlay(colors)),
            child: Text(context.intl.signOut),
          ),
        ],
      ),
    );
  }
}
