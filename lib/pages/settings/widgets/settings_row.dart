import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';

class SettingsRow extends StatelessWidget {
  const SettingsRow({
    required this.title,
    required this.detail,
    required this.onTap,
    this.titleColor = FujinColorRole.textPrimary,
    super.key,
  });

  final String title;
  final String detail;
  final Color titleColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
        FujinSpace.s5,
        FujinSpace.s3,
        FujinSpace.s3,
        FujinSpace.s3,
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
                  title,
                  style: FujinText.inter15Medium.copyWith(color: titleColor),
                ),
                Text(
                  detail,
                  style: FujinText.inter13Regular.copyWith(
                    color: FujinColorRole.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right,
            size: FujinSize.rowChevron,
            color: FujinColorRole.textTertiary,
          ),
        ],
      ),
    ),
  );
}
