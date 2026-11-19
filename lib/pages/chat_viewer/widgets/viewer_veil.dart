import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/chat_media/chat_media_icon.dart';
import 'package:fujin/pages/chat_media/widgets/camera_chip.dart';
import 'package:fujin/pages/chat_media/widgets/media_glyph.dart';
import 'package:fujin/pages/common/fujin_spinner.dart';

class ViewerVeil extends StatelessWidget {
  const ViewerVeil.loading({this.title, super.key}) : onRetry = null;

  const ViewerVeil.failed({
    required VoidCallback this.onRetry,
    this.title,
    super.key,
  });

  static const double _loadingVeil = 0.4;
  static const double _failedVeil = 0.75;

  final VoidCallback? onRetry;
  final String? title;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: context.colors.cameraBackground.withValues(
      alpha: switch (onRetry) {
        null => _loadingVeil,
        _ => _failedVeil,
      },
    ),
    child: Center(
      child: switch (onRetry) {
        null => Semantics(label: title, child: const FujinSpinner.disc()),
        final onRetry => _Failure(title: title, onRetry: onRetry),
      },
    ),
  );
}

class _Failure extends StatelessWidget {
  const _Failure({required this.title, required this.onRetry});

  final String? title;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    spacing: FujinSpace.s3,
    children: [
      Container(
        width: FujinSize.searchField,
        height: FujinSize.searchField,
        decoration: BoxDecoration(
          color: context.colors.buttonAlertBackground,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: MediaGlyph(
          ChatMediaIcon.alert,
          size: FujinSize.icon,
          color: context.colors.cameraText,
        ),
      ),
      if (title case final title?)
        Text(
          title,
          textAlign: TextAlign.center,
          style: FujinText.inter15Medium.copyWith(
            color: context.colors.cameraText,
          ),
        ),
      CameraChip(
        label: context.intl.chatViewerRetry,
        icon: ChatMediaIcon.refresh,
        onPressed: onRetry,
      ),
    ],
  );
}
