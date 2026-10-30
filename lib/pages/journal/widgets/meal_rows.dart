import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/app/theme/instant_motion.dart';
import 'package:fujin/data/entries/ekklo_link.dart';
import 'package:fujin/domain/comparison/compared_entry.dart';
import 'package:fujin/domain/comparison/entry_status.dart';
import 'package:fujin/domain/comparison/mfp_status.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/entry_text.dart';
import 'package:fujin/pages/common/pill_tone.dart';
import 'package:fujin/pages/common/status_pill.dart';
import 'package:fujin/pages/journal/background_write_notifier.dart';
import 'package:fujin/pages/journal/widgets/entry_row.dart';
import 'package:fujin/pages/journal/widgets/swipe_row.dart';
import 'package:fujin/pages/journal/writer_state_ids.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:motor/motor.dart';

class MealRows extends HookWidget {
  const MealRows({
    required this.entries,
    required this.groupTag,
    required this.removable,
    required this.removedEntryId,
    required this.onOpen,
    required this.onRemove,
    super.key,
  });

  final List<ComparedEntry> entries;
  final Object groupTag;
  final bool removable;
  final String? removedEntryId;
  final ValueChanged<ComparedEntry> onOpen;
  final ValueChanged<ComparedEntry> onRemove;

  @override
  Widget build(BuildContext context) {
    final heights = useRef(<String, double>{});
    final previous = usePrevious(entries);
    final cascade = useRef<_Cascade?>(null);
    final generation = useRef(0);
    if (_Cascade.of(
          removedEntryId,
          before: previous,
          after: entries,
          heights: heights.value,
        )
        case final started? when started.entryId != cascade.value?.entryId) {
      cascade.value = started;
      generation.value++;
    }
    final running = cascade.value;
    final start = generation.value - 1;

    Widget slot(ComparedEntry compared) {
      final row = Padding(
        padding: const EdgeInsets.symmetric(vertical: FujinSpace.s3),
        child: _EntryRow(compared),
      );
      return _Measured(
        onHeight: (height) {
          if (compared.entryId case final id?) heights.value[id] = height;
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Divider(),
            switch (compared.entryId) {
              null => row,
              final id => SwipeRow(
                key: ValueKey(id),
                groupTag: groupTag,
                enabled: removable,
                label: context.intl.rowDelete,
                onRemove: () => onRemove(compared),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onOpen(compared),
                  child: row,
                ),
              ),
            },
          ],
        ),
      );
    }

    return SingleMotionBuilder(
      motion: switch (running) {
        null => const InstantMotion(),
        final running => FujinMotion.of(
          context,
          LinearMotion(running.duration),
        ),
      },
      value: generation.value.toDouble(),
      builder: (context, value, _) {
        final progress = value - start;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final (index, compared) in entries.indexed)
              Transform.translate(
                key: ValueKey<Object>(compared.entryId ?? compared.logged),
                offset: Offset(0, running?.shift(index, progress) ?? 0),
                child: slot(compared),
              ),
            SizedBox(height: running?.spacer(progress) ?? 0),
          ],
        );
      },
    );
  }
}

final class _Cascade {
  const _Cascade({
    required this.entryId,
    required this.index,
    required this.slot,
    required this.rising,
  });

  final String entryId;
  final int index;
  final double slot;
  final int rising;

  static _Cascade? of(
    String? entryId, {
    required List<ComparedEntry>? before,
    required List<ComparedEntry> after,
    required Map<String, double> heights,
  }) {
    if ((entryId, before, heights[entryId]) case (
      final id?,
      final before?,
      final height?,
    ) when !after.any((compared) => compared.entryId == id)) {
      final index = before.indexWhere((compared) => compared.entryId == id);
      if (index < 0 || after.isEmpty) return null;
      return _Cascade(
        entryId: id,
        index: index,
        slot: height,
        rising: after.length - index,
      );
    }
    return null;
  }

  int get _last => switch (rising) {
    0 => 0,
    _ => rising - 1,
  };

  Duration get duration =>
      FujinMotion.rowRemovalStagger * (_last + 1) +
      FujinMotion.rowRemoval.duration;

  double _progress(int step, double progress) {
    final total = duration.inMicroseconds;
    final start = (FujinMotion.rowRemovalStagger * (step + 1)).inMicroseconds;
    final end = start + FujinMotion.rowRemoval.duration.inMicroseconds;
    return FujinMotion.rowRemoval.curve.transform(
      Interval(start / total, end / total).transform(progress.clamp(0, 1)),
    );
  }

  double shift(int index, double progress) => switch (index - this.index) {
    final step when step >= 0 => slot * (1 - _progress(step, progress)),
    _ => 0,
  };

  double spacer(double progress) => slot * (1 - _progress(_last, progress));
}

class _Measured extends SingleChildRenderObjectWidget {
  const _Measured({required this.onHeight, required super.child});

  final ValueChanged<double> onHeight;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderMeasured(onHeight);

  @override
  void updateRenderObject(BuildContext context, _RenderMeasured renderObject) {
    renderObject.onHeight = onHeight;
  }
}

class _RenderMeasured extends RenderProxyBox {
  _RenderMeasured(this.onHeight);

  ValueChanged<double> onHeight;

  @override
  void performLayout() {
    super.performLayout();
    onHeight(size.height);
  }
}

class _EntryRow extends ConsumerWidget {
  const _EntryRow(this.compared);

  final ComparedEntry compared;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entry = compared.logged;
    final failed = ref.watch(
      backgroundWriteProvider.select(
        (state) => state.mfpFailedIds.contains(entry.entry.id),
      ),
    );
    final detail = switch (compared.status) {
      ToUpdate(link: EkkloLink(:final item?)) => EntryText.linkedServing(
        context.intl,
        item,
      ),
      InEkklo() || ToSend() || ToUpdate() => EntryText.macros(
        context.intl,
        entry.entry.nutrients,
      ),
    };
    final (label, tone, icon) = switch (compared.status) {
      InEkklo() => (context.intl.statusInEkklo, PillTone.validated, null),
      ToSend() => (context.intl.statusToSend, PillTone.attention, null),
      ToUpdate() => (context.intl.statusToUpdate, PillTone.info, Icons.refresh),
    };
    return EntryRow(
      entry: entry,
      detail: detail,
      pill: StatusPill(label: label, tone: tone, icon: icon),
      mfp: switch (compared.mfp) {
        MfpPending() when failed => const MfpFailed(),
        final mfp => mfp,
      },
    );
  }
}
