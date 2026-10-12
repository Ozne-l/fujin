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
      color: FujinColorRole.backgroundCard,
      shape: const StadiumBorder(
        side: BorderSide(color: FujinColorRole.borderCard),
      ),
      child: ListTile(
        onTap: onTap,
        shape: const StadiumBorder(),
        leading: Icon(icon, color: FujinColorRole.textLink),
        title: Text(
          label,
          style: FujinText.inter15Medium.copyWith(
            color: FujinColorRole.textPrimary,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          size: FujinSize.rowChevron,
          color: FujinColorRole.textSecondary,
        ),
      ),
    ),
  );
}
