import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/scanner/widgets/camera_icon_button.dart';

class EditorHeader extends StatelessWidget {
  const EditorHeader({
    required this.title,
    required this.position,
    required this.count,
    required this.onCancel,
    required this.onDone,
    super.key,
  });

  final String title;
  final int position;
  final int count;
  final VoidCallback onCancel;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: FujinSize.screenMargin),
      child: Row(
        spacing: FujinSpace.s3,
        children: [
          CameraIconButton(
            icon: Icons.close,
            tooltip: context.intl.cancel,
            onPressed: onCancel,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: FujinSize.textGap,
              children: [
                Text(
                  title,
                  style: FujinText.inter16Medium.copyWith(
                    color: colors.cameraText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (count > 1)
                  Text(
                    context.intl.chatEditorPosition(position, count),
                    style: FujinText.inter13Regular.copyWith(
                      color: colors.cameraTextSecondary,
                    ),
                  ),
              ],
            ),
          ),
          CameraIconButton(
            icon: Icons.check,
            tooltip: context.intl.chatEditorDone,
            onPressed: onDone,
          ),
        ],
      ),
    );
  }
}
