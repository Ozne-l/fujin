import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_theme.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/data/memory/remembered_unit.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/common/fujin_icon_button.dart';
import 'package:fujin/pages/common/gold_volute.dart';
import 'package:fujin/pages/common/grams_input.dart';
import 'package:fujin/pages/common/source_dot.dart';
import 'package:fujin/pages/common/text_inset.dart';
import 'package:fujin/pages/memory/change_food_sheet.dart';
import 'package:fujin/pages/memory/memory_notifier.dart';
import 'package:fujin/pages/memory/memory_text.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MemoryFoodPage extends HookConsumerWidget {
  const MemoryFoodPage({required this.mfpFoodId, this.mfpUnit, super.key});

  final String mfpFoodId;
  final String? mfpUnit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final memory = ref.watch(memoryProvider);
    final notifier = ref.read(memoryProvider.notifier);
    final food = switch (mfpUnit) {
      final unit? => memory.food(mfpFoodId, unit),
      null =>
        memory.matches.where((food) => food.mfpFoodId == mfpFoodId).firstOrNull,
    };
    if (food == null) return const Scaffold();
    final units = memory.unitsOf(food);
    final servedIn = switch (food) {
      OwnCopy(:final mfpUnit) => [mfpUnit],
      MatchedFood() => [for (final unit in units) unit.mfpUnit],
    };

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            FujinSize.screenMargin,
            0,
            FujinSize.screenMargin,
            FujinSpace.s8 + MediaQuery.paddingOf(context).bottom,
          ),
          children: [
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: FujinIconButton(
                icon: Icons.chevron_left,
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                onPressed: context.pop,
              ),
            ),
            TextInset(
              top: FujinSpace.s3,
              bottom: FujinSpace.s6,
              child: Text(
                food.mfpDescription,
                style: FujinText.hina30.copyWith(
                  color: FujinColorRole.textPrimary,
                ),
              ),
            ),
            _SourceCard(
              dot: FujinColorRole.sourceMfp,
              source: l10n.sourceMyFitnessPal,
              name: food.mfpDescription,
              lines: [
                if (servedIn.isNotEmpty)
                  _Line(
                    l10n.memoryServedIn(MemoryText.quotedUnits(l10n, servedIn)),
                    FujinText.inter13Regular.copyWith(
                      color: FujinColorRole.textSecondary,
                    ),
                  ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: FujinSpace.s4),
              child: Center(child: GoldVolute()),
            ),
            _EkkloCard(
              food: food,
              onChange: () =>
                  unawaited(showChangeFoodSheet(context, food: food)),
            ),
            if (units.isNotEmpty) ...[
              TextInset(
                top: FujinSpace.s5,
                bottom: FujinSpace.s2,
                child: Text(
                  l10n.memoryUnitWeights,
                  style: FujinText.inter12Medium.copyWith(
                    color: FujinColorRole.textSecondary,
                  ),
                ),
              ),
              _UnitWeights(units: units, onSave: notifier.saveUnit),
            ],
            Padding(
              padding: const EdgeInsets.only(
                top: FujinSpace.s8,
                bottom: FujinSpace.s3,
              ),
              child: OutlinedButton(
                style: FujinTheme.largeOutlinedButtonStyle.copyWith(
                  foregroundColor: const WidgetStatePropertyAll(
                    FujinColorRole.textAlert,
                  ),
                  side: const WidgetStatePropertyAll(
                    BorderSide(color: FujinColorRole.textAlert),
                  ),
                ),
                onPressed: () {
                  context.pop();
                  notifier.forget(food);
                },
                child: Text(l10n.memoryForget),
              ),
            ),
            Text(
              l10n.memoryForgetNote,
              textAlign: TextAlign.center,
              style: FujinText.inter12Regular.copyWith(
                color: FujinColorRole.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EkkloCard extends ConsumerWidget {
  const _EkkloCard({required this.food, required this.onChange});

  final RememberedFood food;
  final VoidCallback onChange;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final ekkloFood = switch (ref.watch(ekkloFoodProvider(food.ekkloFoodId))) {
      AsyncData(:final value) => value,
      AsyncValue() => null,
    };
    return _SourceCard(
      dot: FujinColorRole.sourceEkklo,
      source: l10n.sourceEkklo,
      action: TextButton(
        onPressed: onChange,
        style: TextButton.styleFrom(
          foregroundColor: FujinColorRole.textLink,
          textStyle: FujinText.inter14Medium,
          minimumSize: const Size.square(FujinSize.touchTarget),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
        child: Text(l10n.memoryChange),
      ),
      name: food.ekkloFoodName,
      lines: [
        if (ekkloFood case final ekkloFood?) ...[
          _Line(
            l10n.memoryEnergyPer(
              l10n.kilocalories(ekkloFood.calories),
              MemoryText.portion(l10n, ekkloFood),
            ),
            FujinText.inter15Semibold.copyWith(
              color: FujinColorRole.textPrimary,
            ),
          ),
          _Line(
            MemoryText.macros(l10n, ekkloFood),
            FujinText.inter12Medium.copyWith(
              color: FujinColorRole.textTertiary,
            ),
          ),
        ],
      ],
    );
  }
}

class _SourceCard extends StatelessWidget {
  const _SourceCard({
    required this.dot,
    required this.source,
    required this.name,
    required this.lines,
    this.action,
  });

  final Color dot;
  final String source;
  final String name;
  final List<_Line> lines;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(
      FujinSpace.s5,
      FujinSpace.s4,
      FujinSpace.s4,
      FujinSpace.s3,
    ),
    decoration: BoxDecoration(
      color: FujinColorRole.backgroundCard,
      borderRadius: BorderRadius.circular(FujinRadius.card),
      border: Border.all(color: FujinColorRole.borderCard),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: FujinSpace.s1,
      children: [
        Row(
          spacing: FujinSpace.s2,
          children: [
            SourceDot(color: dot),
            Expanded(
              child: Text(
                source,
                style: FujinText.inter12Medium.copyWith(
                  color: FujinColorRole.textSecondary,
                ),
              ),
            ),
            ?action,
          ],
        ),
        Text(
          name,
          style: FujinText.inter16Medium.copyWith(
            color: FujinColorRole.textPrimary,
          ),
        ),
        for (final line in lines) Text(line.text, style: line.style),
      ],
    ),
  );
}

final class _Line {
  const _Line(this.text, this.style);

  final String text;
  final TextStyle style;
}

class _UnitWeights extends StatelessWidget {
  const _UnitWeights({required this.units, required this.onSave});

  final List<RememberedUnit> units;
  final ValueChanged<RememberedUnit> onSave;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(
        FujinSpace.s5,
        FujinSpace.s3,
        FujinSpace.s4,
        FujinSpace.s3,
      ),
      decoration: BoxDecoration(
        color: FujinColorRole.backgroundCard,
        borderRadius: BorderRadius.circular(FujinRadius.card),
        border: Border.all(color: FujinColorRole.borderCard),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: FujinSpace.s3,
        children: [
          for (final unit in units)
            _UnitWeightRow(
              key: ValueKey(unit.mfpUnit),
              unit: unit,
              onSave: onSave,
            ),
          Text(
            l10n.memoryUnitWeightNote(
              MemoryText.quotedUnits(l10n, [
                for (final unit in units) unit.mfpUnit,
              ]),
            ),
            style: FujinText.inter12Regular.copyWith(
              color: FujinColorRole.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _UnitWeightRow extends HookWidget {
  const _UnitWeightRow({
    required this.unit,
    required this.onSave,
    super.key,
  });

  final RememberedUnit unit;
  final ValueChanged<RememberedUnit> onSave;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final weight = useTextEditingController(
      text: GramsInput.format(context, unit.grams),
    );
    return Row(
      spacing: FujinSpace.s3,
      children: [
        Expanded(
          child: Text(
            l10n.memoryOneUnit(unit.mfpUnit),
            style: FujinText.inter15Medium.copyWith(
              color: FujinColorRole.textPrimary,
            ),
          ),
        ),
        SizedBox(
          width: FujinSize.weightField,
          child: TextField(
            controller: weight,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.done,
            style: FujinText.inter17Medium.copyWith(
              color: FujinColorRole.textPrimary,
            ),
            decoration: InputDecoration(
              isDense: true,
              suffixText: l10n.gramsSuffix,
              suffixStyle: FujinText.inter15Regular.copyWith(
                color: FujinColorRole.textSecondary,
              ),
            ),
            onChanged: (text) {
              if (GramsInput.parse(context, text) case final grams?) {
                onSave(unit.copyWith(grams: grams));
              }
            },
          ),
        ),
      ],
    );
  }
}
