import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/scanner/widgets/camera_icon_button.dart';

class ViewerHeader extends StatelessWidget {
  const ViewerHeader({
    required this.title,
    required this.moment,
    required this.onClose,
    super.key,
  });

  final String title;
  final String moment;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: FujinSize.screenMargin,
      vertical: FujinSpace.s1,
    ),
    child: Row(
      spacing: FujinSpace.s2,
      children: [
        CameraIconButton(
          icon: Icons.close,
          tooltip: context.intl.close,
          onPressed: onClose,
        ),
        Expanded(
          child: Column(
            spacing: FujinSpace.s1,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: FujinText.inter16Medium.copyWith(
                  color: context.colors.cameraText,
                ),
              ),
              Text(
                moment,
                textAlign: TextAlign.center,
                style: FujinText.inter13Regular.copyWith(
                  color: context.colors.cameraTextSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox.square(dimension: FujinSize.touchTarget),
      ],
    ),
  );
}
