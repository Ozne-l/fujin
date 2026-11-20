import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';

class UploadDisc extends StatelessWidget {
  const UploadDisc({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: FujinSize.mediaDisc,
      height: FujinSize.mediaDisc,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.backgroundCard,
        shape: BoxShape.circle,
        border: Border.all(color: colors.borderCard),
      ),
      child: child,
    );
  }
}
