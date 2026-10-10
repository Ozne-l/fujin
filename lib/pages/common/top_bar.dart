import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/fujin_icon_button.dart';
import 'package:go_router/go_router.dart';

class TopBar extends StatelessWidget {
  const TopBar({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: FujinSize.touchTarget,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Text(
          title,
          style: FujinText.inter15Medium.copyWith(
            color: FujinColorRole.textPrimary,
          ),
        ),
        PositionedDirectional(
          start: FujinSize.screenMargin,
          child: FujinIconButton(
            icon: Icons.chevron_left,
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            onPressed: () => context.pop(),
          ),
        ),
      ],
    ),
  );
}
