import 'package:flutter/widgets.dart';

class CroppedPicture extends StatelessWidget {
  const CroppedPicture({
    required this.upright,
    required this.crop,
    required this.child,
    this.quarterTurns = 0,
    this.fit = BoxFit.contain,
    super.key,
  });

  final Size upright;
  final Rect crop;
  final int quarterTurns;
  final BoxFit fit;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final shown = switch (quarterTurns.isOdd) {
      true => upright.flipped,
      false => upright,
    };
    return FittedBox(
      fit: fit,
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: crop.width * shown.width,
        height: crop.height * shown.height,
        child: ClipRect(
          child: OverflowBox(
            alignment: Alignment.topLeft,
            minWidth: shown.width,
            maxWidth: shown.width,
            minHeight: shown.height,
            maxHeight: shown.height,
            child: Transform.translate(
              offset: Offset(
                -crop.left * shown.width,
                -crop.top * shown.height,
              ),
              child: RotatedBox(
                quarterTurns: quarterTurns,
                child: SizedBox.fromSize(size: upright, child: child),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
