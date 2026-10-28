import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/sending/food_words.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/alert_pictogram.dart';
import 'package:fujin/pages/common/entry_text.dart';
import 'package:fujin/pages/common/glass_finish.dart';
import 'package:fujin/pages/common/sheet_frame.dart';
import 'package:fujin/pages/common/trash_icon.dart';
import 'package:fujin/pages/journal/entry_removal.dart';
import 'package:fujin/pages/journal/remove_entry_notifier.dart';
import 'package:fujin/pages/journal/remove_entry_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> showRemoveSheet(
  BuildContext context, {
  required EntryRemoval removal,
  required bool inEkklo,
}) {
  unawaited(HapticFeedback.mediumImpact());
  return SheetFrame.show(
    context,
    builder: (context) => _RemoveSheet(removal: removal, inEkklo: inEkklo),
  );
}

class _RemoveSheet extends ConsumerWidget {
  const _RemoveSheet({required this.removal, required this.inEkklo});

  final EntryRemoval removal;
  final bool inEkklo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final running = switch (ref.watch(removeEntryProvider)) {
      RemoveEntryRunning() => true,
      RemoveEntryIdle() || RemoveEntryDone() || RemoveEntryFailed() => false,
    };
    final navigator = Navigator.of(context);
    ref.listen(removeEntryProvider, (previous, next) {
      if ((previous, next) case (
        RemoveEntryRunning(removal: final ran),
        RemoveEntryDone() || RemoveEntryFailed(),
      ) when ran == removal) {
        navigator.pop();
      }
    });
    final entry = removal.entry;
    final intl = context.intl;
    final detail = switch (inEkklo) {
      true => intl.deleteFoodDetail,
      false => intl.deleteFoodDetailMfpOnly,
    };
    return SheetFrame(
      glyph: const AlertPictogram(icon: TrashIcon.asset),
      title: intl.deleteFoodTitle(productName(entry.food)),
      titleStyle: FujinText.hina24,
      subtitle: detail(
        EntryText.serving(intl, entry),
        EntryText.energy(intl, entry),
        entry.mealName,
        entry.date,
      ),
      subtitleStyle: FujinText.inter15RegularL22,
      primaryLabel: switch (inEkklo) {
        true => intl.editDeleteBoth,
        false => intl.editDeleteMfpOnly,
      },
      primaryFinish: GlassFinish.alert,
      busy: running,
      onPrimary: () =>
          unawaited(ref.read(removeEntryProvider.notifier).remove(removal)),
      onSkip: navigator.pop,
      skipLabel: intl.deleteKeep,
    );
  }
}
