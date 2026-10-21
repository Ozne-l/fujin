import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/fujin_switch.dart';

class SettingsSwitchRow extends StatelessWidget {
  const SettingsSwitchRow({
    required this.title,
    required this.detail,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String title;
  final String detail;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return MergeSemantics(
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: FujinSpace.s5,
          vertical: FujinSpace.s3,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: FujinSpace.s1,
          children: [
            Row(
              spacing: FujinSpace.s3,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: FujinText.inter15Medium.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                ),
                FujinSwitch(value: value, onChanged: onChanged),
              ],
            ),
            Text(
              detail,
              style: FujinText.inter13Regular.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
