import 'package:flutter/material.dart';
import 'package:fujin/app/fujin_route.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/adding/add_draft.dart';
import 'package:fujin/domain/adding/add_stage.dart';
import 'package:fujin/domain/journal/read_problem.dart';
import 'package:fujin/l10n/intl_context.dart';
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
    final meal = draft.mfpMealName;
    final children = switch (state) {
      AddWriteRunning(:final stage) => [
        _title(context.colors, context.intl.addingTitle),
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
            disabledForegroundColor: context.colors.textSecondary,
          ),
          icon: const FujinSpinner.button(),
          label: Text(context.intl.addAdding),
        ),
        _note(context.colors, context.intl.addAddingNote, center: true),
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
          _source(
            context.colors,
            context.intl.sourceEkklo,
            context.colors.sourceEkklo,
          ),
          _title(context.colors, context.intl.addEkkloSessionTitle),
          _Sides(mfp: SideState.written, ekklo: SideState.failed, meal: meal),
          _note(context.colors, context.intl.addEkkloFailedDetail),
          FilledButton(
            onPressed: switch (undoing) {
              true => null,
              false => () => actions.signIn(FujinRoute.ekkloSignIn),
            },
            child: Text(context.intl.ekkloReconnect),
          ),
          OutlinedButton(
            onPressed: switch (undoing) {
              true => null,
              false => actions.undo,
            },
            child: Text(context.intl.addCancelMfpEntry),
          ),
        ],
      AddWriteEkkloFailed(:final problem, :final undoing) => [
        const SheetPictogram(
          icon: Icon(Icons.warning_amber_rounded),
          tone: PillTone.error,
        ),
        _title(context.colors, switch (problem) {
          ReadProblem.ekkloUnavailable ||
          ReadProblem.unknown => context.intl.addEkkloNoReply,
          ReadProblem.offline ||
          ReadProblem.mfpSessionExpired ||
          ReadProblem.mfpUnavailable ||
          ReadProblem.ekkloSessionExpired => JournalText.problemHeadline(
            context.intl,
            problem,
          ),
        }),
        _Sides(mfp: SideState.written, ekklo: SideState.failed, meal: meal),
        _note(context.colors, context.intl.addEkkloFailedDetail),
        FilledButton.icon(
          onPressed: switch (undoing) {
            true => null,
            false => actions.retryEkklo,
          },
          icon: const Icon(Icons.refresh),
          label: Text(context.intl.addRetryEkklo),
        ),
        OutlinedButton(
          onPressed: switch (undoing) {
            true => null,
            false => actions.undo,
          },
          child: Text(context.intl.addCancelMfpEntry),
        ),
      ],
      AddWriteFailed(blockedInDev: true) => [
        const SheetPictogram(
          icon: Icon(Icons.warning_amber_rounded),
          tone: PillTone.error,
        ),
        _title(context.colors, context.intl.writeBlockedInDev),
        _Sides(mfp: SideState.notSent, ekklo: SideState.notSent, meal: meal),
        OutlinedButton(
          onPressed: actions.dismiss,
          child: Text(context.intl.addEditEntry),
        ),
      ],
      AddWriteFailed(problem: ReadProblem.mfpSessionExpired) => [
        const SheetPictogram(
          icon: Icon(Icons.lock_outline),
          tone: PillTone.error,
        ),
        _source(
          context.colors,
          context.intl.sourceMyFitnessPal,
          context.colors.sourceMfp,
        ),
        _title(context.colors, context.intl.addMfpSessionTitle),
        _note(
          context.colors,
          context.intl.addMfpSessionDetail(
            draft.food.description,
            EntryText.serving(context.intl, draft.entry),
            meal.toLowerCase(),
            draft.date,
          ),
        ),
        FilledButton(
          onPressed: () => actions.signIn(FujinRoute.mfpSignIn),
          child: Text(context.intl.mfpReconnect),
        ),
        TextButton(onPressed: actions.dismiss, child: Text(context.intl.later)),
      ],
      AddWriteFailed(problem: ReadProblem.ekkloSessionExpired) => [
        const SheetPictogram(
          icon: Icon(Icons.lock_outline),
          tone: PillTone.error,
        ),
        _source(
          context.colors,
          context.intl.sourceEkklo,
          context.colors.sourceEkklo,
        ),
        _title(context.colors, context.intl.addEkkloSessionTitle),
        _note(context.colors, context.intl.addEkkloSessionDetail),
        FilledButton(
          onPressed: () => actions.signIn(FujinRoute.ekkloSignIn),
          child: Text(context.intl.ekkloReconnect),
        ),
        TextButton(onPressed: actions.dismiss, child: Text(context.intl.later)),
      ],
      AddWriteFailed(:final problem) => [
        const SheetPictogram(
          icon: Icon(Icons.warning_amber_rounded),
          tone: PillTone.error,
        ),
        _title(context.colors, switch (problem) {
          ReadProblem.mfpUnavailable ||
          ReadProblem.unknown => context.intl.addMfpNoReply,
          ReadProblem.offline ||
          ReadProblem.ekkloUnavailable ||
          ReadProblem.mfpSessionExpired ||
          ReadProblem.ekkloSessionExpired => JournalText.problemHeadline(
            context.intl,
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
        _note(context.colors, context.intl.addMfpFailedDetail),
        FilledButton.icon(
          onPressed: actions.retry,
          icon: const Icon(Icons.refresh),
          label: Text(context.intl.tryAgain),
        ),
        OutlinedButton(
          onPressed: actions.dismiss,
          child: Text(context.intl.addEditEntry),
        ),
      ],
      AddWriteIdle() || AddWriteDone() => const <Widget>[],
    };
    if (children.isEmpty) return const SizedBox.shrink();
    return InPageSheet(child: SheetCard(children: children));
  }

  static Widget _title(FujinColors colors, String text) => Text(
    text,
    style: FujinText.hina24.copyWith(color: colors.textPrimary),
  );

  static Widget _note(FujinColors colors, String text, {bool center = false}) =>
      Text(
        text,
        textAlign: switch (center) {
          true => TextAlign.center,
          false => TextAlign.start,
        },
        style: FujinText.inter14Regular.copyWith(
          color: colors.textSecondary,
        ),
      );

  static Widget _source(FujinColors colors, String label, Color dot) => Row(
    spacing: FujinSpace.s2,
    children: [
      SourceDot(color: dot),
      Text(
        label,
        style: FujinText.inter12Medium.copyWith(
          color: colors.textSecondary,
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: FujinSpace.s4),
      decoration: BoxDecoration(
        color: context.colors.backgroundPage,
        borderRadius: BorderRadius.circular(FujinRadius.field),
      ),
      child: Column(
        children: [
          SideRow(
            label: context.intl.sourceMyFitnessPal,
            dot: context.colors.sourceMfp,
            state: mfp,
            meal: meal,
          ),
          const Divider(height: FujinStroke.card, thickness: FujinStroke.card),
          SideRow(
            label: context.intl.sourceEkklo,
            dot: context.colors.sourceEkklo,
            state: ekklo,
            meal: meal,
          ),
        ],
      ),
    );
  }
}
