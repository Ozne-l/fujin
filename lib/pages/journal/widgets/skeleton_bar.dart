import 'package:flutter/widgets.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';

class SkeletonBar extends StatelessWidget {
  const SkeletonBar({required this.height, this.width, super.key});

  final double height;
  final double? width;

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: FujinColorRole.goalTrack,
      borderRadius: BorderRadius.circular(height / 2),
    ),
  );
}
