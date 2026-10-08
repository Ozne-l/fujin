import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';

class FujinIconButton extends StatelessWidget {
  const FujinIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    super.key,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => IconButton(
    onPressed: onPressed,
    tooltip: tooltip,
    icon: Icon(icon),
    style: IconButton.styleFrom(
      fixedSize: const Size.square(FujinSize.touchTarget),
      backgroundColor: FujinColorRole.backgroundCard,
      foregroundColor: FujinColorRole.textPrimary,
      side: const BorderSide(color: FujinColorRole.borderCard),
    ),
  );
}
