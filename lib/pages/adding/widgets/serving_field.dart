import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/adding/add_text.dart';
import 'package:fujin/pages/common/fujin_menu.dart';
import 'package:fujin/pages/common/fujin_menu_button.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

class ServingField extends StatelessWidget {
  const ServingField({
    required this.servings,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  static const _padding = EdgeInsetsDirectional.symmetric(
    horizontal: FujinSpace.s4,
  );

  final List<MfpServingSize> servings;
  final MfpServingSize selected;
  final ValueChanged<MfpServingSize> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: FujinSize.screenMargin),
      child: FujinMenu<MfpServingSize>(
        items: servings,
        selected: selected,
        labelOf: (serving) => AddText.serving(l10n, serving),
        onSelected: onSelected,
        itemPadding: _padding,
        itemStyle: FujinText.inter15Medium,
        builder: (context, {required expanded, required toggle}) =>
            FujinMenuButton(
              label: AddText.serving(l10n, selected),
              expanded: expanded,
              onTap: toggle,
              height: FujinSize.field,
              radius: FujinRadius.field,
              padding: _padding,
              style: FujinText.inter15Medium,
              chevronSize: FujinSize.searchIcon,
            ),
      ),
    );
  }
}
