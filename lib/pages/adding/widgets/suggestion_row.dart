import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';

class SuggestionRow extends StatelessWidget {
  const SuggestionRow({
    required this.icon,
    required this.label,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: FujinSize.screenMargin),
    child: Material(
      color: context.colors.backgroundCard,
      shape: StadiumBorder(
        side: BorderSide(color: context.colors.borderCard),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: SizedBox(
          height: FujinSize.field,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: FujinSpace.s4),
            child: Row(
              spacing: FujinSpace.s3,
              children: [
                Icon(
                  icon,
                  size: FujinSize.searchIcon,
                  color: context.colors.textLink,
                ),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: FujinText.inter15Medium.copyWith(
                      color: context.colors.textPrimary,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: FujinSize.mealArrow,
                  color: context.colors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
