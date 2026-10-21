import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/appearance_corner.dart';
import 'package:fujin/pages/common/appearance_header.dart';
import 'package:fujin/pages/common/text_inset.dart';

class JournalBrand extends StatelessWidget {
  const JournalBrand({super.key});

  static const TextStyle _style = FujinText.hina22;

  static double extent(BuildContext context) =>
      AppearanceHeader.centredTop(context, _style) +
      AppearanceHeader.lineHeight(context, _style) +
      FujinSpace.s4 -
      AppearanceCorner.top;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: extent(context),
    child: Padding(
      padding: EdgeInsets.fromLTRB(
        FujinSize.screenMargin,
        AppearanceHeader.centredTop(context, _style),
        FujinSize.screenMargin,
        0,
      ),
      child: TextInset(
        child: Text(
          context.intl.appName,
          style: _style.copyWith(color: context.colors.textLink),
        ),
      ),
    ),
  );
}
