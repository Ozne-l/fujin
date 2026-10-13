import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';

class InPageSheet extends StatelessWidget {
  const InPageSheet({required this.child, this.onDismiss, super.key});

  final Widget child;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [
      GestureDetector(
        onTap: onDismiss,
        child: const ColoredBox(color: FujinColorRole.backgroundScrim),
      ),
      Align(alignment: Alignment.bottomCenter, child: child),
    ],
  );
}
