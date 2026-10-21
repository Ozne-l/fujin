import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';

class InfoBanner extends StatelessWidget {
  const InfoBanner({
    required this.icon,
    required this.detail,
    this.title,
    super.key,
  });

  final Widget icon;
  final String? title;
  final String detail;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.symmetric(horizontal: FujinSize.screenMargin),
    padding: const EdgeInsets.all(FujinSpace.s3),
    decoration: BoxDecoration(
      color: context.colors.backgroundInfo,
      borderRadius: BorderRadius.circular(FujinRadius.field),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: FujinSpace.s3,
      children: [
        CircleAvatar(
          radius: FujinSize.tile / 2,
          backgroundColor: context.colors.textInfo,
          child: icon,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: FujinSpace.s1,
            children: [
              if (title case final title?)
                Text(
                  title,
                  style: FujinText.inter15Medium.copyWith(
                    color: context.colors.textPrimary,
                  ),
                ),
              Text(
                detail,
                style: FujinText.inter13Regular.copyWith(
                  color: context.colors.textInfo,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
