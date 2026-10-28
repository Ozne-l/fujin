import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';

class RowAction extends StatelessWidget {
  const RowAction({
    required this.label,
    required this.icon,
    required this.reveal,
    required this.onPressed,
    super.key,
  });

  final String label;
  final String icon;
  final Animation<double> reveal;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final foreground = context.colors.buttonAlertText;
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      onTap: onPressed,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: context.colors.buttonAlertBackground,
            borderRadius: BorderRadius.circular(FujinRadius.card),
          ),
          child: SizedBox.expand(
            child: FadeTransition(
              opacity: reveal,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: FujinSpace.s2,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: FujinSpace.s1,
                  children: [
                    SvgPicture.asset(
                      icon,
                      width: FujinSize.rowActionIcon,
                      height: FujinSize.rowActionIcon,
                      theme: SvgTheme(currentColor: foreground),
                      excludeFromSemantics: true,
                    ),
                    Text(
                      label,
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.clip,
                      style: FujinText.inter11Medium.copyWith(
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
    );
  }
}
