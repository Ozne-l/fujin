import 'package:flutter/material.dart';
import 'package:fujin/app/fujin_route.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/adding/add_draft.dart';
import 'package:fujin/domain/adding/add_stage.dart';
import 'package:fujin/domain/journal/read_problem.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/adding/add_write_state.dart';
import 'package:fujin/pages/adding/widgets/side_row.dart';
import 'package:fujin/pages/adding/widgets/side_state.dart';
import 'package:fujin/pages/adding/widgets/write_actions.dart';
import 'package:fujin/pages/common/entry_text.dart';
import 'package:fujin/pages/common/fujin_spinner.dart';
import 'package:fujin/pages/common/in_page_sheet.dart';
import 'package:fujin/pages/common/pill_tone.dart';
import 'package:fujin/pages/common/sheet_card.dart';
import 'package:fujin/pages/common/sheet_pictogram.dart';
import 'package:fujin/pages/common/source_dot.dart';
import 'package:fujin/pages/journal/journal_text.dart';

class WritePanel extends StatelessWidget {
  const WritePanel({
    required this.state,
    required this.draft,
    required this.actions,
    super.key,
  });

  final AddWriteState state;
  final AddDraft draft;
  final WriteActions actions;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final meal = draft.mfpMealName;
    final children = switch (state) {
      AddWriteRunning(:final stage) => [
        _title(l10n.addingTitle),
        _Sides(
          mfp: switch (stage) {
            AddStage.mfp => SideState.writing,
            AddStage.ekklo => SideState.written,
          },
          ekklo: switch (stage) {
            AddStage.mfp => SideState.waiting,
            AddStage.ekklo => SideState.writing,
          },
          meal: meal,
        ),
        FilledButton.icon(
          onPressed: null,
          style: FilledButton.styleFrom(
            disabledForegroundColor: FujinColorRole.textSecondary,
          ),
          icon: const FujinSpinner.button(),
          label: Text(l10n.addAdding),
        ),
        _note(l10n.addAddingNote, center: true),
      ],
      AddWriteEkkloFailed(
        problem: ReadProblem.ekkloSessionExpired,
        :final undoing,
      ) =>
        [
          const SheetPictogram(
            icon: Icon(Icons.lock_outline),
            tone: PillTone.error,
          ),
          _source(l10n.sourceEkklo, FujinColorRole.sourceEkklo),
          _title(l10n.addEkkloSessionTitle),
          _Sides(mfp: SideState.written, ekklo: SideState.failed, meal: meal),
          _note(l10n.addEkkloFailedDetail),
          FilledButton(
            onPressed: switch (undoing) {
              true => null,
              false => () => actions.signIn(FujinRoute.ekkloSignIn),
            },
            child: Text(l10n.ekkloReconnect),
          ),
          OutlinedButton(
            onPressed: switch (undoing) {
              true => null,
              false => actions.undo,
            },
            child: Text(l10n.addCancelMfpEntry),
          ),
        ],
      AddWriteEkkloFailed(:final problem, :final undoing) => [
        const SheetPictogram(
          icon: Icon(Icons.warning_amber_rounded),
          tone: PillTone.error,
        ),
        _title(switch (problem) {
          ReadProblem.ekkloUnavailable ||
          ReadProblem.unknown => l10n.addEkkloNoReply,
          ReadProblem.offline ||
          ReadProblem.mfpSessionExpired ||
          ReadProblem.mfpUnavailable ||
          ReadProblem.ekkloSessionExpired => JournalText.problemHeadline(
            l10n,
            problem,
          ),
        }),
        _Sides(mfp: SideState.written, ekklo: SideState.failed, meal: meal),
        _note(l10n.addEkkloFailedDetail),
        FilledButton.icon(
          onPressed: switch (undoing) {
            true => null,
            false => actions.retryEkklo,
          },
          icon: const Icon(Icons.refresh),
          label: Text(l10n.addRetryEkklo),
        ),
        OutlinedButton(
          onPressed: switch (undoing) {
            true => null,
            false => actions.undo,
          },
          child: Text(l10n.addCancelMfpEntry),
        ),
      ],
      AddWriteFailed(problem: ReadProblem.mfpSessionExpired) => [
        const SheetPictogram(
          icon: Icon(Icons.lock_outline),
          tone: PillTone.error,
        ),
        _source(l10n.sourceMyFitnessPal, FujinColorRole.sourceMfp),
        _title(l10n.addMfpSessionTitle),
        _note(
          l10n.addMfpSessionDetail(
            draft.food.description,
            EntryText.serving(l10n, draft.entry),
            meal.toLowerCase(),
            draft.date,
          ),
        ),
        FilledButton(
          onPressed: () => actions.signIn(FujinRoute.mfpSignIn),
          child: Text(l10n.mfpReconnect),
        ),
        TextButton(onPressed: actions.dismiss, child: Text(l10n.later)),
      ],
      AddWriteFailed(problem: ReadProblem.ekkloSessionExpired) => [
        const SheetPictogram(
          icon: Icon(Icons.lock_outline),
          tone: PillTone.error,
        ),
        _source(l10n.sourceEkklo, FujinColorRole.sourceEkklo),
        _title(l10n.addEkkloSessionTitle),
        _note(l10n.addEkkloSessionDetail),
        FilledButton(
          onPressed: () => actions.signIn(FujinRoute.ekkloSignIn),
          child: Text(l10n.ekkloReconnect),
        ),
        TextButton(onPressed: actions.dismiss, child: Text(l10n.later)),
      ],
      AddWriteFailed(:final problem) => [
        const SheetPictogram(
          icon: Icon(Icons.warning_amber_rounded),
          tone: PillTone.error,
        ),
        _title(switch (problem) {
          ReadProblem.mfpUnavailable ||
          ReadProblem.unknown => l10n.addMfpNoReply,
          ReadProblem.offline ||
          ReadProblem.ekkloUnavailable ||
          ReadProblem.mfpSessionExpired ||
          ReadProblem.ekkloSessionExpired => JournalText.problemHeadline(
            l10n,
            problem,
          ),
        }),
        switch (problem) {
          ReadProblem.ekkloUnavailable || ReadProblem.ekkloSessionExpired =>
            _Sides(mfp: SideState.notSent, ekklo: SideState.failed, meal: meal),
          ReadProblem.offline => _Sides(
            mfp: SideState.notSent,
            ekklo: SideState.notSent,
            meal: meal,
          ),
          ReadProblem.mfpUnavailable ||
          ReadProblem.mfpSessionExpired ||
          ReadProblem.unknown => _Sides(
            mfp: SideState.failed,
            ekklo: SideState.notSent,
            meal: meal,
          ),
        },
        _note(l10n.addMfpFailedDetail),
        FilledButton.icon(
          onPressed: actions.retry,
          icon: const Icon(Icons.refresh),
          label: Text(l10n.tryAgain),
        ),
        OutlinedButton(
          onPressed: actions.dismiss,
          child: Text(l10n.addEditEntry),
        ),
      ],
      AddWriteIdle() || AddWriteDone() => const <Widget>[],
    };
    if (children.isEmpty) return const SizedBox.shrink();
    return InPageSheet(child: SheetCard(children: children));
  }

  static Widget _title(String text) => Text(
    text,
    style: FujinText.hina24.copyWith(color: FujinColorRole.textPrimary),
  );

  static Widget _note(String text, {bool center = false}) => Text(
    text,
    textAlign: switch (center) {
      true => TextAlign.center,
      false => TextAlign.start,
    },
    style: FujinText.inter14Regular.copyWith(
      color: FujinColorRole.textSecondary,
    ),
  );

  static Widget _source(String label, Color dot) => Row(
    spacing: FujinSpace.s2,
    children: [
      SourceDot(color: dot),
      Text(
        label,
        style: FujinText.inter12Medium.copyWith(
          color: FujinColorRole.textSecondary,
        ),
      ),
    ],
  );
}

class _Sides extends StatelessWidget {
  const _Sides({required this.mfp, required this.ekklo, required this.meal});

  final SideState mfp;
  final SideState ekklo;
  final String meal;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: FujinSpace.s4),
      decoration: BoxDecoration(
        color: FujinColorRole.backgroundPage,
        borderRadius: BorderRadius.circular(FujinRadius.field),
      ),
      child: Column(
        children: [
          SideRow(
            label: l10n.sourceMyFitnessPal,
            dot: FujinColorRole.sourceMfp,
            state: mfp,
            meal: meal,
          ),
          const Divider(height: FujinStroke.card, thickness: FujinStroke.card),
          SideRow(
            label: l10n.sourceEkklo,
            dot: FujinColorRole.sourceEkklo,
            state: ekklo,
            meal: meal,
          ),
        ],
      ),
    );
  }
}
