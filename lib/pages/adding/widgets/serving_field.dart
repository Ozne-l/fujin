import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/adding/add_text.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

class ServingField extends StatelessWidget {
  const ServingField({
    required this.servings,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final List<MfpServingSize> servings;
  final MfpServingSize selected;
  final ValueChanged<MfpServingSize> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final style = FujinText.inter16Medium.copyWith(
      color: FujinColorRole.textPrimary,
    );
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: FujinSize.screenMargin),
      padding: const EdgeInsets.symmetric(horizontal: FujinSpace.s4),
      decoration: BoxDecoration(
        color: FujinColorRole.backgroundCard,
        borderRadius: BorderRadius.circular(FujinRadius.field),
        border: Border.all(color: FujinColorRole.borderCard),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<MfpServingSize>(
          value: switch (servings.contains(selected)) {
            true => selected,
            false => null,
          },
          isExpanded: true,
          itemHeight: FujinSize.buttonHeight,
          style: style,
          borderRadius: BorderRadius.circular(FujinRadius.menu),
          dropdownColor: FujinColorRole.backgroundCard,
          icon: const Icon(Icons.expand_more),
          hint: Text(AddText.serving(l10n, selected), style: style),
          items: [
            for (final serving in servings)
              DropdownMenuItem(
                value: serving,
                child: Text(AddText.serving(l10n, serving)),
              ),
          ],
          onChanged: (serving) {
            if (serving case final serving?) onSelected(serving);
          },
        ),
      ),
    );
  }
}
