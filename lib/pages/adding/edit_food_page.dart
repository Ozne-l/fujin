import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/providers.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/adding/add_draft.dart';
import 'package:fujin/domain/comparison/compared_entry.dart';
import 'package:fujin/domain/comparison/compared_entry_lookup.dart';
import 'package:fujin/domain/editing/edit_opening.dart';
import 'package:fujin/domain/editing/edit_outcome.dart';
import 'package:fujin/domain/journal/journal_read.dart';
import 'package:fujin/domain/journal/read_problem.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/adding/edit_text.dart';
import 'package:fujin/pages/adding/food_view_mode.dart';
import 'package:fujin/pages/adding/widgets/edit_food_header.dart';
import 'package:fujin/pages/adding/widgets/food_view.dart';
import 'package:fujin/pages/common/fujin_spinner.dart';
import 'package:fujin/pages/journal/journal_notifier.dart';
import 'package:fujin/pages/journal/journal_text.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

final FutureProviderFamily<EditOpening, MfpFoodEntry> editOpeningProvider =
    FutureProvider.autoDispose.family<EditOpening, MfpFoodEntry>(
      (ref, entry) => ref.watch(editEntryServiceProvider).open(entry),
      retry: (retryCount, error) => null,
    );

class EditFoodPage extends HookConsumerWidget {
  const EditFoodPage({required this.date, required this.entryId, super.key});

  final DateTime date;
  final String entryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journal = ref.watch(journalProvider(date));
    final shown = switch (journal.value) {
      BothSides(:final day) => day.comparison.entryWithId(entryId),
      MfpOnly() || EkkloOnly() || null => null,
    };
    final held = useRef<ComparedEntry?>(null)..value ??= shown;
    final gone = held.value == null && !journal.isLoading;
    useEffect(() {
      if (gone) {
        unawaited(
          Future(() {
            if (context.mounted) context.pop();
          }),
        );
      }
      return null;
    }, [gone]);

    Widget frame(ComparedEntry original, Widget body) => Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            EditFoodHeader(entry: original.entry, onBack: context.pop),
            Expanded(child: body),
          ],
        ),
      ),
    );

    Widget reason(String text) => Padding(
      padding: const EdgeInsets.all(FujinSize.screenMargin),
      child: Text(
        text,
        style: FujinText.inter15RegularL22.copyWith(
          color: context.colors.textSecondary,
        ),
      ),
    );

    String unopened(ReadProblem problem) =>
        EditText.readOnly(context.intl, problem) ??
        JournalText.problemHeadline(context.intl, problem);

    Widget fiche(
      ComparedEntry original,
      AddDraft draft, {
      required bool newVersion,
    }) => Scaffold(
      body: SafeArea(
        bottom: false,
        child: FoodView(
          key: ValueKey(draft),
          initial: draft,
          mode: EditingFood(
            entryId: entryId,
            original: original,
            newVersion: newVersion,
            onLeave: (outcome) => context.pop<EditOutcome>(outcome),
          ),
          onBack: context.pop,
        ),
      ),
    );

    return switch (held.value) {
      null => const Scaffold(body: Center(child: FujinSpinner.card())),
      final original => switch (ref.watch(
        editOpeningProvider(original.entry),
      )) {
        AsyncValue(value: Opened(:final draft)) => fiche(
          original,
          draft,
          newVersion: false,
        ),
        AsyncValue(value: OpenedOnNewVersion(:final draft)) => fiche(
          original,
          draft,
          newVersion: true,
        ),
        AsyncValue(value: FoodUnreadable()) => frame(
          original,
          reason(context.intl.editFoodUnreadable),
        ),
        AsyncValue(value: ServingMissing()) => frame(
          original,
          reason(context.intl.editServingMissing),
        ),
        AsyncValue(:final error?) => frame(
          original,
          reason(unopened(ReadProblem.of(error))),
        ),
        AsyncValue() => frame(
          original,
          const Center(child: FujinSpinner.card()),
        ),
      },
    };
  }
}
