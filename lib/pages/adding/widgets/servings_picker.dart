import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_theme.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/common/grams_input.dart';

class ServingsPicker extends HookWidget {
  const ServingsPicker({
    required this.servings,
    required this.onServings,
    super.key,
  });

  static const List<double> presets = [0.5, 1, 2];

  final double servings;
  final ValueChanged<double> onServings;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final custom = !presets.contains(servings);
    final other = useTextEditingController(
      text: switch (custom) {
        true => GramsInput.format(context, servings),
        false => '',
      },
    );
    final focus = useFocusNode();
    useListenable(focus);
    final outlined = custom || focus.hasFocus;
    return Row(
      spacing: FujinSpace.s2,
      children: [
        for (final preset in presets)
          Expanded(
            child: _Choice(
              label: GramsInput.format(context, preset),
              selected: preset == servings,
              onTap: () {
                other.clear();
                focus.unfocus();
                onServings(preset);
              },
            ),
          ),
        Expanded(
          flex: 2,
          child: SizedBox(
            height: FujinSize.buttonMedium,
            child: TextField(
              cursorWidth: FujinTheme.cursorWidth,
              controller: other,
              focusNode: focus,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              style: FujinText.inter16Medium.copyWith(
                color: FujinColorRole.textPrimary,
              ),
              onChanged: (text) {
                if (GramsInput.parse(context, text) case final value?) {
                  onServings(value);
                }
              },
              decoration: InputDecoration(
                hintText: l10n.addServingsOther,
                suffixText: switch (custom) {
                  true => l10n.addServingsUnit,
                  false => null,
                },
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: FujinSpace.s4,
                ),
                filled: true,
                fillColor: FujinColorRole.backgroundCard,
                enabledBorder: _border(outlined: outlined),
                focusedBorder: _border(outlined: true),
              ),
            ),
          ),
        ),
      ],
    );
  }

  static OutlineInputBorder _border({required bool outlined}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(FujinRadius.pill),
        borderSide: switch (outlined) {
          true => const BorderSide(
            color: FujinColorRole.textLink,
            width: FujinStroke.fieldFocus,
          ),
          false => const BorderSide(color: FujinColorRole.borderCard),
        },
      );
}

class _Choice extends StatelessWidget {
  const _Choice({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    selected: selected,
    button: true,
    child: Material(
      color: switch (selected) {
        true => FujinColorRole.backgroundDark,
        false => FujinColorRole.backgroundCard,
      },
      shape: StadiumBorder(
        side: switch (selected) {
          true => BorderSide.none,
          false => const BorderSide(color: FujinColorRole.borderCard),
        },
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: SizedBox(
          height: FujinSize.buttonMedium,
          child: Center(
            child: Text(
              label,
              style: FujinText.inter16Medium.copyWith(
                color: switch (selected) {
                  true => FujinColorRole.textOnDark,
                  false => FujinColorRole.textPrimary,
                },
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
