import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/chat/edit/crop_aspect.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/chat_media/media_text.dart';
import 'package:fujin/pages/chat_media/widgets/camera_chip.dart';
import 'package:fujin/pages/chat_media/widgets/camera_chip_size.dart';

class AspectChips extends StatelessWidget {
  const AspectChips({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final CropAspect selected;
  final ValueChanged<CropAspect> onSelected;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: FujinSize.touchTarget,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: FujinSpace.s3),
      itemCount: CropAspect.values.length,
      separatorBuilder: (context, index) =>
          const SizedBox(width: FujinSize.cameraChipGap),
      itemBuilder: (context, index) {
        final aspect = CropAspect.values[index];
        return CameraChip(
          label: MediaText.aspect(context.intl, aspect),
          selected: aspect == selected,
          size: CameraChipSize.chip,
          onPressed: () => onSelected(aspect),
        );
      },
    ),
  );
}
