import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/fujin_icon_button.dart';

class FlowHeader extends StatelessWidget {
  const FlowHeader({
    required this.title,
    required this.subtitle,
    this.onBack,
    this.closes = false,
    super.key,
  });

  final String title;
  final String subtitle;
  final bool closes;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final back = onBack;
    final localizations = MaterialLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        FujinSize.screenMargin,
        FujinSpace.s2,
        FujinSize.screenMargin,
        FujinSpace.s4,
      ),
      child: Row(
        spacing: FujinSpace.s4,
        children: [
          if (back != null)
            FujinIconButton(
              icon: switch (closes) {
                true => Icons.close,
                false => Icons.chevron_left,
              },
              tooltip: switch (closes) {
                true => localizations.closeButtonTooltip,
                false => localizations.backButtonTooltip,
              },
              onPressed: back,
              floating: true,
            ),
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.only(
                start: switch (back) {
                  null => FujinSpace.s2,
                  _ => 0,
                },
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: FujinSpace.s1,
                children: [
                  Text(
                    title,
                    style: FujinText.inter16Medium.copyWith(
                      color: context.colors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: FujinText.inter13Regular.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
