import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/chat/chat_text.dart';
import 'package:fujin/pages/chat_media/chat_media_icon.dart';
import 'package:fujin/pages/chat_media/widgets/dark_pill.dart';

class VideoDurationChip extends StatelessWidget {
  const VideoDurationChip({required this.duration, super.key});

  final Duration duration;

  static const EdgeInsets _padding = EdgeInsets.fromLTRB(
    FujinSize.mediaPillPaddingHorizontal,
    FujinSize.durationChipPaddingVertical,
    FujinSize.durationChipPaddingEnd,
    FujinSize.durationChipPaddingVertical,
  );

  @override
  Widget build(BuildContext context) => DarkPill(
    icon: ChatMediaIcon.play,
    iconSize: FujinSize.durationChipIcon,
    label: ChatText.clock(duration),
    labelStyle: FujinText.inter11Semibold,
    padding: _padding,
  );
}
