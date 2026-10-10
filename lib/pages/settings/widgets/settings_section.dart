import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/text_inset.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({
    required this.label,
    required this.rows,
    super.key,
  });

  final String label;
  final List<Widget> rows;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: FujinSpace.s5),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: FujinSpace.s2,
      children: [
        TextInset(
          child: Text(
            label,
            style: FujinText.inter12Medium.copyWith(
              color: FujinColorRole.textSecondary,
            ),
          ),
        ),
        Material(
          color: FujinColorRole.backgroundCard,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(FujinRadius.card),
            side: const BorderSide(color: FujinColorRole.borderCard),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: FujinSpace.s1),
            child: Column(
              children: [
                for (final (index, row) in rows.indexed) ...[
                  if (index > 0)
                    const Divider(
                      height: FujinStroke.card,
                      thickness: FujinStroke.card,
                      indent: FujinSpace.s5,
                      endIndent: FujinSpace.s5,
                      color: FujinColorRole.borderHairline,
                    ),
                  row,
                ],
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
