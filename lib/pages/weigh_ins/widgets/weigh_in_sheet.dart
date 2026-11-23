import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_haptics.dart';
import 'package:fujin/app/theme/fujin_theme.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/data/weigh_ins/weigh_in.dart';
import 'package:fujin/domain/weighing/kilograms.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/code_keypad.dart';
import 'package:fujin/pages/common/day_picker_button.dart';
import 'package:fujin/pages/common/field_helper.dart';
import 'package:fujin/pages/common/glass_fill.dart';
import 'package:fujin/pages/common/glass_finish.dart';
import 'package:fujin/pages/common/keypad_field.dart';
import 'package:fujin/pages/common/locale_numbers.dart';
import 'package:fujin/pages/common/note_card.dart';
import 'package:fujin/pages/common/sheet_card.dart';
import 'package:fujin/pages/common/sheet_frame.dart';
import 'package:fujin/pages/journal/selected_day.dart';
import 'package:fujin/pages/weigh_ins/kilograms_typing.dart';
import 'package:fujin/pages/weigh_ins/live_weigh_in.dart';
import 'package:fujin/pages/weigh_ins/weigh_in_snack_bar.dart';
import 'package:fujin/pages/weigh_ins/weigh_in_text.dart';
import 'package:fujin/pages/weigh_ins/weigh_ins_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WeighInSheet extends HookConsumerWidget {
  const WeighInSheet({this.editing, this.onDelete, super.key});

  final WeighIn? editing;
  final VoidCallback? onDelete;

  static Future<void> show(
    BuildContext context, {
    WeighIn? editing,
    VoidCallback? onDelete,
  }) => SheetFrame.show(
    context,
    builder: (context) => WeighInSheet(editing: editing, onDelete: onDelete),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final intl = context.intl;
    final colors = context.colors;
    final today = ref.watch(todayProvider);
    final separator = LocaleNumbers.separator(context);
    final typing = useState(switch (editing) {
      final weighIn? => KilogramsTyping.of(
        weighIn.kilograms,
        separator: separator,
      ),
      null => KilogramsTyping(separator: separator),
    });
    final day = useState(editing?.date ?? today);
    final replaced = useMemoized(
      () => switch (editing) {
        _? => null,
        null => ref.read(weighInsProvider).liveOn(day.value),
      },
      [day.value],
    );
    final save = switch (typing.value.kilograms) {
      final kilograms? => () {
        final saved = ref
            .read(weighInsProvider.notifier)
            .save(date: day.value, kilograms: kilograms);
        FujinHaptics.success();
        WeighInSnackBar.saved(context, saved, today: today);
        Navigator.of(context).pop();
      },
      null => null,
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SheetCard(
          handle: true,
          spacing: FujinSpace.s3,
          bottomSafe: false,
          children: [
            Text(
              switch (editing) {
                _? => intl.weighInEdit,
                null => intl.weighInNew,
              },
              style: FujinText.hina24.copyWith(color: colors.textPrimary),
            ),
            switch (editing) {
              final weighIn? => Text(
                WeighInText.longDay(intl, weighIn.date),
                style: FujinText.inter15Regular.copyWith(
                  color: colors.textSecondary,
                ),
              ),
              null => DayPickerButton(
                label: WeighInText.day(intl, day.value, today: today),
                selected: day.value,
                first: today.subtract(DayPickerButton.span),
                last: today,
                onPicked: (picked) =>
                    day.value = SelectedDay.calendarDay(picked),
                iconColor: colors.textSecondary,
              ),
            },
            KeypadField(
              value: typing.value.text,
              error: typing.value.outOfRange,
              suffix: intl.kilogramsSuffix,
            ),
            if (typing.value.outOfRange)
              FieldHelper(
                icon: Icons.warning_amber_rounded,
                text: intl.weighInRange(Kilograms.lightest, Kilograms.heaviest),
                color: colors.textAlert,
              ),
            if (replaced case final replaced?)
              NoteCard(
                title: intl.weighInReplaceTitle(
                  intl.weighInKilograms(replaced.kilograms),
                ),
                detail: intl.weighInReplaceDetail,
                background: colors.backgroundInfo,
                titleColor: colors.textPrimary,
                detailColor: colors.textInfo,
              ),
            FilledButton(
              onPressed: save,
              child: Text(switch (replaced) {
                _? => intl.weighInReplace,
                null => intl.save,
              }),
            ),
            if (onDelete case final onDelete?)
              OutlinedButton(
                style: GlassFill.style(
                  colors,
                  GlassFinish.alert,
                ).merge(FujinTheme.largeOutlinedButtonStyle),
                onPressed: () {
                  Navigator.of(context).pop();
                  onDelete();
                },
                child: Text(intl.weighInDelete),
              ),
          ],
        ),
        CodeKeypad(
          onDigit: (digit) => typing.value = typing.value.pressed(digit),
          onErase: () => typing.value = typing.value.erased(),
          separator: (
            separator,
            () => typing.value = typing.value.separated(),
          ),
        ),
      ],
    );
  }
}
