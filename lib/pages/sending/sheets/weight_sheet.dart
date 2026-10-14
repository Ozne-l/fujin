import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_theme.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/sending/planned_entry.dart';
import 'package:fujin/domain/sending/send_choice.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/grams_input.dart';
import 'package:fujin/pages/sending/entry_choices.dart';
import 'package:fujin/pages/sending/send_text.dart';
import 'package:fujin/pages/sending/sheets/sheet_frame.dart';

Future<void> showWeightSheet(
  BuildContext context, {
  required PlannedEntry planned,
  required EntryChoices choices,
}) async {
  if (planned.choice case final SendToEkkloFood choice) {
    await SheetFrame.show(
      context,
      builder: (_) =>
          _WeightSheet(planned: planned, choice: choice, choices: choices),
    );
  }
}

class _WeightSheet extends HookWidget {
  const _WeightSheet({
    required this.planned,
    required this.choice,
    required this.choices,
  });

  final PlannedEntry planned;
  final SendToEkkloFood choice;
  final EntryChoices choices;

  @override
  Widget build(BuildContext context) {
    final entry = planned.entry;
    final unit = entry.servingSize.unit;
    final weight = useTextEditingController(
      text: switch (choice.gramsPerUnit) {
        null => '',
        final grams => GramsInput.format(context, grams),
      },
    );
    useListenable(weight);
    final grams = GramsInput.parse(context, weight.text);
    final navigator = Navigator.of(context);

    return SheetFrame(
      title: context.intl.weightQuestion(unit),
      titleStyle: FujinText.hina26,
      subtitle: switch (entry.food.brandName?.trim()) {
        null || '' => entry.food.description,
        final brand => context.intl.weightFoodBrand(
          entry.food.description,
          brand,
        ),
      },
      body: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: FujinSpace.s3,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: FujinSpace.s2,
              children: [
                SheetFrame.inset(
                  Text(
                    context.intl.weightLabel(unit),
                    style: FujinText.inter13Medium.copyWith(
                      color: FujinColorRole.textPrimary,
                    ),
                  ),
                ),
                TextField(
                  cursorWidth: FujinTheme.cursorWidth,
                  controller: weight,
                  autofocus: true,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textInputAction: TextInputAction.done,
                  style: FujinText.inter17Medium.copyWith(
                    color: FujinColorRole.textPrimary,
                  ),
                  decoration: InputDecoration(
                    suffixText: context.intl.gramsSuffix,
                    suffixStyle: FujinText.inter15Regular.copyWith(
                      color: FujinColorRole.textSecondary,
                    ),
                  ),
                ),
                if (_estimate(context.intl) case final estimate?)
                  SheetFrame.inset(
                    Text(
                      estimate,
                      style: FujinText.inter12Regular.copyWith(
                        color: FujinColorRole.textSecondary,
                      ),
                    ),
                  ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(FujinSpace.s3),
              decoration: BoxDecoration(
                color: FujinColorRole.backgroundPage,
                borderRadius: BorderRadius.circular(FujinRadius.field),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: FujinSpace.s1,
                children: [
                  Text(
                    context.intl.inEkkloTitle,
                    style: FujinText.inter12Medium.copyWith(
                      color: FujinColorRole.textSecondary,
                    ),
                  ),
                  Text(
                    switch (grams) {
                      final grams? => context.intl.weightInEkklo(
                        choice.ekkloFoodName,
                        SendText.grams(context.intl, planned.units * grams),
                      ),
                      null => choice.ekkloFoodName,
                    },
                    style: FujinText.inter13Medium.copyWith(
                      color: FujinColorRole.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            SheetFrame.inset(
              Row(
                spacing: FujinSpace.s1,
                children: [
                  Icon(
                    Icons.check,
                    size: _rememberedStyle.fontSize,
                    color: FujinColorRole.textGold,
                  ),
                  Expanded(
                    child: Text(
                      context.intl.weightRemembered,
                      style: _rememberedStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
      primaryLabel: context.intl.validate,
      onPrimary: switch (grams) {
        final grams? => () {
          choices.weigh(grams);
          navigator.pop();
        },
        null => null,
      },
    );
  }

  static final TextStyle _rememberedStyle = FujinText.inter12Medium.copyWith(
    color: FujinColorRole.textGold,
  );

  String? _estimate(AppLocalizations intl) => switch ((
    planned.entry.nutrients.energy?.kilocalories,
    planned.units,
  )) {
    (final kilocalories?, final units) when units > 0 => intl.weightEstimate(
      intl.kilocalories(kilocalories / units),
      planned.entry.servingSize.unit,
    ),
    _ => null,
  };
}
