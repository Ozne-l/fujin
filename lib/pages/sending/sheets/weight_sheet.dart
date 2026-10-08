import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/sending/planned_entry.dart';
import 'package:fujin/domain/sending/send_choice.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/sending/send_plan_notifier.dart';
import 'package:fujin/pages/sending/send_text.dart';
import 'package:fujin/pages/sending/sheets/sheet_frame.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

Future<void> showWeightSheet(
  BuildContext context, {
  required PlannedEntry planned,
}) async {
  if (planned.choice case final SendToEkkloFood choice) {
    await SheetFrame.show(
      context,
      builder: (_) => _WeightSheet(planned: planned, choice: choice),
    );
  }
}

class _WeightSheet extends HookConsumerWidget {
  const _WeightSheet({required this.planned, required this.choice});

  static const _decimals = 1;
  static const _frenchDecimal = ',';
  static const _decimal = '.';
  static const _focusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(FujinRadius.field)),
    borderSide: BorderSide(
      color: FujinColor.fujin,
      width: FujinStroke.fieldError,
    ),
  );

  final PlannedEntry planned;
  final SendToEkkloFood choice;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final entry = planned.entry;
    final unit = entry.servingSize.unit;
    final weight = useTextEditingController(
      text: switch (choice.gramsPerUnit) {
        null => '',
        final grams => _format(context, grams),
      },
    );
    useListenable(weight);
    final grams = _parse(weight.text);
    final plan = ref.read(sendPlanProvider(entry.date).notifier);
    final navigator = Navigator.of(context);

    return SheetFrame(
      title: l10n.weightQuestion(unit),
      titleStyle: FujinText.hina26,
      subtitle: switch (entry.food.brandName?.trim()) {
        null || '' => entry.food.description,
        final brand => l10n.weightFoodBrand(entry.food.description, brand),
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
                    l10n.weightLabel(unit),
                    style: FujinText.inter13Medium.copyWith(
                      color: FujinColorRole.textPrimary,
                    ),
                  ),
                ),
                TextField(
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
                    suffixText: l10n.gramsSuffix,
                    suffixStyle: FujinText.inter15Regular.copyWith(
                      color: FujinColorRole.textSecondary,
                    ),
                    focusedBorder: _focusedBorder,
                  ),
                ),
                if (_estimate(l10n) case final estimate?)
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
                    l10n.inEkkloTitle,
                    style: FujinText.inter12Medium.copyWith(
                      color: FujinColorRole.textSecondary,
                    ),
                  ),
                  Text(
                    switch (grams) {
                      final grams? => l10n.weightInEkklo(
                        choice.ekkloFoodName,
                        SendText.grams(l10n, planned.units * grams),
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
                    child: Text(l10n.weightRemembered, style: _rememberedStyle),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
      primaryLabel: l10n.validate,
      onPrimary: switch (grams) {
        final grams? => () {
          plan.weigh(planned.entryId, grams);
          navigator.pop();
        },
        null => null,
      },
    );
  }

  static final TextStyle _rememberedStyle = FujinText.inter12Medium.copyWith(
    color: FujinColorRole.textGold,
  );

  String? _estimate(AppLocalizations l10n) => switch ((
    planned.entry.nutrients.energy?.kilocalories,
    planned.units,
  )) {
    (final kilocalories?, final units) when units > 0 => l10n.weightEstimate(
      l10n.kilocalories(kilocalories / units),
      planned.entry.servingSize.unit,
    ),
    _ => null,
  };

  static String _format(BuildContext context, double grams) =>
      (NumberFormat.decimalPattern(Localizations.localeOf(context).toString())
            ..maximumFractionDigits = _decimals
            ..turnOffGrouping())
          .format(grams);

  static double? _parse(String text) => switch (double.tryParse(
    text.trim().replaceAll(_frenchDecimal, _decimal),
  )) {
    final grams? when grams.isFinite && grams > 0 => grams,
    _ => null,
  };
}
