import 'package:flutter/widgets.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/chat/edit/crop_handle.dart';
import 'package:fujin/pages/chat_media/widgets/crop_overlay.dart';
import 'package:fujin/pages/chat_media/widgets/gesture_safe_padding.dart';

class CropStage extends StatelessWidget {
  const CropStage({
    required this.aspectRatio,
    required this.picture,
    required this.crop,
    required this.onDragged,
    super.key,
  });

  final double aspectRatio;
  final Widget picture;
  final Rect crop;
  final void Function(CropHandle handle, Offset delta) onDragged;

  @override
  Widget build(BuildContext context) {
    final insets = GestureSafePadding.insetsOf(
      context,
      vertical: FujinSize.screenMargin,
      clearance: CropOverlay.edgeClearance,
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        final area = insets.deflateRect(Offset.zero & constraints.biggest);
        final fitted = applyBoxFit(
          BoxFit.contain,
          Size(aspectRatio, 1),
          area.size,
        ).destination;
        final shown = Alignment.center.inscribe(fitted, area);
        return Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fromRect(rect: shown, child: picture),
            CropOverlay(picture: shown, crop: crop, onDragged: onDragged),
          ],
        );
      },
    );
  }
}
