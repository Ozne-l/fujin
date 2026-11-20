import 'package:flutter/widgets.dart';
import 'package:fujin/app/theme/fujin_motion.dart';

class MediaFlight extends StatelessWidget {
  const MediaFlight({required this.path, required this.child, super.key});

  final String path;
  final Widget child;

  @override
  Widget build(BuildContext context) => HeroMode(
    enabled: !FujinMotion.reduced(context),
    child: Hero(
      tag: (MediaFlight, path),
      child: child,
    ),
  );
}
