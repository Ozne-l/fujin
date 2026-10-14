import 'package:flutter/material.dart' hide StepState;
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/sending/send_step.dart';
import 'package:fujin/domain/sending/step_state.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/breeze_indicator.dart';
import 'package:fujin/pages/common/breeze_streaks.dart';

class StepList extends StatelessWidget {
  const StepList({required this.steps, super.key});

  final List<SendStep> steps;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: FujinSize.screenMargin),
      padding: const EdgeInsets.fromLTRB(
        FujinSpace.s5,
        FujinSpace.s4,
        FujinSpace.s5,
        FujinSpace.s4,
      ),
      decoration: BoxDecoration(
        color: FujinColorRole.backgroundCard,
        borderRadius: BorderRadius.circular(FujinRadius.card),
        border: Border.all(color: FujinColorRole.borderCard),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (index, step) in steps.indexed) ...[
            if (index > 0)
              const Padding(
                padding: EdgeInsetsDirectional.only(
                  start: FujinSize.stepMarker + FujinSpace.s4,
                  top: FujinSpace.s3,
                  bottom: FujinSpace.s3,
                ),
                child: Divider(),
              ),
            _row(context.intl, step),
          ],
        ],
      ),
    );
  }

  Widget _row(AppLocalizations intl, SendStep step) {
    final (title, subtitle, subtitleColor) = _texts(intl, step);
    return Row(
      spacing: FujinSpace.s4,
      children: [
        _marker(step.state),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: FujinSize.textGap,
            children: [
              Text(
                title,
                style: FujinText.inter15Medium.copyWith(
                  color: FujinColorRole.textPrimary,
                ),
              ),
              Text(
                subtitle,
                style: FujinText.inter13Regular.copyWith(color: subtitleColor),
              ),
            ],
          ),
        ),
      ],
    );
  }

  (String, String, Color) _texts(
    AppLocalizations intl,
    SendStep step,
  ) => switch ((step, step.state)) {
    (OwnCopyStep(:final name), StepState.done) => (
      intl.stepOwnCopyDone,
      name,
      FujinColorRole.textSecondary,
    ),
    (OwnCopyStep(:final name), StepState.running) => (
      intl.stepOwnCopy,
      intl.stepOnTheWay(name),
      FujinColor.sora,
    ),
    (OwnCopyStep(:final name), StepState.pending) => (
      intl.stepOwnCopy,
      intl.stepWaiting(name),
      FujinColorRole.textTertiary,
    ),
    (OwnCopyStep(), StepState.failed) => (
      intl.stepOwnCopy,
      intl.stepFailed,
      FujinColorRole.textAlert,
    ),
    (MealStep(:final ekkloMealName, :final entryIds), StepState.done) => (
      ekkloMealName,
      intl.stepFoodsAdded(entryIds.length),
      FujinColorRole.textSecondary,
    ),
    (MealStep(:final ekkloMealName, :final entryIds), StepState.running) => (
      ekkloMealName,
      intl.stepOnTheWay(intl.stepFoods(entryIds.length)),
      FujinColor.sora,
    ),
    (MealStep(:final ekkloMealName, :final entryIds), StepState.pending) => (
      ekkloMealName,
      intl.stepWaiting(intl.stepFoods(entryIds.length)),
      FujinColorRole.textTertiary,
    ),
    (MealStep(:final ekkloMealName, :final entryIds), StepState.failed) => (
      ekkloMealName,
      intl.stepFoodsNotSent(entryIds.length),
      FujinColorRole.textAlert,
    ),
    (QuantityUpdateStep(:final name), StepState.done) => (
      name,
      intl.stepQuantityDone,
      FujinColorRole.textSecondary,
    ),
    (QuantityUpdateStep(:final name), StepState.running) => (
      name,
      intl.stepOnTheWay(intl.stepQuantity),
      FujinColor.sora,
    ),
    (QuantityUpdateStep(:final name), StepState.pending) => (
      name,
      intl.stepWaiting(intl.stepQuantity),
      FujinColorRole.textTertiary,
    ),
    (QuantityUpdateStep(:final name), StepState.failed) => (
      name,
      intl.stepQuantityFailed,
      FujinColorRole.textAlert,
    ),
  };

  Widget _marker(StepState state) => switch (state) {
    StepState.done => const _Circle(
      color: FujinColor.fujin,
      child: Icon(
        Icons.check,
        size: FujinSize.stepIcon,
        color: FujinColorRole.textOnDark,
      ),
    ),
    StepState.running => const _Circle(
      color: FujinColorRole.backgroundInfo,
      child: BreezeIndicator(streaks: BreezeStreaks.marker),
    ),
    StepState.pending => const _Circle(
      color: FujinColorRole.backgroundCard,
      border: FujinColorRole.borderCard,
    ),
    StepState.failed => const _Circle(
      color: FujinColorRole.backgroundAlert,
      child: Icon(
        Icons.close,
        size: FujinSize.stepIcon,
        color: FujinColorRole.textAlert,
      ),
    ),
  };
}

class _Circle extends StatelessWidget {
  const _Circle({required this.color, this.border, this.child});

  final Color color;
  final Color? border;
  final Widget? child;

  @override
  Widget build(BuildContext context) => Container(
    width: FujinSize.stepMarker,
    height: FujinSize.stepMarker,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: color,
      shape: BoxShape.circle,
      border: switch (border) {
        null => null,
        final border => Border.all(color: border, width: FujinStroke.dayRing),
      },
    ),
    child: child,
  );
}
