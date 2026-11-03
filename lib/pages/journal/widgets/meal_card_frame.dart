import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';

class MealCardFrame extends StatelessWidget {
  const MealCardFrame({
    required this.header,
    required this.body,
    required this.onAdd,
    super.key,
  });

  static const _plusIcon = 'assets/icons/plus.svg';

  static const Widget emptyBody = SizedBox(
    width: double.infinity,
    height: FujinSpace.s3,
  );

  final Widget header;
  final Widget body;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.symmetric(horizontal: FujinSize.screenMargin),
    padding: const EdgeInsets.fromLTRB(
      FujinSpace.s5,
      FujinSpace.s4,
      FujinSpace.s5,
      FujinSpace.s2,
    ),
    decoration: BoxDecoration(
      color: context.colors.backgroundCard,
      borderRadius: BorderRadius.circular(FujinRadius.card),
      border: Border.all(color: context.colors.borderCard),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        header,
        body,
        const Divider(),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton.icon(
            onPressed: onAdd,
            style: TextButton.styleFrom(
              textStyle: FujinText.inter14Medium,
              padding: EdgeInsets.zero,
            ),
            icon: SvgPicture.asset(
              _plusIcon,
              width: FujinSize.tileIcon,
              height: FujinSize.tileIcon,
              theme: SvgTheme(currentColor: context.colors.textLink),
              excludeFromSemantics: true,
            ),
            label: Text(context.intl.mealAddFood),
          ),
        ),
      ],
    ),
  );
}
