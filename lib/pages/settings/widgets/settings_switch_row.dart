import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';

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
  Widget build(BuildContext context) => MergeSemantics(
    child: InkWell(
      onTap: () => onChanged(!value),
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
                      color: FujinColorRole.textPrimary,
                    ),
                  ),
                ),
                CupertinoSwitch(
                  value: value,
                  onChanged: onChanged,
                  activeTrackColor: FujinColor.fujin,
                  inactiveTrackColor: FujinColor.kinari,
                  thumbColor: FujinColorRole.backgroundCard,
                ),
              ],
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
    ),
  );
}
