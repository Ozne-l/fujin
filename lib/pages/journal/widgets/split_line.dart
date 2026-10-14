import 'package:flutter/widgets.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';

class SplitLine extends StatelessWidget {
  const SplitLine({required this.leading, this.trailing, super.key});

  final Widget leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Row(
    spacing: FujinSpace.s3,
    children: [
      Expanded(child: leading),
      ?trailing,
    ],
  );
}
