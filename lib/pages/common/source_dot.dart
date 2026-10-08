import 'package:flutter/widgets.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';

class SourceDot extends StatelessWidget {
  const SourceDot({required this.color, super.key});

  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: FujinSize.sourceDot,
    height: FujinSize.sourceDot,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}
