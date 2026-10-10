import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/goals/goal_amounts.dart';
import 'package:fujin/domain/goals/macro_energy.dart';
import 'package:fujin/domain/sending/nutrient.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/common/goals_notifier.dart';
import 'package:fujin/pages/common/goals_text.dart';
import 'package:fujin/pages/common/grams_input.dart';
import 'package:fujin/pages/common/text_inset.dart';
import 'package:fujin/pages/common/top_bar.dart';
import 'package:fujin/pages/settings/widgets/goal_field.dart';
import 'package:fujin/pages/settings/widgets/note_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GoalsPage extends HookConsumerWidget {
  const GoalsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final stored = ref.watch(goalsProvider);
    final fields = {
      for (final nutrient in Nutrient.values)
        nutrient: useTextEditingController(
          text: switch (stored?.amount(nutrient)) {
            final amount? => GramsInput.format(context, amount),
            null => '',
          },
        ),
    };
    useListenable(useMemoized(() => Listenable.merge(fields.values.toList())));
    final saved = useState(false);
    final amounts = {
      for (final MapEntry(key: nutrient, value: field) in fields.entries)
        nutrient: GramsInput.parse(context, field.text),
    };
    final readable = fields.entries.every(
      (field) => field.value.text.trim().isEmpty || amounts[field.key] != null,
    );
    final draft = GoalAmounts.from((nutrient) => amounts[nutrient]);
    final energy = MacroEnergy.of((nutrient) => amounts[nutrient]);
    final save = switch ((draft, readable, saved.value)) {
      (final goals?, true, false) => () {
        FocusScope.of(context).unfocus();
        ref.read(goalsProvider.notifier).save(goals);
        saved.value = true;
      },
      _ => null,
    };

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TopBar(title: l10n.goalsTitle),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  FujinSize.screenMargin,
                  FujinSpace.s6,
                  FujinSize.screenMargin,
                  FujinSpace.s6,
                ),
                children: [
                  TextInset(
                    bottom: FujinSpace.s2,
                    child: Text(
                      l10n.goalsHeading,
                      style: FujinText.hina30.copyWith(
                        color: FujinColorRole.textPrimary,
                      ),
                    ),
                  ),
                  TextInset(
                    child: Text(
                      l10n.goalsSubtitle,
                      style: FujinText.inter15Regular.copyWith(
                        color: FujinColorRole.textSecondary,
                      ),
                    ),
                  ),
                  TextInset(
                    top: FujinSpace.s6,
                    bottom: FujinSpace.s2,
                    child: Text(
                      l10n.goalsSection,
                      style: FujinText.inter12Medium.copyWith(
                        color: FujinColorRole.textSecondary,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: FujinSize.goalFieldGap,
                    children: [
                      for (final MapEntry(key: nutrient, value: field)
                          in fields.entries)
                        GoalField(
                          label: GoalsText.label(l10n, nutrient),
                          unit: GoalsText.unit(l10n, nutrient),
                          hint: GoalsText.hint(l10n, nutrient),
                          controller: field,
                          onChanged: (_) => saved.value = false,
                        ),
                    ],
                  ),
                  if (energy case final energy?)
                    Padding(
                      padding: const EdgeInsets.only(top: FujinSpace.s3),
                      child: switch (GoalsText.energyNote(
                        l10n,
                        energy,
                        amounts[Nutrient.kilocalories],
                      )) {
                        (final title, final detail) => NoteCard(
                          title: title,
                          detail: detail,
                          background: FujinColorRole.backgroundInfo,
                          titleColor: FujinColorRole.textPrimary,
                          detailColor: FujinColorRole.textInfo,
                        ),
                      },
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                FujinSize.screenMargin,
                FujinSpace.s3,
                FujinSize.screenMargin,
                FujinSpace.s4,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: FujinSpace.s4,
                children: [
                  if (saved.value)
                    NoteCard(
                      title: l10n.goalsSavedTitle,
                      detail: l10n.goalsSavedDetail,
                      background: FujinColorRole.backgroundSuccess,
                      titleColor: FujinColorRole.textLink,
                      detailColor: FujinColorRole.textLink,
                    ),
                  FilledButton(
                    onPressed: save,
                    child: Text(switch (saved.value) {
                      true => l10n.saved,
                      false => l10n.save,
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
