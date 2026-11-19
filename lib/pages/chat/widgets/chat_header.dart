import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/chat/widgets/photo_tile.dart';
import 'package:fujin/pages/common/fujin_icon_button.dart';
import 'package:fujin/pages/common/source_dot.dart';

class ChatHeader extends StatelessWidget {
  const ChatHeader({
    required this.name,
    required this.photo,
    required this.onBack,
    super.key,
  });

  final String name;
  final Uri? photo;
  final VoidCallback onBack;

  static const double _photo = 40;
  static const double _photoGap = 12;
  static const double _lineGap = 2;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(
      FujinSize.screenMargin,
      FujinSpace.s2,
      FujinSize.screenMargin,
      FujinSpace.s4,
    ),
    child: Row(
      children: [
        FujinIconButton(
          icon: Icons.chevron_left,
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: onBack,
          floating: true,
        ),
        const SizedBox(width: FujinSpace.s2),
        ClipOval(
          child: switch (photo) {
            final photo? => PhotoTile(
              url: photo,
              size: const Size.square(_photo),
            ),
            null => SizedBox.square(
              dimension: _photo,
              child: ColoredBox(color: context.colors.backgroundNeutral),
            ),
          },
        ),
        const SizedBox(width: _photoGap),
        Expanded(
          child: Semantics(
            header: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: _lineGap,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: FujinText.inter16Medium.copyWith(
                    color: context.colors.textPrimary,
                  ),
                ),
                Row(
                  spacing: FujinSpace.s1,
                  children: [
                    SourceDot(color: context.colors.sourceEkklo),
                    Text(
                      context.intl.chatCoach,
                      style: FujinText.inter13Regular.copyWith(
                        color: context.colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
