import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/chat_media/chat_media_icon.dart';
import 'package:fujin/pages/chat_media/widgets/camera_chip_size.dart';
import 'package:fujin/pages/chat_media/widgets/media_glyph.dart';

class CameraChip extends StatelessWidget {
  const CameraChip({
    required this.label,
    required this.onPressed,
    this.icon,
    this.selected = false,
    this.size = CameraChipSize.compact,
    super.key,
  });

  static const double _gap = 6;

  final String label;
  final String? icon;
  final bool selected;
  final CameraChipSize size;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (background, foreground) = switch ((selected, onPressed)) {
      (true, _) => (colors.cameraText, colors.cameraBackground),
      (false, null) => (colors.cameraButton, colors.cameraTextSecondary),
      (false, _) => (colors.cameraButton, colors.cameraText),
    };
    final glyph = switch ((selected, icon)) {
      (true, null) => ChatMediaIcon.check,
      (_, final icon?) => icon,
      (false, null) => null,
    };
    return Semantics(
      button: true,
      selected: selected,
      enabled: onPressed != null,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: FujinSize.touchTarget),
        child: Center(
          widthFactor: 1,
          child: Material(
            color: background,
            shape: const StadiumBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onPressed,
              child: SizedBox(
                height: size.height,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.padding),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: _gap,
                    children: [
                      if (glyph case final glyph?)
                        MediaGlyph(glyph, size: size.icon, color: foreground),
                      Text(
                        label,
                        style: FujinText.inter14Medium.copyWith(
                          color: foreground,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
