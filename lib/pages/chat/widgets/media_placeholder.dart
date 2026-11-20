import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';

class MediaPlaceholder extends StatelessWidget {
  const MediaPlaceholder({this.size, super.key});

  final Size? size;

  @override
  Widget build(BuildContext context) => SizedBox.fromSize(
    size: size,
    child: ColoredBox(color: context.colors.backgroundNeutral),
  );
}
